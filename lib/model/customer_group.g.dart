// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerGroupModel _$CustomerGroupModelFromJson(Map<String, dynamic> json) =>
    CustomerGroupModel(
      guidfixed: json['guidfixed'] as String,
      customercode: json['customercode'] as String,
      names: (json['names'] as List<dynamic>?)
          ?.map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomerGroupModelToJson(CustomerGroupModel instance) =>
    <String, dynamic>{
      'guidfixed': instance.guidfixed,
      'customercode': instance.customercode,
      'names': instance.names.map((e) => e.toJson()).toList(),
    };
