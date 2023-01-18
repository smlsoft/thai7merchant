import 'package:thai7merchant/model/global_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:thai7merchant/model/price_model.dart';

part 'product_struct.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductModel {
  /// guid ฐานข้อมูล
  String guidfixed;

  /// รหัสสินค้า
  String itemcode;

  /// guid กลุ่มสินค้า
  String categoryguid;

  /// Barcode (หลายตัว)
  List<String> barcodes;

  /// ชื่อสินค้า (หลายภาษา)
  List<LanguageDataModel> names;

  /// True=หลายหน่วยนับ,​ False=หน่วยนับเดียว
  bool multiunit;

  /// True=ใช้ Serial Number,​ False=ไม่ใช้ Serial Number
  bool useserialnumber;
  // หน่วยนับ (หลายหน่วยนับ)
  List<ProductUnitModel> units;

  /// uri รูปภาพ (หลายรูป)
  List<ImagesModel> images;
  // หน่วยต้นทุน สำหรับจัดทำบัญชี (เปลี่ยนไม่ได้)
  String unitcost;

  /// หน่วยมาตราฐาน สำหรับแสดงในรายการค้นหา (เปลี่ยนไปมาได้)
  String unitstandard;

  /// ประเภทสินค้า 0=สินค้า, (มีสต๊อก)​ 1=บริการ (ไม่มีสต๊อก)
  int itemstocktype;

  /// ประเภทสินค้า 0=สินค้าทั่วไป,​ 1=อาหาร,​ 2=เครื่องดื่ม
  int itemtype;

  /// ภาษี 1=คิดภาษีมูลค่าเพิ่ม, 2=ยกเว้นภาษีมูลค่าเพิ่ม
  int vattype;

  /// คิดคะแนน False=ไม่คิด,​ True=คิด (สะสมแต้ม)
  bool issumpoint;

  /// ราคาขาย (หลายราคา)
  List<PriceDataModel> prices;

  ProductModel({
    required this.guidfixed,
    required this.categoryguid,
    required this.barcodes,
    required this.names,
    required this.itemcode,
    required this.useserialnumber,
    required this.units,
    required this.images,
    required this.unitcost,
    required this.unitstandard,
    required this.multiunit,
    required this.itemstocktype,
    required this.vattype,
    required this.issumpoint,
    required this.itemtype,
    required this.prices,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProductUnitModel {
  /// รหัสหน่วยนับ
  String unitcode;

  /// ชื่อหน่วยนับ
  String unitname;

  /// ตัวหาร
  double divider;

  /// ตัวตั้ง
  double stand;

  /// ลำดับ
  int xorder;

  /// นับสต๊อก
  bool stockcount;

  ProductUnitModel({
    required this.unitcode,
    required this.unitname,
    required this.divider,
    required this.stand,
    required this.xorder,
    required this.stockcount,
  });

  factory ProductUnitModel.fromJson(Map<String, dynamic> json) =>
      _$ProductUnitModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductUnitModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProductUnitPriceModel {
  String unitcode; // รหัสหน่วยนับ
  List<PriceDataModel> prices; // ราคาขาย

  ProductUnitPriceModel({
    required this.unitcode,
    required this.prices,
  });

  factory ProductUnitPriceModel.fromJson(Map<String, dynamic> json) =>
      _$ProductUnitPriceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductUnitPriceModelToJson(this);
}

/// คลังสินค้า
@JsonSerializable(explicitToJson: true)
class ProductWareHouseModel {
  String code; // รหัสคลังสินค้า
  List<ProductLocationModel> locatecodes; // รหัสตำแหน่ง

  ProductWareHouseModel({
    required this.code,
    required this.locatecodes,
  });

  factory ProductWareHouseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductWareHouseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductWareHouseModelToJson(this);
}

/// บริเวณที่เก็บสินค้า
@JsonSerializable(explicitToJson: true)
class ProductLocationModel {
  String code; // รหัสบริเวณ
  List<String> recommendshelfs; // แนะนำที่วาง

  ProductLocationModel({
    required this.code,
    required this.recommendshelfs,
  });

  factory ProductLocationModel.fromJson(Map<String, dynamic> json) =>
      _$ProductLocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductLocationModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProductBarcodeModel {
  /// guid ฐานข้อมูล
  String guidfixed;

  /// รหัสสินค้า
  String itemcode;

  /// guid กลุ่มสินค้า
  String categoryguid;

  /// Barcode
  String barcode;

  /// ชื่อสินค้า
  List<LanguageDataModel> names;

  /// รหัสหน่วยนับ
  String itemunitcode;

  /// ชื่อหน่วยนับ
  List<LanguageDataModel> itemunitnames;

  /// ราคาขาย
  List<PriceDataModel> prices;

  /// uri รูปภาพ
  String imageuri;

  /// ใช้รูปหรือสี True=Image,False=Color
  bool useimageorcolor;

  /// สีที่เลือก
  String colorselect;

  /// สีที่เลือก (Hex)
  String colorselecthex;

  /// ข้อเลือกสินค้า (เช่น เพิ่มไข่)
  List<ProductOptionModel> options;

  ProductBarcodeModel({
    required this.guidfixed,
    required this.categoryguid,
    required this.barcode,
    required this.names,
    required this.itemcode,
    required this.itemunitcode,
    required this.itemunitnames,
    required this.prices,
    required this.imageuri,
    required this.useimageorcolor,
    required this.colorselect,
    required this.colorselecthex,
    required this.options,
  });

  factory ProductBarcodeModel.fromJson(Map<String, dynamic> json) =>
      _$ProductBarcodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductBarcodeModelToJson(this);
}

/// ข้อเลือกย่อยสินค้า
@JsonSerializable(explicitToJson: true)
class ProductChoiceModel {
  String guid;

  /// ชื่อข้อเลือกย่อย
  List<LanguageDataModel> names;

  /// ราคาข้อเลือกย่อย (เพิ่ม) บาท/เปอร์เซ็นต์
  String price;

  /// ตัดสต๊อกสินค้า
  bool isstock;

  /// อ้างอิง Barcode
  String refbarcode;

  /// อ้างอิงสินค้า เพื่อตัดสต๊อก
  String refproductcode;

  /// อ้างอิงหน่วยนับ เพื่อตัดสต๊อก
  String refunitcode;

  /// จำนวนเพื่อตัดสต๊อก
  double qty;

  ProductChoiceModel({
    required this.guid,
    required this.refbarcode,
    required this.refproductcode,
    required this.refunitcode,
    required this.names,
    required this.isstock,
    required this.price,
    required this.qty,
  });

  factory ProductChoiceModel.fromJson(Map<String, dynamic> json) =>
      _$ProductChoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductChoiceModelToJson(this);
}

/// ข้อเลือกพิเศษ
@JsonSerializable(explicitToJson: true)
class ProductOptionModel {
  String guid;

  /// ประเภทข้อเลือก (0=Check Box,1=Radio Button)
  int choicetype = 0;

  /// เลือกได้น้อยสุด
  int minselect = 0;

  /// เลือกได้สูงสุด
  int maxselect = 0;

  /// ชื่อข้อเลือกพิเศษ
  List<LanguageDataModel> names;

  /// รายการข้อเลือกย่อย
  List<ProductChoiceModel> choices;

  ProductOptionModel({
    required this.guid,
    required this.choicetype,
    required this.maxselect,
    required this.names,
    required this.minselect,
    required this.choices,
  });

  factory ProductOptionModel.fromJson(Map<String, dynamic> json) =>
      _$ProductOptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductOptionModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UnitModel {
  String unitcode;
  String guidfixed;
  List<LanguageDataModel> names = <LanguageDataModel>[];

  UnitModel({
    required this.guidfixed,
    required this.unitcode,
    List<LanguageDataModel>? names,
  }) : names = names ?? <LanguageDataModel>[];

  factory UnitModel.fromJson(Map<String, dynamic> json) =>
      _$UnitModelFromJson(json);

  Map<String, dynamic> toJson() => _$UnitModelToJson(this);
}
