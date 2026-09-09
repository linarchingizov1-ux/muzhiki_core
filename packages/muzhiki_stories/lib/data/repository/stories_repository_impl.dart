import 'package:dio/dio.dart';
import 'package:muzhiki_dependencies/muzhiki_dependencies.dart';
import 'package:muzhiki_stories/data/model/story_model.dart';
import 'package:muzhiki_stories/domain/repository/stories_repository.dart';

class StoriesRepositoryImpl implements StoriesRepository {
  final Dio dio;
  final int placeId;
  final String creativesUrl;

  const StoriesRepositoryImpl({
    required this.dio,
    required this.placeId,
    required this.creativesUrl,
  });

  @override
  Future<List<StoryModel>> getStories() async {
    try {
      final response = await dio.get(
        creativesUrl,
        queryParameters: {
          'place_id': placeId,
          'type': 'story',
        },
      );

      return StoriesResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      ).data;
    } catch (e, st) {
      throw AppErrorMapper.I.map(e, st);
    }
  }
}
