// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageDataModel _$LanguageDataModelFromJson(Map<String, dynamic> json) =>
    LanguageDataModel(
      code: json['code'] as String,
      name: json['name'] as String,
      isauto: json['isauto'] as bool,
    );

Map<String, dynamic> _$LanguageDataModelToJson(LanguageDataModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'isauto': instance.isauto,
    };
