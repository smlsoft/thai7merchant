import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable()
class Member {
  String guidfixed;
  String address;
  String branchcode;
  int branchtype;
  int contacttype;
  String name;
  int personaltype;
  String surname;
  String taxid;
  String telephone;
  String zipcode;

  Member({
    String? guidfixed,
    String? address,
    String? branchcode,
    required this.branchtype,
    required this.contacttype,
    required this.name,
    required this.personaltype,
    String? surname,
    String? taxid,
    String? telephone,
    String? zipcode,
  })  : guidfixed = guidfixed ?? '',
        address = address ?? '',
        branchcode = branchcode ?? '',
        surname = surname ?? '',
        taxid = taxid ?? '',
        telephone = telephone ?? '',
        zipcode = zipcode ?? '';

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

  Map<String, dynamic> toJson() => _$MemberToJson(this);
}
