// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  mpid: json['mpid'] as String,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  username: json['username'] as String,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  selectedRolesCompany: json['selectedRolesCompany'] as String? ?? "0",
  roles: json['roles'] == null
      ? null
      : RolesModel.fromJson(json['roles'] as Map<String, dynamic>),
  isFirstAuth: json['is_first_auth'] as bool? ?? true,
  isAllowedAccessInformator: json['isAllowedAccessInformator'] as bool? ?? true,
  isFake: json['is_fake'] as bool? ?? true,
  phone: json['phone'] as String?,
  avatar: json['avatar'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'username': instance.username,
  'createdAt': instance.createdAt?.toIso8601String(),
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'mpid': instance.mpid,
  'phone': instance.phone,
  'avatar': instance.avatar,
  'is_first_auth': instance.isFirstAuth,
  'is_fake': instance.isFake,
  'isAllowedAccessInformator': instance.isAllowedAccessInformator,
  'roles': instance.roles?.toJson(),
  'selectedRolesCompany': instance.selectedRolesCompany,
};
