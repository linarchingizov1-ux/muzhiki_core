$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

Write-Host "==> Creating folders"
@(
  "packages",
  "apps",
  "packages/muzhiki_ui/lib",
  "packages/muzhiki_dependencies/lib",
  "packages/muzhiki_bridge/lib",
  "packages/muzhiki_support/lib",
  "packages/muzhiki_report_problem/lib",
  "apps/mp_master/lib",
  "apps/mp_business/lib",
  "apps/mp_client/lib"
) | ForEach-Object { New-Item -ItemType Directory -Force -Path $_ | Out-Null }

Write-Host "==> Moving flutter_appauth"
if (Test-Path "flutter_appauth") {
  Move-Item -Force "flutter_appauth" "packages/flutter_appauth"
}

Write-Host "==> Copying package sources"
# dependencies (fix typo folder name)
Copy-Item -Recurse -Force "lib/muzhiki_dependecies/*" "packages/muzhiki_dependencies/lib/"

# bridge
Copy-Item -Recurse -Force "lib/muzhiki_bridge/*" "packages/muzhiki_bridge/lib/"

# support
Copy-Item -Recurse -Force "lib/muzhiki_support/*" "packages/muzhiki_support/lib/"

# report_problem
Copy-Item -Recurse -Force "lib/muzhiki_report_problem/*" "packages/muzhiki_report_problem/lib/"

# ui
Copy-Item -Recurse -Force "lib/muzhiki_ui/*" "packages/muzhiki_ui/lib/"

Write-Host "==> Moving shared widgets into muzhiki_ui (break cycles)"
New-Item -ItemType Directory -Force -Path "packages/muzhiki_ui/lib/theme" | Out-Null
New-Item -ItemType Directory -Force -Path "packages/muzhiki_ui/lib/widgets" | Out-Null

Move-Item -Force `
  "packages/muzhiki_support/lib/app/config/constant/support_colors.dart" `
  "packages/muzhiki_ui/lib/theme/support_colors.dart"

Move-Item -Force `
  "packages/muzhiki_support/lib/app/feature/widgets/notification.dart" `
  "packages/muzhiki_ui/lib/widgets/notification.dart"

Move-Item -Force `
  "packages/muzhiki_support/lib/app/feature/widgets/skelet.dart" `
  "packages/muzhiki_ui/lib/widgets/skelet.dart"

Move-Item -Force `
  "packages/muzhiki_support/lib/app/feature/widgets/button.dart" `
  "packages/muzhiki_ui/lib/widgets/button.dart"

Move-Item -Force `
  "packages/muzhiki_report_problem/lib/presentation/widgets/button_small.dart" `
  "packages/muzhiki_ui/lib/widgets/button_small.dart"

# AppDialog belongs with dependencies (uses MuzhikiDependencies)
New-Item -ItemType Directory -Force -Path "packages/muzhiki_dependencies/lib/ui" | Out-Null
Move-Item -Force `
  "packages/muzhiki_support/lib/app/feature/widgets/app_dialog.dart" `
  "packages/muzhiki_dependencies/lib/ui/app_dialog.dart"

Write-Host "==> Moving assets"
New-Item -ItemType Directory -Force -Path "packages/muzhiki_support/assets" | Out-Null
New-Item -ItemType Directory -Force -Path "packages/muzhiki_dependencies/assets" | Out-Null
New-Item -ItemType Directory -Force -Path "packages/muzhiki_report_problem/assets" | Out-Null
New-Item -ItemType Directory -Force -Path "packages/muzhiki_ui/assets/fonts" | Out-Null

Copy-Item -Recurse -Force "assets/support/*" "packages/muzhiki_support/assets/"
Copy-Item -Recurse -Force "assets/network_problem" "packages/muzhiki_dependencies/assets/"
Copy-Item -Recurse -Force "assets/report_problem" "packages/muzhiki_report_problem/assets/"

# fonts as design-system in ui
if (Test-Path "assets/support/fonts") {
  Copy-Item -Recurse -Force "assets/support/fonts/*" "packages/muzhiki_ui/assets/fonts/"
}

# report_problem needs a couple of support svgs independently
New-Item -ItemType Directory -Force -Path "packages/muzhiki_report_problem/assets/svg" | Out-Null
Copy-Item -Force "assets/support/svg/screpka.svg" "packages/muzhiki_report_problem/assets/svg/screpka.svg"
Copy-Item -Force "assets/support/svg/close.svg" "packages/muzhiki_report_problem/assets/svg/close.svg"

Write-Host "==> Moving android plugin into muzhiki_dependencies"
if (Test-Path "android") {
  if (Test-Path "packages/muzhiki_dependencies/android") {
    Remove-Item -Recurse -Force "packages/muzhiki_dependencies/android"
  }
  Copy-Item -Recurse -Force "android" "packages/muzhiki_dependencies/android"
}

Write-Host "==> Done copying. Next: write pubspecs and rewrite imports."
