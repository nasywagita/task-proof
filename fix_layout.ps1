$content = Get-Content -Path "lib\dashboard.dart" -Raw
$content = $content -replace '(?s)mainAxisSize: MainAxisSize\.min(,\s*mainAxisAlignment: MainAxisAlignment\.center,\s*crossAxisAlignment: CrossAxisAlignment\.start,\s*(?:spacing: 16,\s*)?children: \[\s*Expanded\()', 'mainAxisSize: MainAxisSize.max$1'
Set-Content -Path "lib\dashboard.dart" -Value $content
