// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_option_struct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductOptionModel _$ProductOptionModelFromJson(Map<String, dynamic> json) =>
    ProductOptionModel(
      guid: json['guid'] as String,
      maxselect: json['maxselect'] as int,
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      minselect: json['minselect'] as int,
      choices: (json['choices'] as List<dynamic>)
          .map((e) => ProductChoiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductOptionModelToJson(ProductOptionModel instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'minselect': instance.minselect,
      'maxselect': instance.maxselect,
      'names': instance.names.map((e) => e.toJson()).toList(),
      'choices': instance.choices.map((e) => e.toJson()).toList(),
    };
