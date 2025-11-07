using System.Management.Automation;
namespace LSColors;

// colors: green, cyan, blue, yellow, magenta, red

public class LSColors
{
  public static string GetSizeString(long size) => size switch
  {
    < 1000 => PSStyle.Instance.Foreground.Green + size,
    < 1000_000 => PSStyle.Instance.Foreground.Cyan + (size / 1000) + 'K',
    < 1000_000_000 => PSStyle.Instance.Foreground.Blue + (size / 1000_000) + 'M',
    _ => PSStyle.Instance.Foreground.Yellow + (size / 1000_000_000) + 'G'
  } + PSStyle.Instance.Reset;

  public static string GetNameString(FileInfo info) => GetNameString(info, true);

  private static string GetNameString(FileInfo info, bool firstCall)
  {
    string color = "", link = "";
    if (firstCall && info.Attributes.HasFlag(FileAttributes.ReparsePoint))
    {
      link = " -> " + (info.ResolveLinkTarget(true) is FileInfo file ? GetNameString(file, false) : info.FullName);
      color = PSStyle.Instance.FileInfo.SymbolicLink;
    }
    else if (info.UnixFileMode.HasFlag(UnixFileMode.UserExecute))
    {
      color = PSStyle.Instance.FileInfo.Executable;
    }
    else if (PSStyle.Instance.FileInfo.Extension.ContainsKey(info.Extension))
    {
      color = PSStyle.Instance.FileInfo.Extension[info.Extension];
    }
    return color + PSStyle.Instance.FormatHyperlink(firstCall ? info.Name : info.FullName, new Uri(info.FullName)) + PSStyle.Instance.Reset + link;
  }

  public static string GetNameString(DirectoryInfo info) => GetNameString(info, true);

  private static string GetNameString(DirectoryInfo info, bool firstCall)
  {
    string color, link = "";
    if (firstCall && info.Attributes.HasFlag(FileAttributes.ReparsePoint))
    {
      link = " -> " + (info.ResolveLinkTarget(true) is DirectoryInfo directory ? GetNameString(directory, false) : info.FullName);
      color = PSStyle.Instance.FileInfo.SymbolicLink;
    }
    else
    {
      color = PSStyle.Instance.FileInfo.Directory;
    }
    return color + PSStyle.Instance.FormatHyperlink(firstCall ? info.Name : info.FullName, new Uri(info.FullName)) + PSStyle.Instance.Reset + link;
  }
}
