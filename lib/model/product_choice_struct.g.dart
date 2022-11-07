// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_choice_struct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductChoiceModel _$ProductChoiceModelFromJson(Map<String, dynamic> json) =>
    ProductChoiceModel(
      guid: json['guid'] as String,
      refbarcode: json['refbarcode'] as String,
      refproductcode: json['refproductcode'] as String,
      refunitcode: json['refunitcode'] as String,
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isstock: json['isstock'] as bool,
      price: (json['price'] as num).toDouble(),
      qty: (json['qty'] as num).toDouble(),
    );

Map<String, dynamic> _$ProductChoiceModelToJson(ProductChoiceModel instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'names': instance.names.map((e) => e.toJson()).toList(),
      'price': instance.price,
      'isstock': instance.isstock,
      'refbarcode': instance.refbarcode,
      'refproductcode': instance.refproductcode,
      'refunitcode': instance.refunitcode,
      'qty': instance.qty,
    };
