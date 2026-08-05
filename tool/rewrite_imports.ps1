$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

function Rewrite-File([string]$Path) {
  $content = Get-Content -Raw -Path $Path -Encoding UTF8
  $original = $content

  # Moved shared UI pieces
  $content = $content -replace "package:muzhiki_core/muzhiki_support/app/config/constant/support_colors\.dart", "package:muzhiki_ui/theme/support_colors.dart"
  $content = $content -replace "package:muzhiki_core/muzhiki_support/app/feature/widgets/notification\.dart", "package:muzhiki_ui/widgets/notification.dart"
  $content = $content -replace "package:muzhiki_core/muzhiki_support/app/feature/widgets/skelet\.dart", "package:muzhiki_ui/widgets/skelet.dart"
  $content = $content -replace "package:muzhiki_core/muzhiki_support/app/feature/widgets/button\.dart", "package:muzhiki_ui/widgets/button.dart"
  $content = $content -replace "package:muzhiki_core/muzhiki_support/app/feature/widgets/app_dialog\.dart", "package:muzhiki_dependencies/ui/app_dialog.dart"
  $content = $content -replace "package:muzhiki_core/muzhiki_report_problem/presentation/widgets/button_small\.dart", "package:muzhiki_ui/widgets/button_small.dart"

  # Package renames
  $content = $content -replace "package:muzhiki_core/muzhiki_dependecies/", "package:muzhiki_dependencies/"
  $content = $content -replace "package:muzhiki_core/muzhiki_support/", "package:muzhiki_support/"
  $content = $content -replace "package:muzhiki_core/muzhiki_ui/", "package:muzhiki_ui/"
  $content = $content -replace "package:muzhiki_core/muzhiki_bridge/", "package:muzhiki_bridge/"
  $content = $content -replace "package:muzhiki_core/muzhiki_report_problem/", "package:muzhiki_report_problem/"

  # Barrel import of old core — leave marker for manual review if still present
  $content = $content -replace "package:muzhiki_core/muzhiki_core\.dart", "package:muzhiki_dependencies/muzhiki_dependencies.dart"

  # Asset package paths
  $content = $content -replace "packages/muzhiki_core/assets/support/", "packages/muzhiki_support/assets/"
  $content = $content -replace "packages/muzhiki_core/assets/network_problem/", "packages/muzhiki_dependencies/assets/network_problem/"
  $content = $content -replace "packages/muzhiki_core/assets/report_problem/", "packages/muzhiki_report_problem/assets/report_problem/"

  if ($content -ne $original) {
    Set-Content -Path $Path -Value $content -Encoding UTF8 -NoNewline
    return $true
  }
  return $false
}

$dirs = @(
  "packages/muzhiki_ui",
  "packages/muzhiki_dependencies",
  "packages/muzhiki_bridge",
  "packages/muzhiki_support",
  "packages/muzhiki_report_problem"
)

$changed = 0
foreach ($dir in $dirs) {
  Get-ChildItem -Path $dir -Recurse -Filter *.dart | ForEach-Object {
    if (Rewrite-File $_.FullName) { $changed++ }
  }
}

Write-Host "Rewrote $changed files"
