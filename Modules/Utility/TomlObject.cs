using System.Collections;
using System.Globalization;
using System.Management.Automation;
using System.Management.Automation.Language;
using System.Numerics;
using System.Reflection;
using System.Text.Json.Serialization;
using Humanizer;
using Microsoft.PowerShell.Commands;
using Tomlyn;
using Tomlyn.Model;
using Tomlyn.Serialization;

namespace Utility;

public static class TomlObject
{
    #region Helpers
    public readonly record struct ConvertToTomlContext(
        int MaxDepth,
        bool EnumsAsStrings,
        PSCmdlet Cmdlet,
        ITomlMetadataStore? MetadataStore,
        CancellationToken CancellationToken
    ) { }

    public class StringEnumConverter : TomlConverter
    {
        public bool AllowIntegerValues { get; set; }

        public override bool CanConvert(Type typeToConvert) =>
            (Nullable.GetUnderlyingType(typeToConvert) ?? typeToConvert).IsEnum;

        public override object? Read(TomlReader reader, Type typeToConvert)
        {
            if (reader.TokenType == TomlTokenType.None)
            {
                if (Nullable.GetUnderlyingType(typeToConvert) == null)
                {
                    throw reader.CreateException(
                        "Cannot convert null value to {0}.".FormatWith(
                            CultureInfo.InvariantCulture,
                            typeToConvert
                        )
                    );
                }
                return null;
            }

            var t = Nullable.GetUnderlyingType(typeToConvert);
            var isNullable = t != null;
            t ??= typeToConvert;

            try
            {
                var isInt = false;
                // TOML supports Int64
                var intVal = -1L;

                if (reader.TokenType == TomlTokenType.String)
                {
                    var enumText = reader.GetString();
                    if (string.IsNullOrEmpty(enumText) && isNullable)
                    {
                        return null;
                    }
                    isInt = long.TryParse(enumText, out intVal);
                    if (!isInt)
                    {
                        if (!Enum.TryParse(t, enumText, true, out var value))
                        {
                            throw reader.CreateException(
                                "Error converting String {0} to type '{1}'.".FormatWith(
                                    CultureInfo.InvariantCulture,
                                    enumText,
                                    typeToConvert
                                )
                            );
                        }
                        return value;
                    }
                }
                else if (reader.TokenType == TomlTokenType.Integer)
                {
                    isInt = true;
                    intVal = reader.GetInt64();
                }

                if (isInt)
                {
                    if (!AllowIntegerValues)
                    {
                        throw reader.CreateException(
                            "Integer value {0} is not allowed.".FormatWith(
                                CultureInfo.InvariantCulture,
                                intVal
                            )
                        );
                    }
                    var value = Enum.ToObject(t, intVal);
                    if (!t.IsInstanceOfType(value))
                    {
                        throw reader.CreateException(
                            "Error converting Integer {0} to type '{1}', out of range.".FormatWith(
                                CultureInfo.InvariantCulture,
                                intVal,
                                t
                            )
                        );
                    }
                    return value;
                }
            }
            catch (Exception ex)
            {
                throw reader.CreateException(
                    "Error converting value {0} to type '{1}': {2}".FormatWith(
                        CultureInfo.InvariantCulture,
                        reader.GetRawText(),
                        typeToConvert,
                        ex
                    )
                );
            }

            // we don't actually expect to get here.
            throw reader.CreateException(
                "Unexpected token {0} when parsing enum.".FormatWith(
                    CultureInfo.InvariantCulture,
                    reader.TokenType
                )
            );
        }

        public override void Write(TomlWriter writer, object? value)
        {
            if (value == null)
            {
                writer.WriteEndTable();
                return;
            }
            writer.WriteStringValue(((Enum)value).ToString());
        }
    }

    #endregion

    #region ConvertFromToml

    /// <summary>
    /// Convert a Json string back to an object of type PSObject.
    /// </summary>
    /// <param name="input">The json text to convert.</param>
    /// <param name="error">An error record if the conversion failed.</param>
    /// <returns>A PSObject.</returns>
    public static object? ConvertFromToml(string input, out ErrorRecord? error)
    {
        return ConvertFromToml(input, returnHashtable: false, out error);
    }

