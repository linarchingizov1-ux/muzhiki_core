import 'package:json_annotation/json_annotation.dart';

part 'session_roles.g.dart';

@JsonSerializable()
class RolesModel {
  @JsonKey(name: 'roles')
  final List<RolesInfoModel> info;

  @JsonKey(name: 'flags')
  final Map<String, dynamic> rawFlags;

  RolesModel({required this.info, required this.rawFlags});

  SessionRole get currentRole => SessionRole.fromFlags(rawFlags);
  bool get isDNK => SessionRole.isDNK(booleanRole: rawFlags);

  factory RolesModel.fromJson(Map<String, dynamic> json) =>
      _$RolesModelFromJson(json);

  Map<String, dynamic> toJson() => _$RolesModelToJson(this);
}

@JsonSerializable()
class RolesInfoModel {
  final String id;
  final String name;
  final List<RolesRankCompany> companies;

  RolesInfoModel({
    required this.id,
    required this.name,
    required this.companies,
  });

  factory RolesInfoModel.fromJson(Map<String, dynamic> json) =>
      _$RolesInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$RolesInfoModelToJson(this);
}

@JsonSerializable()
class RolesRankCompany {
  final String id;
  @JsonKey(name: 'yc_id')
  final String ycId;
  final String city;
  final String address;

  RolesRankCompany({
    required this.id,
    required this.ycId,
    required this.city,
    required this.address,
  });

  factory RolesRankCompany.fromJson(Map<String, dynamic> json) =>
      _$RolesRankCompanyFromJson(json);

  Map<String, dynamic> toJson() => _$RolesRankCompanyToJson(this);
}

enum SessionRole {
  franchisee("Франчайзи"),
  master("Мастер"),
  admin("Администратор"),
  intern("Стажер"),
  unknown("Неизвестно");

  final String name;
  const SessionRole(this.name);

  static SessionRole fromFlags(Map<String, dynamic> flags) {
    if (flags['is_admin'] == true) return admin;
    if (flags['is_franchisee'] == true) return franchisee;
    if (flags['is_intern'] == true) return intern;
    if (flags['is_master'] == true) return master;
    return unknown;
  }

  static bool isDNK({required Map<String, dynamic> booleanRole}) =>
      booleanRole['is_dnk'] == true;
  static bool isIntern({required Map<String, dynamic> booleanRole}) =>
      booleanRole['is_intern'] == true;
}
