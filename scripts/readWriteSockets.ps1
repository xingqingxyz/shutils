using namespace System.IO
using namespace System.Net.Sockets

$ErrorActionPreference = 'Stop'
$socketPath = '/tmp/mvext-powershell.sock'
$logPath = '/tmp/mvext-powershell.log'
Remove-Item -LiteralPath $socketPath -ea Ignore
$socket = [Socket]::new([AddressFamily]::Unix, [SocketType]::Stream, [ProtocolType]::IP)
$endpoint = [UnixDomainSocketEndPoint]::new($socketPath)
$socket.Bind($endpoint)
$socket.Listen(10)
Write-Host "Unix Socket 服务器已启动，监听路径: $socketPath"

$buffer = [char[]]::new(1024)
while ($true) {
  $clientSocket = $socket.Accept()
  $stream = [NetworkStream]::new($clientSocket)
  $reader = [StreamReader]::new($stream)
  $writer = [StreamWriter]::new($stream)
  $writer.AutoFlush = $true
  $length = [uint]$reader.ReadLine()
  "[$(Get-Date)] Received Length $length" >> $logPath
  $length = [uint]::DivRem($length, 1024)
  $length = $length.Item1 + ($length.Item2 ? 1 : 0)
  $text = @(while ($length--) {
      [string]::new($buffer, 0, $reader.Read($buffer, 0, 1024))
    }) -join ''
  try {
    $text = & $env:SHUTILS_ROOT/scripts/getAstTreeView.ps1 $text
    $writer.Write($text)
  }
  catch {
    $Error[0]
  }
  $clientSocket.Close()
}