    /// <summary>
    /// Convert a Json string back to an object of type <see cref="PSObject"/> or
    /// <see cref="Hashtable"/> depending on parameter <paramref name="returnHashtable"/>.
    /// </summary>
    /// <param name="input">The json text to convert.</param>
    /// <param name="returnHashtable">True if the result should be returned as a <see cref="Hashtable"/>
    /// instead of a <see cref="PSObject"/></param>
    /// <param name="error">An error record if the conversion failed.</param>
    /// <returns>A <see cref="PSObject"/> or a <see cref="Hashtable"/>
    /// if the <paramref name="returnHashtable"/> parameter is true.</returns>
    public static object? ConvertFromToml(
        string input,
        bool returnHashtable,
        out ErrorRecord? error
    )
    {
        return ConvertFromToml(input, returnHashtable, maxDepth: 1024, out error);
    }

    public static object? ConvertFromToml(
        string input,
        bool returnHashtable,
        int maxDepth,
        out ErrorRecord? error
    )
    {
        return ConvertFromToml(input, returnHashtable, maxDepth, false, out var store, out error);
    }

    /// <summary>
    /// Convert a TOML string back to an object of type <see cref="PSObject"/> or
    /// <see cref="Hashtable"/> depending on parameter <paramref name="returnHashtable"/>.
    /// </summary>
    /// <param name="input">The TOML text to convert.</param>
    /// <param name="returnHashtable">True if the result should be returned as a <see cref="Hashtable"/>
    /// instead of a <see cref="PSObject"/>.</param>
    /// <param name="maxDepth">The max depth allowed when deserializing the json input. Set to null for no maximum.</param>
    /// <param name="error">An error record if the conversion failed.</param>
    /// <returns>A <see cref="PSObject"/> or a <see cref="Hashtable"/>
    /// if the <paramref name="returnHashtable"/> parameter is true.</returns>
    internal static object? ConvertFromToml(
        string input,
        bool returnHashtable,
        int maxDepth,
        bool returnMetadataStore,
        out TomlMetadataStore? store,
        out ErrorRecord? error
    )
    {
        ArgumentNullException.ThrowIfNull(input);
        store = null;
        error = null;

        if (returnMetadataStore)
        {
            store = new TomlMetadataStore();
        }

        try
        {
            var table =
                TomlSerializer.Deserialize<TomlTable>(
                    input,
                    new TomlSerializerOptions
                    {
                        PropertyNameCaseInsensitive = !returnHashtable,
                        DuplicateKeyHandling = TomlDuplicateKeyHandling.Error,
                        MetadataStore = store,
                        MaxDepth = maxDepth,
                    }
                ) ?? throw new InvalidDataException("Toml Deserialize returns null.");
            return returnHashtable
                ? PopulateHashTableFromTomlTable(table, out error)
                : PopulateFromTomlTable(
                    table,
                    new(table.Count, StringComparer.OrdinalIgnoreCase),
                    out error
                );
        }
        catch (TomlException te)
        {
            var msg = string.Format(
                CultureInfo.CurrentCulture,
                WebCmdletStrings.JsonDeserializationFailed,
                te.Message
            );

            // the same as JavaScriptSerializer does
            throw new ArgumentException(msg, te);
        }
    }

