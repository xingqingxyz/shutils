$modules = Update-Module -AcceptLicense -PassThru
if ($modules) {
  $modules | Clear-Module
}
