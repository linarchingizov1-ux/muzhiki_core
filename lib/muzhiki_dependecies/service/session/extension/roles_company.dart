import 'package:muzhiki_core/muzhiki_dependecies/service/session/model/session_roles.dart';

extension RolesCompany on List<RolesInfoModel> {
  List<RolesRankCompany> getCompaniesByRole(SessionRole? role) {
    return firstWhere(
      (e) => e.name == role?.name,
      orElse: () => RolesInfoModel(id: '', name: '', companies: []),
    ).companies;
  }

  bool get accessAllowedInformator {
    const allowedIds = {'1', '2', '3', '4', '10'};

    for (final roleInfo in this) {
      if (allowedIds.contains(roleInfo.id)) {
        return true;
      }
    }

    return false;
  }
}