    private static object? PopulateFromTomlTable(
        TomlTable table,
        HashSet<string> memberHashTracker,
        out ErrorRecord? error
    )
    {
        error = null;
        var result = new PSObject(table.Count);

        foreach (var entry in table)
        {
            if (string.IsNullOrEmpty(entry.Key))
            {
                var errorMsg = string.Format(
                    CultureInfo.CurrentCulture,
                    WebCmdletStrings.EmptyKeyInJsonString
                );
                error = new ErrorRecord(
                    new InvalidOperationException(errorMsg),
                    "EmptyKeyInJsonString",
                    ErrorCategory.InvalidOperation,
                    null
                );
                return null;
            }

            // Case sensitive duplicates should normally not occur since JsonConvert.DeserializeObject
            // does not throw when encountering duplicates and just uses the last entry.
            if (
                memberHashTracker.TryGetValue(entry.Key, out var maybePropertyName)
                && string.Equals(entry.Key, maybePropertyName, StringComparison.Ordinal)
            )
            {
                var errorMsg = string.Format(
                    CultureInfo.CurrentCulture,
                    WebCmdletStrings.DuplicateKeysInJsonString,
                    entry.Key
                );
                error = new ErrorRecord(
                    new InvalidOperationException(errorMsg),
                    "DuplicateKeysInJsonString",
                    ErrorCategory.InvalidOperation,
                    null
                );
                return null;
            }

            // Compare case insensitive to tell the user to use the -AsHashTable option instead.
            // This is because PSObject cannot have keys with different casing.
            if (memberHashTracker.TryGetValue(entry.Key, out var propertyName))
            {
                var errorMsg = string.Format(
                    CultureInfo.CurrentCulture,
                    WebCmdletStrings.KeysWithDifferentCasingInJsonString,
                    propertyName,
                    entry.Key
                );
                error = new ErrorRecord(
                    new InvalidOperationException(errorMsg),
                    "KeysWithDifferentCasingInJsonString",
                    ErrorCategory.InvalidOperation,
                    null
                );
                return null;
            }

            switch (entry.Value)
            {
                case TomlTableArray list:
                {
                    // Array
                    var listResult = PopulateFromTomlTableArray(list, out error);
                    if (error != null)
                    {
                        return null;
                    }

                    result.Properties.Add(new PSNoteProperty(entry.Key, listResult));
                    break;
                }
                case TomlArray list:
                {
                    // Array
                    var listResult = PopulateFromTomlArray(list, out error);
                    if (error != null)
                    {
                        return null;
                    }

                    result.Properties.Add(new PSNoteProperty(entry.Key, listResult));
                    break;
                }
                case TomlTable dic:
                {
                    // Dictionary
                    var dicResult = PopulateFromTomlTable(
                        dic,
                        new(dic.Count, StringComparer.OrdinalIgnoreCase),
                        out error
                    );
                    if (error != null)
                    {
                        return null;
                    }

                    result.Properties.Add(new PSNoteProperty(entry.Key, dicResult));
                    break;
                }
                default:
                {
                    result.Properties.Add(new PSNoteProperty(entry.Key, entry.Value));
                    break;
                }
            }

            memberHashTracker.Add(entry.Key);
        }

        return result;
    }

    private static object? PopulateFromTomlTableArray(TomlTableArray list, out ErrorRecord? error)
    {
        error = null;
        var result = new object?[list.Count];
        var i = 0;

        foreach (var element in list)
        {
            // Dictionary
            result[i++] = PopulateFromTomlTable(
                element,
                new(element.Count, StringComparer.OrdinalIgnoreCase),
                out error
            );
            if (error != null)
            {
                return null;
            }
        }

        return result;
    }

    // This function is a clone of PopulateFromList using TomlArray as input.
    private static object? PopulateFromTomlArray(TomlArray list, out ErrorRecord? error)
    {
        error = null;
        var result = new object?[list.Count];
        var i = 0;

        foreach (var element in list)
        {
            switch (element)
            {
                case TomlArray subList:
                    // Array
                    result[i++] = PopulateFromTomlArray(subList, out error);
                    if (error != null)
                    {
                        return null;
                    }

                    break;

                case TomlTable dic:
                    // Dictionary
                    result[i++] = PopulateFromTomlTable(
                        dic,
                        new(dic.Count, StringComparer.OrdinalIgnoreCase),
                        out error
                    );
                    if (error != null)
                    {
                        return null;
                    }

                    break;

                default:
                    result[i++] = element;
                    break;
            }
        }

        return result;
    }

    // This function is a clone of PopulateFromDictionary using TomlTable as an input.
    private static object? PopulateHashTableFromTomlTable(TomlTable table, out ErrorRecord? error)
    {
        error = null;
        OrderedHashtable result = new(table.Count);
        foreach (var entry in table)
        {
            switch (entry.Value)
            {
                case TomlTableArray list:
                {
                    var listResult = PopulateHashTableFromTomlTableArray(list, out error);
                    if (error != null)
                    {
                        return null;
                    }

                    result.Add(entry.Key, listResult);
                    break;
                }
                case TomlArray list:
                {
                    // Array
                    var listResult = PopulateHashTableFromTomlArray(list, out error);
                    if (error != null)
                    {
                        return null;
                    }

                    result.Add(entry.Key, listResult);
                    break;
                }
                case TomlTable dic:
                {
                    // Dictionary
                    var dicResult = PopulateHashTableFromTomlTable(dic, out error);
                    if (error != null)
                    {
                        return null;
                    }

                    result.Add(entry.Key, dicResult);
                    break;
                }
                case object value:
                {
                    result.Add(entry.Key, value);
                    break;
                }
            }
        }

