import 'package:json_annotation/json_annotation.dart';
import 'package:muzhiki_core/dependecies/service/session/model/session_roles.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel {
  @JsonKey(name: 'username')
  final String username;

  final DateTime? createdAt;

  @JsonKey(name: 'first_name')
  final String firstName;

  @JsonKey(name: 'last_name')
  final String lastName;

  @JsonKey(name: 'mpid')
  final String mpid;

  final String? phone;
  final String? avatar;

  @JsonKey(name: 'is_first_auth', defaultValue: true)
  final bool isFirstAuth;

  @JsonKey(name: 'is_fake', defaultValue: true)
  final bool isFake;
  @JsonKey(name: 'isAllowedAccessInformator', defaultValue: true)
  final bool isAllowedAccessInformator;

  final RolesModel? roles;
  final String selectedRolesCompany;

  const UserModel({
    required this.mpid,
    this.createdAt,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.selectedRolesCompany = "0",
    this.roles,
    this.isFirstAuth = true,
    this.isAllowedAccessInformator = false,
    this.isFake = true,
    this.phone,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    bool? isAllowedAccessInformator,
    String? mpid,
    DateTime? createdAt,
    String? username,
    String? firstName,
    String? lastName,
    String? phone,
    bool? isFake,
    String? avatar,
    RolesModel? roles,
    bool? isFirstAuth,
    String? selectedRolesCompany,
  }) {
    return UserModel(
      isAllowedAccessInformator:
          isAllowedAccessInformator ?? this.isAllowedAccessInformator,
      selectedRolesCompany: selectedRolesCompany ?? this.selectedRolesCompany,
      mpid: mpid ?? this.mpid,
      createdAt: createdAt ?? this.createdAt,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      isFake: isFake ?? this.isFake,
      avatar: avatar ?? this.avatar,
      roles: roles ?? this.roles,
      isFirstAuth: isFirstAuth ?? this.isFirstAuth,
    );
  }
}
