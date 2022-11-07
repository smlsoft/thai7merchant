import 'package:json_annotation/json_annotation.dart';
import 'package:thai7merchant/model/language_model.dart';

part 'customer.g.dart';

@JsonSerializable(explicitToJson: true)
class CustomerModel {
  late String guidfixed;

  /// ประเภทลูกค้า (1=บุคคลธรรมดา, 2=นิติบุคคล)
  late int personaltype;

  /// รหัสลูกค้า
  late String code;

  /// ชื่อลูกค้า
  late List<LanguageDataModel> names;

  /// ที่อยูสำหรับเอกสาร
  late CustomerAddressModel addressforbilling;
  late List<CustomerAddressModel> addressforshipping;

  /// รูปภาพ
  late List<String> imageuris;

  /// เลขประจำตัวผู้เสียภาษี/บัตรประชาชน
  late String taxid;

  /// email
  late String email;

  CustomerModel({
    required this.guidfixed,
    required this.code,
    required this.names,
    required this.personaltype,
    required this.addressforbilling,
    required this.addressforshipping,
    required this.imageuris,
    required this.taxid,
    required this.email,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CustomerAddressModel {
  late String guid;

  /// ที่อยู่
  late List<String> address;

  /// รหัสประเทศ
  late String countryCode;

  /// รหัสจังหวัด
  late String provincecode;

  /// รหัสอำเภอ
  late String districtcode;

  /// รหัสตำบล
  late String subDistrictcode;

  /// รหัสไปรษณีย์
  late String zipcode;

  /// ผู้ติดต่อ
  late List<LanguageDataModel> contactnames;

  /// เบอร์โทร
  late String phoneprimary;

  /// เบอร์โทรสำรอง
  late String phonesecondary;

  /// ตำแหน่งดาวเทียม
  late double latitude;
  late double longitude;

  CustomerAddressModel({
    required this.address,
    required this.countryCode,
    required this.provincecode,
    required this.districtcode,
    required this.subDistrictcode,
    required this.zipcode,
    required this.latitude,
    required this.longitude,
    required this.contactnames,
    required this.phoneprimary,
    required this.phonesecondary,
  });

  factory CustomerAddressModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerAddressModelToJson(this);
}