        return result;
    }

    private static object? PopulateHashTableFromTomlTableArray(
        TomlTableArray list,
        out ErrorRecord? error
    )
    {
        error = null;
        var result = new object?[list.Count];
        var i = 0;

        foreach (var element in list)
        {
            // Dictionary
            result[i++] = PopulateHashTableFromTomlTable(element, out error);
            if (error != null)
            {
                return null;
            }
        }

        return result;
    }

    // This function is a clone of PopulateFromList using TomlArray as input.
    private static object?[]? PopulateHashTableFromTomlArray(TomlArray list, out ErrorRecord? error)
    {
        error = null;
        var result = new object?[list.Count];
        var i = 0;

        foreach (var element in list)
        {
            switch (element)
            {
                case TomlArray subList:
                    // Array
                    result[i++] = PopulateHashTableFromTomlArray(subList, out error);
                    if (error != null)
                    {
                        return null;
                    }
                    break;

                case TomlTable dic:
                    // Dictionary
                    result[i++] = PopulateHashTableFromTomlTable(dic, out error);
                    if (error != null)
                    {
                        return null;
                    }
                    break;

                default:
                    result[i++] = element;
                    break;
            }
        }

        return result;
    }

    #endregion ConvertFromToml

    #region ConvertToToml

    /// <summary>
    /// Convert an object to TOML string.
    /// </summary>
    public static string? ConvertToToml(object objectToProcess, in ConvertToTomlContext context)
    {
        try
        {
            // Pre-process the object so that it serializes the same, except that properties whose
            // values cannot be evaluated are treated as having the value null.
            _maxDepthWarningWritten = false;
            var preprocessedObject = ProcessValue(objectToProcess, currentDepth: 0, in context);
            return TomlSerializer.Serialize(
                preprocessedObject,
                new TomlSerializerOptions
                {
                    MetadataStore = context.MetadataStore,
                    Converters =
                        context.EnumsAsStrings
                        && !ExperimentalFeature.IsEnabled("PSSerializeJSONLongEnumAsNumber")
                            ? [new StringEnumConverter()]
                            : [],
                    MaxDepth = context.MaxDepth,
                }
            );
        }
        catch (OperationCanceledException)
        {
            return null;
        }
    }

    private static bool _maxDepthWarningWritten;

    /// <summary>
    /// Return an alternate representation of the specified object that serializes the same TOML, except
    /// that properties that cannot be evaluated are treated as having the value null.
    /// Primitive types are returned verbatim.  Aggregate types are processed recursively.
    /// </summary>
    /// <param name="obj">The object to be processed.</param>
    /// <param name="currentDepth">The current depth into the object graph.</param>
    /// <param name="context">The context to use for the convert-to-json operation.</param>
    /// <returns>An object suitable for serializing to TOML.</returns>
    private static object? ProcessValue(
        object? obj,
        int currentDepth,
        in ConvertToTomlContext context
    )
    {
        context.CancellationToken.ThrowIfCancellationRequested();

        if (obj == null)
        {
            return null;
        }

        var pso = obj as PSObject;

        if (pso != null)
        {
            obj = pso.BaseObject;
        }

        object? rv = obj;
        bool isPurePSObj = false;
        bool isCustomObj = false;

        if (obj == NullString.Value || obj == DBNull.Value)
        {
            rv = null;
        }
        else if (
            obj
            is string
                or bool
                or char
                or float
                or double
                or decimal
                or BigInteger
                or DateTime
                or DateTimeOffset
                or Guid
                or Uri
        )
        {
            rv = obj;
        }
        else
        {
            Type t = obj.GetType();

            if (
                t.IsPrimitive
                || (t.IsEnum && ExperimentalFeature.IsEnabled("PSSerializeJSONLongEnumAsNumber"))
            )
            {
                rv = obj;
            }
            else if (t.IsEnum)
            {
                // Enums based on System.UInt64 are not TOML-serializable
                Type enumUnderlyingType = Enum.GetUnderlyingType(obj.GetType());
                if (enumUnderlyingType.Equals(typeof(ulong)))
                {
                    rv = obj.ToString();
                }
                else
                {
                    rv = obj;
                }
            }
            else
            {
                if (currentDepth > context.MaxDepth)
                {
                    if (!_maxDepthWarningWritten && context.Cmdlet != null)
                    {
                        _maxDepthWarningWritten = true;
                        string maxDepthMessage = string.Format(
                            CultureInfo.CurrentCulture,
                            WebCmdletStrings.JsonMaxDepthReached,
                            context.MaxDepth
                        );
                        context.Cmdlet.WriteWarning(maxDepthMessage);
                    }

                    if (pso != null && pso.ImmediateBaseObject == null)
                    {
                        // The obj is a pure PSObject, we convert the original PSObject to a string,
                        // instead of its base object in this case
                        rv = LanguagePrimitives.ConvertTo(
                            pso,
                            typeof(string),
                            CultureInfo.InvariantCulture
                        );
                        isPurePSObj = true;
                    }
                    else
                    {
                        rv = LanguagePrimitives.ConvertTo(
                            obj,
                            typeof(string),
                            CultureInfo.InvariantCulture
                        );
                    }
                }
                else
                {
                    if (obj is IDictionary dict)
                    {
                        rv = ProcessDictionary(dict, currentDepth, in context);
                    }
                    else
                    {
                        if (obj is IEnumerable enumerable)
                        {
                            rv = ProcessEnumerable(enumerable, currentDepth, in context);
                        }
                        else
                        {
                            rv = ProcessCustomObject<JsonIgnoreAttribute>(
                                obj,
                                currentDepth,
                                in context
                            );
                            isCustomObj = true;
                        }
                    }
                }
            }
        }

        rv = AddPsProperties(pso, rv, currentDepth, isPurePSObj, isCustomObj, in context);

        return rv;
    }

