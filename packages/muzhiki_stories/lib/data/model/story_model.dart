import 'package:muzhiki_stories/data/model/story_enums.dart';
import 'package:muzhiki_stories/data/model/story_item_model.dart';

class StoryModel {
  final String id;
  final String? title;
  final String? description;
  final String? previewActionText;
  final StoryFirstScreenMode firstScreenMode;
  final bool firstScreenPreload;
  final StoryActionType fullscreenActionType;
  final String? fullscreenActionText;
  final String? fullscreenActionLink;
  final String colorMode;
  final StoryActionType markdownActionType;
  final String? markdownBody;
  final String? markdownActionText;
  final String? markdownActionLink;
  final bool isActive;
  final List<StoryItemModel> items;

  const StoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.previewActionText,
    required this.firstScreenMode,
    required this.firstScreenPreload,
    required this.fullscreenActionType,
    required this.fullscreenActionText,
    required this.fullscreenActionLink,
    required this.colorMode,
    required this.markdownActionType,
    required this.markdownBody,
    required this.markdownActionText,
    required this.markdownActionLink,
    required this.isActive,
    required this.items,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? const [];
    final items = rawItems
        .whereType<Map<String, dynamic>>()
        .map(StoryItemModel.fromJson)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return StoryModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String?,
      description: json['description'] as String?,
      previewActionText: json['preview_action_text'] as String?,
      firstScreenMode: StoryFirstScreenMode.fromJson(
        json['first_screen_mode'] as String?,
      ),
      firstScreenPreload: json['first_screen_preload'] as bool? ?? false,
      fullscreenActionType: StoryActionType.fromJson(
        json['fullscreen_action_type'] as String?,
      ),
      fullscreenActionText: json['fullscreen_action_text'] as String?,
      fullscreenActionLink: json['fullscreen_action_link'] as String?,
      colorMode: json['color_mode'] as String? ?? '',
      markdownActionType: StoryActionType.fromJson(
        json['markdown_action_type'] as String?,
      ),
      markdownBody: json['markdown_body'] as String?,
      markdownActionText: json['markdown_action_text'] as String?,
      markdownActionLink: json['markdown_action_link'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      items: items,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'preview_action_text': previewActionText,
    'first_screen_mode': firstScreenMode.name,
    'first_screen_preload': firstScreenPreload,
    'fullscreen_action_type': fullscreenActionType.name,
    'fullscreen_action_text': fullscreenActionText,
    'fullscreen_action_link': fullscreenActionLink,
    'color_mode': colorMode,
    'markdown_action_type': markdownActionType.name,
    'markdown_body': markdownBody,
    'markdown_action_text': markdownActionText,
    'markdown_action_link': markdownActionLink,
    'is_active': isActive,
    'items': items.map((e) => e.toJson()).toList(),
  };
}

class StoriesResponseModel {
  final bool success;
  final List<StoryModel> data;

  const StoriesResponseModel({required this.success, required this.data});

  factory StoriesResponseModel.fromJson(Map<String, dynamic> json) {
    final raw = json['data'] as List<dynamic>? ?? const [];
    return StoriesResponseModel(
      success: json['success'] as bool? ?? false,
      data: raw
          .whereType<Map<String, dynamic>>()
          .map(StoryModel.fromJson)
          .toList(),
    );
  }
}
