// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_mode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageMode _$LanguageModeFromJson(Map<String, dynamic> json) => LanguageMode(
      code: json['code'] as String? ?? "",
      name: json['name'] as String? ?? "",
      use: json['use'] as bool? ?? false,
      isauto: json['isauto'] as bool? ?? false,
    );

Map<String, dynamic> _$LanguageModeToJson(LanguageMode instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'use': instance.use,
      'isauto': instance.isauto,
    };