    /// <summary>
    /// Add to a base object any properties that might have been added to an object (via PSObject) through the Add-Member cmdlet.
    /// </summary>
    /// <param name="psObj">The containing PSObject, or null if the base object was not contained in a PSObject.</param>
    /// <param name="obj">The base object that might have been decorated with additional properties.</param>
    /// <param name="depth">The current depth into the object graph.</param>
    /// <param name="isPurePSObj">The processed object is a pure PSObject.</param>
    /// <param name="isCustomObj">The processed object is a custom object.</param>
    /// <param name="context">The context for the operation.</param>
    /// <returns>
    /// The original base object if no additional properties had been added,
    /// otherwise a dictionary containing the value of the original base object in the "value" key
    /// as well as the names and values of an additional properties.
    /// </returns>
    private static object? AddPsProperties(
        object? psObj,
        object? obj,
        int depth,
        bool isPurePSObj,
        bool isCustomObj,
        in ConvertToTomlContext context
    )
    {
        if (psObj is not PSObject pso)
        {
            return obj;
        }

        // when isPurePSObj is true, the obj is guaranteed to be a string converted by LanguagePrimitives
        if (isPurePSObj)
        {
            return obj;
        }

        bool wasDictionary = true;

        if (obj is not IDictionary dict)
        {
            wasDictionary = false;
            dict = new Dictionary<string, object?> { { "value", obj } };
        }

        AppendPsProperties(pso, dict, depth, isCustomObj, in context);

        if (!wasDictionary && dict.Count == 1)
        {
            return obj;
        }

        return dict;
    }

    /// <summary>
    /// Append to a dictionary any properties that might have been added to an object (via PSObject) through the Add-Member cmdlet.
    /// If the passed in object is a custom object (not a simple object, not a dictionary, not a list, get processed in ProcessCustomObject method),
    /// we also take Adapted properties into account. Otherwise, we only consider the Extended properties.
    /// When the object is a pure PSObject, it also gets processed in "ProcessCustomObject" before reaching this method, so we will
    /// iterate both extended and adapted properties for it. Since it's a pure PSObject, there will be no adapted properties.
    /// </summary>
    /// <param name="psObj">The containing PSObject, or null if the base object was not contained in a PSObject.</param>
    /// <param name="receiver">The dictionary to which any additional properties will be appended.</param>
    /// <param name="depth">The current depth into the object graph.</param>
    /// <param name="isCustomObject">The processed object is a custom object.</param>
    /// <param name="context">The context for the operation.</param>
    private static void AppendPsProperties(
        PSObject psObj,
        IDictionary receiver,
        int depth,
        bool isCustomObject,
        in ConvertToTomlContext context
    )
    {
        // if the psObj is a DateTime or String type, we don't serialize any extended or adapted properties
        if (psObj.BaseObject is string or DateTime)
        {
            return;
        }
        var getMember = new GetMemberCommand
        {
            InputObject = psObj,
            MemberType = PSMemberTypes.Properties,
            // serialize only Extended and Adapted properties..
            View = isCustomObject
                ? PSMemberViewTypes.Extended | PSMemberViewTypes.Adapted
                : PSMemberViewTypes.Extended,
        };
        foreach (var info in getMember.Invoke<PSMemberInfo>())
        {
            if (!receiver.Contains(info.Name))
            {
                receiver[info.Name] = ProcessValue(info.Value, depth + 1, in context);
            }
        }
    }

