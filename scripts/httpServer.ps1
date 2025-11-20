using namespace System.IO
using namespace System.Net
using namespace System.Net.Http

$ErrorActionPreference = 'Stop'
$port = $env:PWSH_HTTP_PORT ?? '6207'
$server = [HttpListener]::new()
$server.Prefixes.Add("http://localhost:$port/")
$server.Start()
Write-Warning "pwsh http server listening on http://localhost:$port/"

try {
  while ($server.IsListening) {
    $context = $server.GetContext()
    $request = $context.Request
    $request.ContentType
    $response = $context.Response
    if ($request.HttpMethod -ceq [HttpMethod]::Delete -and $request.Url.LocalPath -ceq '/stop') {
      $response.Close()
      break
    }
    if ($request.HttpMethod -ceq [HttpMethod]::Post) {
      if (!$request.ContentLength64) {
        $response.Close()
        continue
      }
      $reader = [StreamReader]::new($request.InputStream)
      $content = $reader.ReadToEnd()
      $reader.Close()
    }
    else {
      $content = 'hello world'
    }
    $content = [System.Text.Encoding]::UTF8.GetBytes($content)
    $response.ContentLength64 = $content.Length
    $response.OutputStream.Write($content, 0, $content.Length)
    $response.Close()
  }
}
catch {
  Write-Error $_
}
finally {
  $server.Stop()
  $server.Close()
}


