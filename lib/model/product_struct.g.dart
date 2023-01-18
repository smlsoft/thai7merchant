// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_struct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      guidfixed: json['guidfixed'] as String,
      categoryguid: json['categoryguid'] as String,
      barcodes:
          (json['barcodes'] as List<dynamic>).map((e) => e as String).toList(),
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemcode: json['itemcode'] as String,
      useserialnumber: json['useserialnumber'] as bool,
      units: (json['units'] as List<dynamic>)
          .map((e) => ProductUnitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      images: (json['images'] as List<dynamic>)
          .map((e) => ImagesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      unitcost: json['unitcost'] as String,
      unitstandard: json['unitstandard'] as String,
      multiunit: json['multiunit'] as bool,
      itemstocktype: json['itemstocktype'] as int,
      vattype: json['vattype'] as int,
      issumpoint: json['issumpoint'] as bool,
      itemtype: json['itemtype'] as int,
      prices: (json['prices'] as List<dynamic>)
          .map((e) => PriceDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'guidfixed': instance.guidfixed,
      'itemcode': instance.itemcode,
      'categoryguid': instance.categoryguid,
      'barcodes': instance.barcodes,
      'names': instance.names.map((e) => e.toJson()).toList(),
      'multiunit': instance.multiunit,
      'useserialnumber': instance.useserialnumber,
      'units': instance.units.map((e) => e.toJson()).toList(),
      'images': instance.images.map((e) => e.toJson()).toList(),
      'unitcost': instance.unitcost,
      'unitstandard': instance.unitstandard,
      'itemstocktype': instance.itemstocktype,
      'itemtype': instance.itemtype,
      'vattype': instance.vattype,
      'issumpoint': instance.issumpoint,
      'prices': instance.prices.map((e) => e.toJson()).toList(),
    };

ProductUnitModel _$ProductUnitModelFromJson(Map<String, dynamic> json) =>
    ProductUnitModel(
      unitcode: json['unitcode'] as String,
      unitname: json['unitname'] as String,
      divider: (json['divider'] as num).toDouble(),
      stand: (json['stand'] as num).toDouble(),
      xorder: json['xorder'] as int,
      stockcount: json['stockcount'] as bool,
    );

Map<String, dynamic> _$ProductUnitModelToJson(ProductUnitModel instance) =>
    <String, dynamic>{
      'unitcode': instance.unitcode,
      'unitname': instance.unitname,
      'divider': instance.divider,
      'stand': instance.stand,
      'xorder': instance.xorder,
      'stockcount': instance.stockcount,
    };

ProductUnitPriceModel _$ProductUnitPriceModelFromJson(
        Map<String, dynamic> json) =>
    ProductUnitPriceModel(
      unitcode: json['unitcode'] as String,
      prices: (json['prices'] as List<dynamic>)
          .map((e) => PriceDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductUnitPriceModelToJson(
        ProductUnitPriceModel instance) =>
    <String, dynamic>{
      'unitcode': instance.unitcode,
      'prices': instance.prices.map((e) => e.toJson()).toList(),
    };

ProductWareHouseModel _$ProductWareHouseModelFromJson(
        Map<String, dynamic> json) =>
    ProductWareHouseModel(
      code: json['code'] as String,
      locatecodes: (json['locatecodes'] as List<dynamic>)
          .map((e) => ProductLocationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductWareHouseModelToJson(
        ProductWareHouseModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'locatecodes': instance.locatecodes.map((e) => e.toJson()).toList(),
    };

ProductLocationModel _$ProductLocationModelFromJson(
        Map<String, dynamic> json) =>
    ProductLocationModel(
      code: json['code'] as String,
      recommendshelfs: (json['recommendshelfs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ProductLocationModelToJson(
        ProductLocationModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'recommendshelfs': instance.recommendshelfs,
    };

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
      prices: (json['prices'] as List<dynamic>)
          .map((e) => PriceDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageuri: json['imageuri'] as String,
      useimageorcolor: json['useimageorcolor'] as bool,
      colorselect: json['colorselect'] as String,
      colorselecthex: json['colorselecthex'] as String,
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
      'names': instance.names.map((e) => e.toJson()).toList(),
      'itemunitcode': instance.itemunitcode,
      'itemunitnames': instance.itemunitnames.map((e) => e.toJson()).toList(),
      'prices': instance.prices.map((e) => e.toJson()).toList(),
      'imageuri': instance.imageuri,
      'useimageorcolor': instance.useimageorcolor,
      'colorselect': instance.colorselect,
      'colorselecthex': instance.colorselecthex,
      'options': instance.options.map((e) => e.toJson()).toList(),
    };

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
      price: json['price'] as String,
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

ProductOptionModel _$ProductOptionModelFromJson(Map<String, dynamic> json) =>
    ProductOptionModel(
      guid: json['guid'] as String,
      choicetype: json['choicetype'] as int,
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
      'choicetype': instance.choicetype,
      'minselect': instance.minselect,
      'maxselect': instance.maxselect,
      'names': instance.names.map((e) => e.toJson()).toList(),
      'choices': instance.choices.map((e) => e.toJson()).toList(),
    };

UnitModel _$UnitModelFromJson(Map<String, dynamic> json) => UnitModel(
      guidfixed: json['guidfixed'] as String,
      unitcode: json['unitcode'] as String,
      names: (json['names'] as List<dynamic>?)
          ?.map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UnitModelToJson(UnitModel instance) => <String, dynamic>{
      'unitcode': instance.unitcode,
      'guidfixed': instance.guidfixed,
      'names': instance.names.map((e) => e.toJson()).toList(),
    };
