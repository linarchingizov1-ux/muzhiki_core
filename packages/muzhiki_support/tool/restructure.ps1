$ErrorActionPreference = "Stop"
$Lib = Join-Path $PSScriptRoot "..\lib" | Resolve-Path
Set-Location $Lib

function Ensure-Dir($p) { New-Item -ItemType Directory -Force -Path $p | Out-Null }
function Move-To($from, $to) {
  if (-not (Test-Path $from)) { Write-Warning "Missing: $from"; return }
  Ensure-Dir (Split-Path $to -Parent)
  Move-Item -Force $from $to
}

Write-Host "==> Deleting dead code"
Remove-Item -Recurse -Force "app\feature\presentation\video_view" -ErrorAction SilentlyContinue
Remove-Item -Force "app\data\model\mobile_widget.dart" -ErrorAction SilentlyContinue
Remove-Item -Force "app\data\model\mobile_widget.g.dart" -ErrorAction SilentlyContinue

Write-Host "==> Creating target folders"
@(
  "config",
  "data\models\socket\attachments",
  "data\models\socket\message",
  "data\repositories",
  "data\services",
  "data\websocket\extensions",
  "domain\repositories",
  "domain\usecases",
  "features\home\state",
  "features\home\widgets",
  "features\chat\state",
  "features\chat\widgets",
  "features\informator",
  "shared\widgets\appbar",
  "shared\widgets\attachment",
  "shared\extensions",
  "shared\utils"
) | ForEach-Object { Ensure-Dir $_ }

Write-Host "==> Moving config"
Move-To "app\config\constant\support_assets.dart" "config\support_assets.dart"
Move-To "app\config\constant\support_path.dart" "config\support_path.dart"
Move-To "app\config\constant\support_route_constant.dart" "config\support_route_constant.dart"
Move-To "app\config\support_route_event.dart" "config\support_route_event.dart"
Move-To "app\config\attachment_uuid_service.dart" "data\services\attachment_uuid_service.dart"

Write-Host "==> Moving data models"
Move-To "app\data\model\my_chat.dart" "data\models\my_chat.dart"
Move-To "app\data\model\my_chat.g.dart" "data\models\my_chat.g.dart"
Move-To "app\data\model\support_chats_event_widgets.dart" "data\models\support_chats_event_widgets.dart"
Move-To "app\data\model\view_image_item_model.dart" "data\models\view_image_item_model.dart"

Get-ChildItem "app\data\model\socket" -Recurse -File | ForEach-Object {
  $rel = $_.FullName.Substring((Resolve-Path "app\data\model\socket").Path.Length + 1)
  Move-To $_.FullName (Join-Path "data\models\socket" $rel)
}

Write-Host "==> Moving repositories / websocket / domain"
Move-To "app\data\repository\chat_repository_impl.dart" "data\repositories\chat_repository_impl.dart"
Move-To "app\data\websocket\chat_websocket_app.dart" "data\websocket\chat_websocket_app.dart"
Move-To "app\data\websocket\extension\chat_extension.dart" "data\websocket\extensions\chat_extension.dart"
Move-To "app\data\websocket\extension\chat_footer_state_extension.dart" "data\websocket\extensions\chat_footer_state_extension.dart"
Move-To "app\data\websocket\extension\date_format.dart" "shared\extensions\date_format.dart"
Move-To "app\data\websocket\extension\status_extension.dart" "shared\extensions\status_extension.dart"
Move-To "app\domain\repository\chat_repository.dart" "domain\repositories\chat_repository.dart"
Move-To "app\domain\usecase\chat_usecase.dart" "domain\usecases\chat_usecase.dart"
Move-To "app\extension\websocket_extension.dart" "shared\extensions\chat_media_extension.dart"

