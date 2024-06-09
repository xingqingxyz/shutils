using namespace System.Management.Automation
using namespace System.Management.Automation.Language


param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
$cursorPosition -= $wordToComplete.Length
foreach ($i in $commandAst.CommandElements) {
  if ($i.Extent.StartOffset -eq $cursorPosition) {
    break
  }
  $prev = $i
}
@(switch ($prev.Extent.Text) {
    '-alpha' { 'on', 'activate', 'off', 'deactivate', 'set', 'opaque', 'copy', 'transparent', 'extract', 'background', 'shape' }
    '-endian' { 'MSB' , 'LSB' }
    '-debug' { '' }
    Default { @('-affine', '-alpha', '-authenticate', '-blue-primary', '-colorspace', '-comment', '-compose', '-compress', '-define', '-depth', '-density', '-display', '-dispose', '-dither', '-encoding', '-endian', '-filter', '-font', '-format', '-gravity', '-green-primary', '-interlace', '-interpolate', '-label', '-limit', '-matte', '-monitor', '-page', '-pointsize', '-quality', '-quiet', '-red-primary', '-regard-warnings', '-respect-parentheses', '-sampling-factor', '-scene', '-seed', '-size', '-support', '-synchronize', '-taint', '-transparent-color', '-treedepth', '-tile', '-units', '-verbose', '-virtual-pixel', '-white-point', '-blend', '-border', '-bordercolor', '-channel', '-colors', '-decipher', '-displace', '-dissolve', '-distort', '-encipher', '-extract', '-geometry', '-identify', '-monochrome', '-negate', '-profile', '-quantize', '-repage', '-rotate', '-resize', '-sharpen', '-shave', '-stegano', '-stereo', '-strip', '-thumbnail', '-transform', '-type', '-unsharp', '-watermark', '-write', '-swap', '-debug', '-help', '-list', '-log', '-version') }
  }) | Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
  [CompletionResult]::new($_)
}
