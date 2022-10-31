// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_choice_struct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductChoiceModel _$ProductChoiceModelFromJson(Map<String, dynamic> json) =>
    ProductChoiceModel(
      refbarcode: json['refbarcode'] as String,
      refunitcode: json['refunitcode'] as String,
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      price: (json['price'] as num).toDouble(),
      qty: (json['qty'] as num).toDouble(),
      qtymax: (json['qtymax'] as num).toDouble(),
    );

Map<String, dynamic> _$ProductChoiceModelToJson(ProductChoiceModel instance) =>
    <String, dynamic>{
      'refbarcode': instance.refbarcode,
      'refunitcode': instance.refunitcode,
      'names': instance.names,
      'price': instance.price,
      'qty': instance.qty,
      'qtymax': instance.qtymax,
    };
