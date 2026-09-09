import 'package:muzhiki_stories/data/model/story_enums.dart';

class StoryItemModel {
  final String id;
  final String storyId;
  final StoryContentType contentType;
  final bool showText;
  final String? textColorMode;
  final String imageUrl;
  final int? durationSeconds;
  final bool isPreview;
  final int sortOrder;

  const StoryItemModel({
    required this.id,
    required this.storyId,
    required this.contentType,
    required this.showText,
    required this.textColorMode,
    required this.imageUrl,
    required this.durationSeconds,
    required this.isPreview,
    required this.sortOrder,
  });

  factory StoryItemModel.fromJson(Map<String, dynamic> json) {
    return StoryItemModel(
      id: json['id']?.toString() ?? '',
      storyId: json['story_id']?.toString() ?? '',
      contentType: StoryContentType.fromJson(json['content_type'] as String?),
      showText: json['show_text'] as bool? ?? false,
      textColorMode: json['text_color_mode'] as String?,
      imageUrl: json['image_url'] as String? ?? '',
      durationSeconds: json['duration_s'] as int?,
      isPreview: json['is_preview'] as bool? ?? false,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'story_id': storyId,
    'content_type': contentType.name,
    'show_text': showText,
    'text_color_mode': textColorMode,
    'image_url': imageUrl,
    'duration_s': durationSeconds,
    'is_preview': isPreview,
    'sort_order': sortOrder,
  };
}
