using System.Management.Automation;
using Newtonsoft.Json;

namespace Utility;

/// <summary>
/// The ConvertTo-Json command.
/// This command converts an object to a Json string representation.
/// </summary>
[Cmdlet(
    VerbsData.ConvertTo,
    "Json",
    HelpUri = "https://go.microsoft.com/fwlink/?LinkID=2096925",
    RemotingCapability = RemotingCapability.None
)]
[OutputType(typeof(string))]
public class ConvertToJsonCommand : PSCmdlet, IDisposable
{
    private readonly CancellationTokenSource _cancellationSource = new();

    /// <summary>
    /// Gets or sets the InputObject property.
    /// </summary>
    [Parameter(Position = 0, Mandatory = true, ValueFromPipeline = true)]
    [AllowNull]
    public required object InputObject { get; set; }

    /// <summary>
    /// Gets or sets the Depth property.
    /// </summary>
    [Parameter]
    [ValidateRange(0, 100)]
    public int Depth { get; set; } = 2;

    /// <summary>
    /// Gets or sets the EnumsAsStrings property.
    /// If the EnumsAsStrings property is set to true, enum values will
    /// be converted to their string equivalent. Otherwise, enum values
    /// will be converted to their numeric equivalent.
    /// </summary>
    [Parameter]
    public SwitchParameter EnumsAsStrings { get; set; }

    /// <summary>
    /// Gets or sets the AsArray property.
    /// If the AsArray property is set to be true, the result JSON string will
    /// be returned with surrounding '[', ']' chars. Otherwise,
    /// the array symbols will occur only if there is more than one input object.
    /// </summary>
    [Parameter]
    public SwitchParameter AsArray { get; set; }

    /// <summary>
    /// Specifies how strings are escaped when writing JSON text.
    /// If the EscapeHandling property is set to EscapeHtml, the result JSON string will
    /// be returned with HTML (&lt;, &gt;, &amp;, ', ") and control characters (e.g. newline) are escaped.
    /// </summary>
    [Parameter]
    public StringEscapeHandling EscapeHandling { get; set; } = StringEscapeHandling.Default;

    /// <summary>
    /// IDisposable implementation, dispose of any disposable resources created by the cmdlet.
    /// </summary>
    public void Dispose()
    {
        Dispose(disposing: true);
        GC.SuppressFinalize(this);
    }

    /// <summary>
    /// Implementation of IDisposable for both manual Dispose() and finalizer-called disposal of resources.
    /// </summary>
    /// <param name="disposing">
    /// Specified as true when Dispose() was called, false if this is called from the finalizer.
    /// </param>
    protected virtual void Dispose(bool disposing)
    {
        if (disposing)
        {
            _cancellationSource.Dispose();
        }
    }

    private readonly List<object> _inputObjects = [];

    /// <summary>
    /// Caching the input objects for the command.
    /// </summary>
    protected override void ProcessRecord()
    {
        _inputObjects.Add(InputObject);
    }

    /// <summary>
    /// Do the conversion to json and write output.
    /// </summary>
    protected override void EndProcessing()
    {
        if (_inputObjects.Count > 0)
        {
            object objectToProcess =
                (_inputObjects.Count > 1 || AsArray)
                    ? (_inputObjects.ToArray() as object)
                    : _inputObjects[0];

            var context = new JsonObject.ConvertToJsonContext(
                Depth,
                EnumsAsStrings.IsPresent,
                Compress.IsPresent,
                EscapeHandling,
                targetCmdlet: this,
                _cancellationSource.Token
            );

            // null is returned only if the pipeline is stopping (e.g. ctrl+c is signaled).
            // in that case, we shouldn't write the null to the output pipe.
            string output = JsonObject.ConvertToJson(objectToProcess, in context);
            if (output != null)
            {
                WriteObject(output);
            }
        }
    }

    /// <summary>
    /// Process the Ctrl+C signal.
    /// </summary>
    protected override void StopProcessing()
    {
        _cancellationSource.Cancel();
    }
}
