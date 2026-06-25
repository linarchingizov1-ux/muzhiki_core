import 'package:dio/dio.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_map_error.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/app_path.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/my_chat.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/socket_connection.dart';
import 'package:muzhiki_core/muzhiki_support/app/domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final Dio dio;
  const ChatRepositoryImpl(this.dio);
  @override
  Future<MyChatModel> getMyChats({required int page}) async {
    try {
      final response = await dio.get(
        SupportPath.myChat,
        queryParameters: {"page": page},
      );

      return MyChatModel.fromJson(response.data);
    } catch (e, st) {
      throw AppErrorMapper.I.map(e, st);
    }
  }

  @override
  Future getMyChannel() async {
    await dio.get(SupportPath.getMyChannel);
  }

  @override
  Future<int> createSession({required int channelId}) async {
    try {
      final response = await dio.post(
        SupportPath.createSession,
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
        SupportPath.getMessageChat(sessionId: sessionId),
      );
      final data = SocketConnectionModel.fromJson(response.data);

      return data;
    } catch (e, st) {
      throw AppErrorMapper.I.map(e, st);
    }
  }

  // @override
  // Future<MobileWidgetModel?> getMobileWidget() async {
  //   try {
  //     final response = await dio.get(SupportPath.I.getMobileWidgets);

  //     if (response.data == null ||
  //         response.data is Map && (response.data as Map).isEmpty) {
  //       return null;
  //     }

  //     return MobileWidgetModel.fromJson(response.data);
  //   } catch (e, st) {
  //     throw AppErrorMapper.I.map(e, st);
  //   }
  // }

  @override
  Future<bool> reopenWebChat({required int sessionId}) async {
    try {
      final response = await dio.post(
        SupportPath.reopenWebChat,
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
      final result = await dio.post(SupportPath.postScoreWebChat, data: data);
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
