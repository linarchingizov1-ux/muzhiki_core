import 'package:muzhiki_core/muzhiki_support/app/data/model/my_chat.dart';

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