    /// <summary>
    /// Return an alternate representation of the specified dictionary that serializes the same TOML, except
    /// that any contained properties that cannot be evaluated are treated as having the value null.
    /// </summary>
    private static Dictionary<string, object?> ProcessDictionary(
        IDictionary dict,
        int depth,
        in ConvertToTomlContext context
    )
    {
        Dictionary<string, object?> result = new(dict.Count);

        foreach (DictionaryEntry entry in dict)
        {
            var name = entry.Key as string;
            if (name == null)
            {
                // use the error string that matches the message from JavaScriptSerializer
                string errorMsg = string.Format(
                    CultureInfo.CurrentCulture,
                    WebCmdletStrings.NonStringKeyInDictionary,
                    dict.GetType().FullName
                );

                var exception = new InvalidOperationException(errorMsg);
                if (context.Cmdlet != null)
                {
                    var errorRecord = new ErrorRecord(
                        exception,
                        "NonStringKeyInDictionary",
                        ErrorCategory.InvalidOperation,
                        dict
                    );
                    context.Cmdlet.ThrowTerminatingError(errorRecord);
                }
                else
                {
                    throw exception;
                }
            }

            result.Add(name, ProcessValue(entry.Value, depth + 1, in context));
        }

        return result;
    }

    /// <summary>
    /// Return an alternate representation of the specified collection that serializes the same TOML, except
    /// that any contained properties that cannot be evaluated are treated as having the value null.
    /// </summary>
    private static List<object?> ProcessEnumerable(
        IEnumerable enumerable,
        int depth,
        in ConvertToTomlContext context
    )
    {
        List<object?> result = [];

        foreach (object o in enumerable)
        {
            result.Add(ProcessValue(o, depth + 1, in context));
        }

        return result;
    }

    /// <summary>
    /// Return an alternate representation of the specified aggregate object that serializes the same TOML, except
    /// that any contained properties that cannot be evaluated are treated as having the value null.
    ///
    /// The result is a dictionary in which all public fields and public gettable properties of the original object
    /// are represented.  If any exception occurs while retrieving the value of a field or property, that entity
    /// is included in the output dictionary with a value of null.
    /// </summary>
    private static object ProcessCustomObject<T>(
        object o,
        int depth,
        in ConvertToTomlContext context
    )
    {
        Dictionary<string, object?> result = [];
        Type t = o.GetType();

        foreach (FieldInfo info in t.GetFields(BindingFlags.Public | BindingFlags.Instance))
        {
            if (!info.IsDefined(typeof(T), true))
            {
                object? value;
                try
                {
                    value = info.GetValue(o);
                }
                catch (Exception)
                {
                    value = null;
                }

                result.Add(info.Name, ProcessValue(value, depth + 1, in context));
            }
        }

        foreach (PropertyInfo info2 in t.GetProperties(BindingFlags.Public | BindingFlags.Instance))
        {
            if (!info2.IsDefined(typeof(T), true))
            {
                var getMethod = info2.GetGetMethod();
                if ((getMethod != null) && (getMethod.GetParameters().Length == 0))
                {
                    object? value;
                    try
                    {
                        value = getMethod.Invoke(o, []);
                    }
                    catch (Exception)
                    {
                        value = null;
                    }

                    result.Add(info2.Name, ProcessValue(value, depth + 1, in context));
                }
            }
        }

        return result;
    }

    #endregion ConvertToToml
}
