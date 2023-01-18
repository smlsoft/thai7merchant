// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kitchen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KitchenModel _$KitchenModelFromJson(Map<String, dynamic> json) => KitchenModel(
      guidfixed: json['guidfixed'] as String,
      code: json['code'] as String,
      name1: json['name1'] as String,
      printers:
          (json['printers'] as List<dynamic>).map((e) => e as String).toList(),
      products:
          (json['products'] as List<dynamic>).map((e) => e as String).toList(),
      zones: (json['zones'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$KitchenModelToJson(KitchenModel instance) =>
    <String, dynamic>{
      'guidfixed': instance.guidfixed,
      'code': instance.code,
      'name1': instance.name1,
      'printers': instance.printers,
      'products': instance.products,
      'zones': instance.zones,
    };
