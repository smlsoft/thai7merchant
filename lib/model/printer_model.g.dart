// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrinterModel _$PrinterModelFromJson(Map<String, dynamic> json) => PrinterModel(
      guidfixed: json['guidfixed'] as String,
      code: json['code'] as String,
      name1: json['name1'] as String,
      address: json['address'] as String,
      type: json['type'] as int,
    );

Map<String, dynamic> _$PrinterModelToJson(PrinterModel instance) =>
    <String, dynamic>{
      'guidfixed': instance.guidfixed,
      'code': instance.code,
      'name1': instance.name1,
      'type': instance.type,
      'address': instance.address,
    };
