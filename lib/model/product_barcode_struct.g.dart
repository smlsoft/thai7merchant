// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_barcode_struct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductBarcodeModel _$ProductBarcodeModelFromJson(Map<String, dynamic> json) =>
    ProductBarcodeModel(
      guidfixed: json['guidfixed'] as String,
      categoryguid: json['categoryguid'] as String,
      barcode: json['barcode'] as String,
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemcode: json['itemcode'] as String,
      itemunitcode: json['itemunitcode'] as String,
      itemunitnames: (json['itemunitnames'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      price: (json['price'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      imageuri: json['imageuri'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => ProductOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductBarcodeModelToJson(
        ProductBarcodeModel instance) =>
    <String, dynamic>{
      'guidfixed': instance.guidfixed,
      'itemcode': instance.itemcode,
      'categoryguid': instance.categoryguid,
      'barcode': instance.barcode,
      'names': instance.names,
      'itemunitcode': instance.itemunitcode,
      'itemunitnames': instance.itemunitnames,
      'price': instance.price,
      'imageuri': instance.imageuri,
      'options': instance.options,
    };
