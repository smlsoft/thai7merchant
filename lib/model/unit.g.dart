// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnitModel _$UnitModelFromJson(Map<String, dynamic> json) => UnitModel(
      guidfixed: json['guidfixed'] as String,
      unitcode: json['unitcode'] as String,
      names: (json['names'] as List<dynamic>?)
          ?.map((e) => LanguageMode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UnitModelToJson(UnitModel instance) => <String, dynamic>{
      'unitcode': instance.unitcode,
      'guidfixed': instance.guidfixed,
      'names': instance.names.map((e) => e.toJson()).toList(),
    };