Write-Host "==> Moving features/home"
Move-To "app\feature\presentation\main_view\support_view.dart" "features\home\support_view.dart"
Move-To "app\feature\presentation\main_view\widgets\sliver_chat_container_widget.dart" "features\home\widgets\sliver_chat_container_widget.dart"
Move-To "app\feature\presentation\main_view\widgets\sliver_choi_widget.dart" "features\home\widgets\sliver_choi_widget.dart"
Move-To "app\feature\presentation\main_view\widgets\sliver_home_appbar_widget.dart" "features\home\widgets\sliver_home_appbar_widget.dart"
Move-To "app\feature\presentation\main_view\widgets\sliver_informator.dart" "features\home\widgets\sliver_informator.dart"
Move-To "app\feature\state\chat\chat_cubit.dart" "features\home\state\chat_cubit.dart"
Move-To "app\feature\state\chat\chat_cubit.freezed.dart" "features\home\state\chat_cubit.freezed.dart"
Move-To "app\feature\state\chat\chat_state.dart" "features\home\state\chat_state.dart"

Write-Host "==> Moving features/chat"
Move-To "app\feature\presentation\chat_view\chat_view.dart" "features\chat\chat_view.dart"
Move-To "app\feature\presentation\chat_view\chat_bottom_widgets.dart" "features\chat\chat_bottom_widgets.dart"
Move-To "app\feature\presentation\chat_view\chat_header_widgets.dart" "features\chat\chat_header_widgets.dart"
Move-To "app\feature\presentation\chat_view\chat_message_widgets.dart" "features\chat\chat_message_widgets.dart"
Move-To "app\feature\presentation\chat_view\widgets\chat_bottom_area_closed_and_rated_widgets.dart" "features\chat\widgets\chat_bottom_area_closed_and_rated_widgets.dart"
Move-To "app\feature\presentation\chat_view\widgets\chat_bottom_area_rated_widgets.dart" "features\chat\widgets\chat_bottom_area_rated_widgets.dart"
Move-To "app\feature\presentation\chat_view\widgets\chat_bottom_area_ticket_widgets.dart" "features\chat\widgets\chat_bottom_area_ticket_widgets.dart"
Move-To "app\feature\state\attachments\attachments_cubit.dart" "features\chat\state\attachments_cubit.dart"
Move-To "app\feature\state\attachments\attachments_cubit.freezed.dart" "features\chat\state\attachments_cubit.freezed.dart"
Move-To "app\feature\state\attachments\attachments_state.dart" "features\chat\state\attachments_state.dart"

Write-Host "==> Moving features/informator"
Move-To "app\feature\presentation\informator\informator_view.dart" "features\informator\informator_view.dart"

Write-Host "==> Moving shared widgets"
Move-To "app\feature\widgets\appbar_main\appbar_main.dart" "shared\widgets\appbar\appbar_main.dart"
Move-To "app\feature\widgets\appbar_main\menu.dart" "shared\widgets\appbar\menu.dart"
Move-To "app\feature\widgets\attachment\attachment_widgets.dart" "shared\widgets\attachment\attachment_widgets.dart"
Move-To "app\feature\widgets\attachment\document_attachment.dart" "shared\widgets\attachment\document_attachment.dart"
Move-To "app\feature\widgets\attachment\photo_attachment.dart" "shared\widgets\attachment\photo_attachment.dart"
Move-To "app\feature\widgets\attachment\video_attachment.dart" "shared\widgets\attachment\video_attachment.dart"
Move-To "app\feature\widgets\bubble_chat.dart" "shared\widgets\bubble_chat.dart"
Move-To "app\feature\widgets\chat_container.dart" "shared\widgets\chat_container.dart"
Move-To "app\feature\widgets\circle.dart" "shared\widgets\circle.dart"
Move-To "app\feature\widgets\photo_view_widget.dart" "shared\widgets\photo_view_widget.dart"
Move-To "app\feature\widgets\text_field.dart" "shared\widgets\text_field.dart"
Move-To "app\feature\widgets\upload_data_widgets.dart" "shared\widgets\upload_data_widgets.dart"
Move-To "app\feature\widgets\video_player.dart" "shared\widgets\video_player.dart"

Write-Host "==> Cleaning empty app/ tree"
if (Test-Path "app") { Remove-Item -Recurse -Force "app" }

Write-Host "==> Done moves"
Get-ChildItem -Recurse -Directory | Where-Object { -not (Get-ChildItem $_.FullName -Force | Select-Object -First 1) } | Remove-Item -Force -ErrorAction SilentlyContinue
Write-Host "Files:" (Get-ChildItem -Recurse -File -Filter *.dart).Count
