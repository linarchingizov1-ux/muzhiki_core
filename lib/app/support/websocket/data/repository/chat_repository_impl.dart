import 'package:dio/dio.dart';
import 'package:muzhiki_core/app/support/websocket/data/model/mobile_widget.dart';
import 'package:muzhiki_core/app/support/websocket/data/model/my_chat.dart';
import 'package:muzhiki_core/app/support/websocket/domain/repository/chat_repository.dart';
import 'package:muzhiki_core/app/support/websocket/data/model/socket_connection.dart';
import 'package:muzhiki_core/dependecies/network/exception/network_map_error.dart';

class ChatRepositoryImpl implements ChatRepository {
  final Dio dio;
  const ChatRepositoryImpl({required this.dio});
  @override
  Future<MyChatModel> getMyChats({required int page}) async {
    try {
      final response = await dio.get(
        "https://api.webchat.muzhiki.pro/my-chats",
        queryParameters: {"page": page},
      );

      return MyChatModel.fromJson(response.data);
    } catch (e, st) {
      throw AppErrorMapper.I.map(e, st);
    }
  }

  @override
  Future getMyChannel() async =>
      await dio.get("https://api.erp.muzhiki.pro/api/v1/messenger/channels");

  @override
  Future<int> createSession({required int channelId}) async {
    try {
      final response = await dio.post(
        "https://api.webchat.muzhiki.pro/create-session",
        data: {"channel_id": channelId, "app_type": "mp_master"},
      );

      return response.data['session_id'] as int;
    } catch (e, st) {
      throw AppErrorMapper.I.map(e, st);
    }
  }

  @override
  Future<SocketConnectionModel> getMessageChat({required int sessionId}) async {
    try {
      final response = await dio.get(
        "https://api.webchat.muzhiki.pro/chat/$sessionId",
      );
      final data = SocketConnectionModel.fromJson(response.data);

      return data;
    } catch (e, st) {
      throw AppErrorMapper.I.map(e, st);
    }
  }

  @override
  Future<MobileWidgetModel?> getMobileWidget() async {
    try {
      final response = await dio.get(
        "https://api.webchat.muzhiki.pro/get-mobile-widget",
      );

      if (response.data == null ||
          response.data is Map && (response.data as Map).isEmpty) {
        return null;
      }

      return MobileWidgetModel.fromJson(response.data);
    } catch (e, st) {
      throw AppErrorMapper.I.map(e, st);
    }
  }

  @override
  Future<bool> reopenWebChat({required int sessionId}) async {
    try {
      final response = await dio.post(
        "https://api.webchat.muzhiki.pro/session-reopen",
        data: {"session_id": sessionId},
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e, st) {
      throw AppErrorMapper.I.map(e, st);
    }
  }

  @override
  Future<bool> postScoreWebChat({
    required int sessionId,
    required int score,
  }) async {
    try {
      final data = {"session_id": sessionId, "score": score};
      final result = await dio.post(
        "https://api.webchat.muzhiki.pro/set-score",
        data: data,
      );
      if (result.statusCode == 200 && result.data['success'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e, st) {
      throw AppErrorMapper.I.map(e, st);
    }
  }
}
