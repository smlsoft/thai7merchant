import 'package:json_annotation/json_annotation.dart';
import 'package:thai7merchant/model/global_model.dart';

part 'category_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoryModel {
  String guidfixed; //อ้างอิง
  String parentguid; // อ้างอิงตก่อนหน้า (ตัวแม่)
  String parentguidall; // อ้างอิงทั้งหมด (มีคอมม่าขั้น)
  List<LanguageDataModel>? names; // ชื่อ (หลายภาษา)
  int childcount; // จำนวนลูก
  String imageuri; // รูปภาพ
  bool useimageorcolor; // True=Image,False=Color
  String colorselect; // สีที่เลือก
  String colorselecthex; // สีที่เลือก (Hex)
  List<SortDataModel>? xsorts; // ลำดับการเรียง
  List<SortDataModel>? barcodes; // บาร์โค้ด

  CategoryModel({
    required this.guidfixed,
    required this.parentguid,
    required this.parentguidall,
    required this.names,
    required this.imageuri,
    required this.childcount,
    required this.xsorts,
    required this.useimageorcolor,
    required this.barcodes,
    required this.colorselect,
    required this.colorselecthex,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
