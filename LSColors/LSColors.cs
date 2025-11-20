using System.Management.Automation;
namespace LSColors;

// colors: green, cyan, blue, yellow, magenta, red

public class LSColors
{
  public static string GetSizeString(long size) => size switch
  {
    < 1000 => PSStyle.Instance.Foreground.Green + size,
    < 1000_000 => PSStyle.Instance.Foreground.Cyan + (size / 1000.0).ToString(".0") + 'K',
    < 1000_000_000 => PSStyle.Instance.Foreground.Blue + (size / 1000_000.0).ToString(".0") + 'M',
    < 1000_000_000_000 => PSStyle.Instance.Foreground.Magenta + (size / 1000_000_000.0).ToString(".0") + 'G'
    _ => PSStyle.Instance.Foreground.Yellow + (size / 1000_000_000_000.0).ToString(".0") + 'T'
  } + PSStyle.Instance.Reset;

  public static string GetNameString(FileInfo info) => GetNameString(info, null);

  private static string GetNameString(FileInfo info, string? linkName)
  {
    string color = "", link = "";
    if (linkName == null && info.Attributes.HasFlag(FileAttributes.ReparsePoint))
    {
      link = " -> " + (info.ResolveLinkTarget(true) is FileInfo file ? GetNameString(file, info.LinkTarget) : "");
      color = PSStyle.Instance.FileInfo.SymbolicLink;
    }
    else if (Platform.IsWindows ? info.Extension == ".exe" : info.UnixFileMode.HasFlag(UnixFileMode.UserExecute))
    {
      color = PSStyle.Instance.FileInfo.Executable;
    }
    else if (PSStyle.Instance.FileInfo.Extension.ContainsKey(info.Extension))
    {
      color = PSStyle.Instance.FileInfo.Extension[info.Extension];
    }
    return color + PSStyle.Instance.FormatHyperlink(linkName ?? info.Name, new Uri(info.FullName)) + PSStyle.Instance.Reset + link;
  }

  public static string GetNameString(DirectoryInfo info) => GetNameString(info, null);

  private static string GetNameString(DirectoryInfo info, string? linkName)
  {
    string color, link = "";
    if (linkName == null && info.Attributes.HasFlag(FileAttributes.ReparsePoint))
    {
      link = " -> " + (info.ResolveLinkTarget(true) is DirectoryInfo directory ? GetNameString(directory, info.LinkTarget) : "");
      color = PSStyle.Instance.FileInfo.SymbolicLink;
    }
    else
    {
      color = PSStyle.Instance.FileInfo.Directory;
    }
    return color + PSStyle.Instance.FormatHyperlink(linkName ?? info.Name, new Uri(info.FullName)) + PSStyle.Instance.Reset + link;
  }
}
