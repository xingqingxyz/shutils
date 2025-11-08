var HOME = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);
List<string> dirs = ["."];
foreach (var dir in dirs)
{
  foreach (var d in Directory.GetDirectories(dir))
  {
    Console.WriteLine(LSColors.LSColors.GetNameString(new DirectoryInfo(d)));
  }
  foreach (var file in Directory.GetFiles(dir))
  {
    Console.WriteLine(LSColors.LSColors.GetSizeString(file.Length));
    Console.WriteLine(LSColors.LSColors.GetNameString(new FileInfo(file)));
  }
}
