$ErrorActionPreference = "Stop"
$Root = Join-Path $PSScriptRoot "..\.." | Resolve-Path
# packages root = muzhiki_core/packages

$replacements = [ordered]@{
  # config
  "package:muzhiki_support/app/config/constant/support_assets.dart" = "package:muzhiki_support/config/support_assets.dart"
  "package:muzhiki_support/app/config/constant/support_path.dart" = "package:muzhiki_support/config/support_path.dart"
  "package:muzhiki_support/app/config/constant/support_route_constant.dart" = "package:muzhiki_support/config/support_route_constant.dart"
  "package:muzhiki_support/app/config/support_route_event.dart" = "package:muzhiki_support/config/support_route_event.dart"
  "package:muzhiki_support/app/config/attachment_uuid_service.dart" = "package:muzhiki_support/data/services/attachment_uuid_service.dart"

  # data models
  "package:muzhiki_support/app/data/model/my_chat.dart" = "package:muzhiki_support/data/models/my_chat.dart"
  "package:muzhiki_support/app/data/model/support_chats_event_widgets.dart" = "package:muzhiki_support/data/models/support_chats_event_widgets.dart"
  "package:muzhiki_support/app/data/model/view_image_item_model.dart" = "package:muzhiki_support/data/models/view_image_item_model.dart"
  "package:muzhiki_support/app/data/model/socket/" = "package:muzhiki_support/data/models/socket/"

  # data repos / websocket
  "package:muzhiki_support/app/data/repository/chat_repository_impl.dart" = "package:muzhiki_support/data/repositories/chat_repository_impl.dart"
  "package:muzhiki_support/app/data/websocket/chat_websocket_app.dart" = "package:muzhiki_support/data/websocket/chat_websocket_app.dart"
  "package:muzhiki_support/app/data/websocket/extension/chat_extension.dart" = "package:muzhiki_support/data/websocket/extensions/chat_extension.dart"
  "package:muzhiki_support/app/data/websocket/extension/chat_footer_state_extension.dart" = "package:muzhiki_support/data/websocket/extensions/chat_footer_state_extension.dart"
  "package:muzhiki_support/app/data/websocket/extension/date_format.dart" = "package:muzhiki_support/shared/extensions/date_format.dart"
  "package:muzhiki_support/app/data/websocket/extension/status_extension.dart" = "package:muzhiki_support/shared/extensions/status_extension.dart"

  # domain
  "package:muzhiki_support/app/domain/repository/chat_repository.dart" = "package:muzhiki_support/domain/repositories/chat_repository.dart"
  "package:muzhiki_support/app/domain/usecase/chat_usecase.dart" = "package:muzhiki_support/domain/usecases/chat_usecase.dart"
  "package:muzhiki_support/app/extension/websocket_extension.dart" = "package:muzhiki_support/shared/extensions/chat_media_extension.dart"

  # features home
  "package:muzhiki_support/app/feature/presentation/main_view/support_view.dart" = "package:muzhiki_support/features/home/support_view.dart"
  "package:muzhiki_support/app/feature/presentation/main_view/widgets/" = "package:muzhiki_support/features/home/widgets/"
  "package:muzhiki_support/app/feature/state/chat/" = "package:muzhiki_support/features/home/state/"

  # features chat
  "package:muzhiki_support/app/feature/presentation/chat_view/chat_view.dart" = "package:muzhiki_support/features/chat/chat_view.dart"
  "package:muzhiki_support/app/feature/presentation/chat_view/chat_bottom_widgets.dart" = "package:muzhiki_support/features/chat/chat_bottom_widgets.dart"
  "package:muzhiki_support/app/feature/presentation/chat_view/chat_header_widgets.dart" = "package:muzhiki_support/features/chat/chat_header_widgets.dart"
  "package:muzhiki_support/app/feature/presentation/chat_view/chat_message_widgets.dart" = "package:muzhiki_support/features/chat/chat_message_widgets.dart"
  "package:muzhiki_support/app/feature/presentation/chat_view/widgets/" = "package:muzhiki_support/features/chat/widgets/"
  "package:muzhiki_support/app/feature/state/attachments/" = "package:muzhiki_support/features/chat/state/"

  # features informator
  "package:muzhiki_support/app/feature/presentation/informator/informator_view.dart" = "package:muzhiki_support/features/informator/informator_view.dart"

  # shared widgets
  "package:muzhiki_support/app/feature/widgets/appbar_main/" = "package:muzhiki_support/shared/widgets/appbar/"
  "package:muzhiki_support/app/feature/widgets/attachment/" = "package:muzhiki_support/shared/widgets/attachment/"
  "package:muzhiki_support/app/feature/widgets/bubble_chat.dart" = "package:muzhiki_support/shared/widgets/bubble_chat.dart"
  "package:muzhiki_support/app/feature/widgets/chat_container.dart" = "package:muzhiki_support/shared/widgets/chat_container.dart"
  "package:muzhiki_support/app/feature/widgets/circle.dart" = "package:muzhiki_support/shared/widgets/circle.dart"
  "package:muzhiki_support/app/feature/widgets/photo_view_widget.dart" = "package:muzhiki_support/shared/widgets/photo_view_widget.dart"
  "package:muzhiki_support/app/feature/widgets/text_field.dart" = "package:muzhiki_support/shared/widgets/text_field.dart"
  "package:muzhiki_support/app/feature/widgets/upload_data_widgets.dart" = "package:muzhiki_support/shared/widgets/upload_data_widgets.dart"
  "package:muzhiki_support/app/feature/widgets/video_player.dart" = "package:muzhiki_support/shared/widgets/video_player.dart"
}

$dirs = @(
  (Join-Path $Root "muzhiki_support\lib"),
  (Join-Path $Root "muzhiki_report_problem\lib")
)

$changed = 0
foreach ($dir in $dirs) {
  Get-ChildItem -Path $dir -Recurse -Filter *.dart | ForEach-Object {
    $content = Get-Content -Raw -Path $_.FullName -Encoding UTF8
    $original = $content
    foreach ($key in $replacements.Keys) {
      $content = $content.Replace($key, $replacements[$key])
    }
    if ($content -ne $original) {
      Set-Content -Path $_.FullName -Value $content -Encoding UTF8 -NoNewline
      $changed++
    }
  }
}

Write-Host "Rewrote $changed files"
