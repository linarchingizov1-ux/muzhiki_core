import 'package:muzhiki_support/data/models/my_chat.dart';

extension StatusExtension on ChatModel {
  String get stringStatus {
    switch (status) {
      case 'Закрыт':
        return 'Закрыт';
      case 'Открыт':
        return 'Открыт';
      case 'waiting':
        return 'Ожидает вашего ответа';
    }
    return 'В работе';
  }
}
