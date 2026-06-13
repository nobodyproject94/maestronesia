$logPath = 'C:\Users\Asus\.gemini\antigravity-ide\brain\87e4504a-14b9-46ea-9369-152064a4fe4e\.system_generated\logs\transcript.jsonl'
$content = ''
$lines = Get-Content $logPath -Encoding UTF8
foreach ($line in $lines) {
  if ([string]::IsNullOrWhiteSpace($line)) { continue }
  $data = $line | ConvertFrom-Json
  if ($data.tool_calls) {
    foreach ($call in $data.tool_calls) {
      if ($call.name -eq 'write_to_file' -and $call.args.TargetFile -like '*expert_dashboard_screen.dart') {
        $content = $call.args.CodeContent
      }
    }
  }
}
[IO.File]::WriteAllText('d:\MaestroNesia\lib\screens\expert_dashboard_screen.dart', $content, [Text.Encoding]::UTF8)
Write-Output 'Restored expert_dashboard_screen.dart'
