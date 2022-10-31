import 'package:thai7merchant/model/language_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_choice_struct.g.dart';

/// ข้อเลือกย่อยสินค้า
@JsonSerializable()
class ProductChoiceModel {
  /// อ้างอืงรหัสสินค้า เพื่อตัดสต๊อก
  String refbarcode;

  /// อ้างอิงหน่วยนับ เพื่อตัดสต๊อก
  String refunitcode;

  /// ชื่อข้อเลือกย่อย
  List<LanguageDataModel> names;

  /// ราคาข้อเลือกย่อย (เพิ่ม)
  double price;

  /// จำนวนเพื่อตัดสต๊อก
  double qty;

  /// จำนวนที่เลือกได้สูงสุด
  double qtymax;

  ProductChoiceModel({
    required this.refbarcode,
    required this.refunitcode,
    required this.names,
    required this.price,
    required this.qty,
    required this.qtymax,
  });

  factory ProductChoiceModel.fromJson(Map<String, dynamic> json) =>
      _$ProductChoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductChoiceModelToJson(this);
}
