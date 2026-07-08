import 'package:muzhiki_core/muzhiki_dependecies/service/session/model/session_roles.dart';
import 'package:talker/talker.dart';

extension RolesCompany on List<RolesInfoModel> {
  List<RolesRankCompany> getCompaniesByRole(SessionRole? role) {
    return firstWhere(
      (e) => e.name == role?.name,
      orElse: () => RolesInfoModel(id: '', name: '', companies: []),
    ).companies;
  }

  bool get accessAllowedInformator {
    final talker = Talker();
    const allowedIds = {'1', '2', '3', '4', '10'};

    talker.debug("--- ПРОВЕРКА ДОСТУПА ИНФОРМАТОРА ---");
    talker.debug("Всего ролей у пользователя: $length");

    for (final roleInfo in this) {
      talker.debug(
        "Проверяем роль: (id: ${roleInfo.id}, name: ${roleInfo.name})",
      );

      if (allowedIds.contains(roleInfo.id)) {
        talker.debug("Доступ РАЗРЕШЕН для роли id: ${roleInfo.id}");
        return true;
      }
    }

    talker.debug("Доступ ЗАПРЕЩЕН: ни один id не совпал с $allowedIds");
    return false;
  }
}
