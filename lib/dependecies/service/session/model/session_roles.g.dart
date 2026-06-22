// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_roles.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RolesModel _$RolesModelFromJson(Map<String, dynamic> json) => RolesModel(
  info: (json['roles'] as List<dynamic>)
      .map((e) => RolesInfoModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  rawFlags: json['flags'] as Map<String, dynamic>,
);

Map<String, dynamic> _$RolesModelToJson(RolesModel instance) =>
    <String, dynamic>{'roles': instance.info, 'flags': instance.rawFlags};

RolesInfoModel _$RolesInfoModelFromJson(Map<String, dynamic> json) =>
    RolesInfoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      companies: (json['companies'] as List<dynamic>)
          .map((e) => RolesRankCompany.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RolesInfoModelToJson(RolesInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'companies': instance.companies,
    };

RolesRankCompany _$RolesRankCompanyFromJson(Map<String, dynamic> json) =>
    RolesRankCompany(
      id: json['id'] as String,
      ycId: json['yc_id'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$RolesRankCompanyToJson(RolesRankCompany instance) =>
    <String, dynamic>{
      'id': instance.id,
      'yc_id': instance.ycId,
      'city': instance.city,
      'address': instance.address,
    };
