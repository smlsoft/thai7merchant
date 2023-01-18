import 'package:json_annotation/json_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:thai7merchant/model/global_model.dart';
import 'package:thai7merchant/model/price_model.dart';

part 'config_model.g.dart';

class ConfigModel {
  late List<LanguageModel> languages;
  late List<PriceModel> prices;

  int findLanguageIndex(String code) {
    int index = 0;
    for (int i = 0; i < languages.length; i++) {
      if (languages[i].code == code) {
        index = i;
        break;
      }
    }
    return index;
  }

  String findLanguageName(String code) {
    String name = "";
    for (int i = 0; i < languages.length; i++) {
      if (languages[i].code == code) {
        name = languages[i].name;
        break;
      }
    }
    return name;
  }
}

@JsonSerializable(explicitToJson: true)
class DayWorkTimeModel {
  /// 0=Sunday, 1=Monday, 2=Tuesday, 3=Wednesday, 4=Thursday, 5=Friday, 6=Saturday
  int dayNumber = 0;
  List<String> openTime = [];
  List<String> closeTime = [];
  bool isClose = false;

  DayWorkTimeModel({
    required this.dayNumber,
    required this.openTime,
    required this.closeTime,
    required this.isClose,
  });

  factory DayWorkTimeModel.fromJson(Map<String, dynamic> json) =>
      _$DayWorkTimeModelFromJson(json);

  Map<String, dynamic> toJson() => _$DayWorkTimeModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DayCloseModel {
  List<String> dates = [];
  List<String> openTime = [];
  List<String> closeTime = [];
  bool isClose = false;

  DayCloseModel({
    required this.dates,
    required this.openTime,
    required this.closeTime,
    required this.isClose,
  });

  factory DayCloseModel.fromJson(Map<String, dynamic> json) =>
      _$DayCloseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DayCloseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CompanyModel {
  List<LanguageDataModel> names;
  String taxID;
  List<LanguageDataModel> branchNames;
  List<LanguageDataModel> addresses;
  List<String> phones;
  List<String> emailOwners;
  List<String> emailStaffs;
  double latitude;
  double longitude;
  List<ImagesModel> images;

  CompanyModel({
    required this.names,
    required this.taxID,
    required this.branchNames,
    required this.addresses,
    required this.phones,
    required this.emailOwners,
    required this.emailStaffs,
    required this.latitude,
    required this.longitude,
    required this.images,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WorkingTimeModel {
  final List<DayWorkTimeModel> dayWorkTimes;
  final List<DayCloseModel> dayCloses;

  WorkingTimeModel({
    required this.dayWorkTimes,
    required this.dayCloses,
  });

  factory WorkingTimeModel.fromJson(Map<String, dynamic> json) =>
      _$WorkingTimeModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkingTimeModelToJson(this);
}

@JsonSerializable()
class DeviceConfigModel {
  double listDataFontSize;

  DeviceConfigModel({
    required this.listDataFontSize,
  });

  factory DeviceConfigModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceConfigModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceConfigModelToJson(this);
}
