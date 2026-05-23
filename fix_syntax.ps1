$content = Get-Content -Path "lib\dashboard.dart" -Raw
$content = $content -replace '\)BoxShadow\(', '), BoxShadow('
$content = $content -replace '(?s)(Expanded\(\s*child:\s*GestureDetector\([\s\S]*?child:\s*Container\([\s\S]*?\n\s*\),\n\s*\),\n\s*\),\n)', "`$1                              ),`n"
Set-Content -Path "lib\dashboard.dart" -Value $content
