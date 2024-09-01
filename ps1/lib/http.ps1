function runHttpServer {
  $listener = [System.Net.HttpListener]::new()
  $url = 'http://localhost:3233/'
  $listener.Prefixes.Add($url)
  $listener.Start()
  Write-Output "http listener is listening on $url"

  while ($listener.IsListening) {
    if ($stoping) {
      break
    }
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response
    Write-Output "[$($request.HttpMethod)] $($request.UserHostAddress) $($request.Url)"
    if ($request.Url.PathAndQuery -ne 'index.html') {
      $response.StatusCode = 404
    }
    $buffer = [System.Text.Encoding]::UTF8.GetBytes('<h1>hello world</h1>')
    $response.OutputStream.Write($buffer)
    $response.OutputStream.Close()
  }

  $listener.Stop()
  Write-Output "http listener stopped on $url"
}

function Start-HttpServer {
  $job = Start-Job -Name 'Run Http Server' -ScriptBlock $function:runHttpServer
  Set-PSReadLineKeyHandler -Chord Alt+g -ScriptBlock {
    Stop-Job $job
  }
}
