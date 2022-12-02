import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thai7merchant/global.dart' as global;
import 'package:thai7merchant/model/config_model.dart';
import 'package:thai7merchant/model/global_model.dart';
import 'package:thai7merchant/model/price_model.dart';
import 'package:thai7merchant/model/public_color_model.dart';
import 'package:thai7merchant/model/public_name_model.dart';

enum LoginType { none, google, facebook, apple }

String userLanguage = "";
bool apiConnected = false;
String apiToken = "";
String apiUserName = "tester";
String apiUserPassword = "tester";
String apiShopCode =
    "27dcEdktOoaSBYFmnN6G6ett4Jb"; // "27dcEdktOoaSBYFmnN6G6ett4Jb";
bool isLoginProcess = false;
GetStorage appConfig = GetStorage('AppConfig');
String systemLanguage = "th";
String loginName = "";
String loginEmail = "";
String loginPhotoUrl = "";
List<PublicColorModel> publicColors = [];
late List<LanguageSystemModel> languageSystemData;
late List<LanguageSystemCodeModel> languageSystemCode;

ConfigModel config = ConfigModel();

String packName(List<LanguageDataModel> names) {
  String result = "";
  for (int i = 0; i < names.length; i++) {
    result += names[i].name;
    if (i < names.length - 1) {
      result += ",";
    }
  }
  return result;
}

void loadConfig() {
  config.prices = [
    PriceModel(
      keynumber: 1,
      isuse: true,
      names: [
        LanguageModel(
            code: "th", codeTranslator: "th", name: "ราคาขายปลีก", use: true)
      ],
    ),
    PriceModel(
      keynumber: 2,
      isuse: true,
      names: [
        LanguageModel(
            code: "th", codeTranslator: "th", name: "ราคาขายสมาชิก", use: true)
      ],
    ),
    PriceModel(
      keynumber: 3,
      isuse: true,
      names: [
        LanguageModel(
            code: "th", codeTranslator: "th", name: "ราคาขาย ลู่ 1", use: true)
      ],
    )
  ];
  config.languages = [
    LanguageModel(code: "th", codeTranslator: "th", name: "ไทย", use: true),
    LanguageModel(code: "en", codeTranslator: "en", name: "อังกฤษ", use: true),
    LanguageModel(code: "cn", codeTranslator: "zh-cn", name: "จีน", use: true),
    LanguageModel(
        code: "jp", codeTranslator: "th", name: "ญี่ปุ่น", use: false),
    LanguageModel(code: "kr", codeTranslator: "th", name: "เกาหลี", use: false),
    LanguageModel(code: "lo", codeTranslator: "lo", name: "ลาว", use: true),
    LanguageModel(
        code: "mr", codeTranslator: "th", name: "เมียนม่า", use: false),
    LanguageModel(
        code: "my", codeTranslator: "th", name: "มาเลเซีย", use: false),
    LanguageModel(
        code: "vi", codeTranslator: "th", name: "เวียดนาม", use: false),
    LanguageModel(code: "km", codeTranslator: "th", name: "เขมร", use: false),
  ];
  publicColors = [
    PublicColorModel()
      ..code = "white"
      ..names = [
        PublicNameModel(languageCode: "th", name: "ขาว"),
        PublicNameModel(languageCode: "en", name: "White"),
        PublicNameModel(languageCode: "cn", name: "白色"),
        PublicNameModel(languageCode: "jp", name: "白"),
        PublicNameModel(languageCode: "kr", name: "하얀색"),
        PublicNameModel(languageCode: "lo", name: "ຊາຍ"),
        PublicNameModel(languageCode: "mr", name: "အဖြူ"),
        PublicNameModel(languageCode: "my", name: "Putih"),
        PublicNameModel(languageCode: "vi", name: "Trắng"),
        PublicNameModel(languageCode: "km", name: "ស"),
      ]
      ..color = "#FFFFFF",
    PublicColorModel()
      ..code = "black"
      ..names = [
        PublicNameModel(languageCode: "th", name: "ดำ"),
        PublicNameModel(languageCode: "en", name: "Black"),
        PublicNameModel(languageCode: "cn", name: "黑色"),
        PublicNameModel(languageCode: "jp", name: "黒"),
        PublicNameModel(languageCode: "kr", name: "검은색"),
        PublicNameModel(languageCode: "lo", name: "ດັງ"),
        PublicNameModel(languageCode: "mr", name: "အနောက်"),
        PublicNameModel(languageCode: "my", name: "Hitam"),
        PublicNameModel(languageCode: "vi", name: "Đen"),
        PublicNameModel(languageCode: "km", name: "ខ្មៅ"),
      ]
      ..color = "#000000",
    PublicColorModel()
      ..code = "red"
      ..names = [
        PublicNameModel(languageCode: "th", name: "แดง"),
        PublicNameModel(languageCode: "en", name: "Red"),
        PublicNameModel(languageCode: "cn", name: "红色"),
        PublicNameModel(languageCode: "jp", name: "赤"),
        PublicNameModel(languageCode: "kr", name: "빨간색"),
        PublicNameModel(languageCode: "lo", name: "ເທື່ອ"),
        PublicNameModel(languageCode: "mr", name: "အန္တရာယ်"),
        PublicNameModel(languageCode: "my", name: "Merah"),
        PublicNameModel(languageCode: "vi", name: "Đỏ"),
        PublicNameModel(languageCode: "km", name: "ក្រហម"),
      ]
      ..color = "#FF0000",
    PublicColorModel()
      ..code = "green"
      ..names = [
        PublicNameModel(languageCode: "th", name: "เขียว"),
        PublicNameModel(languageCode: "en", name: "Green"),
        PublicNameModel(languageCode: "cn", name: "绿色"),
        PublicNameModel(languageCode: "jp", name: "緑"),
        PublicNameModel(languageCode: "kr", name: "녹색"),
        PublicNameModel(languageCode: "lo", name: "ສີຂາວ"),
        PublicNameModel(languageCode: "mr", name: "အဖြူ"),
        PublicNameModel(languageCode: "my", name: "Hijau"),
        PublicNameModel(languageCode: "vi", name: "Xanh lá"),
        PublicNameModel(languageCode: "km", name: "បៃតង"),
      ]
      ..color = "#008000",
    PublicColorModel()
      ..code = "blue"
      ..names = [
        PublicNameModel(languageCode: "th", name: "น้ำเงิน"),
        PublicNameModel(languageCode: "en", name: "Blue"),
        PublicNameModel(languageCode: "cn", name: "蓝色"),
        PublicNameModel(languageCode: "jp", name: "青"),
        PublicNameModel(languageCode: "kr", name: "파란색"),
        PublicNameModel(languageCode: "lo", name: "ສີບາດ"),
        PublicNameModel(languageCode: "mr", name: "အဖြူ"),
        PublicNameModel(languageCode: "my", name: "Biru"),
        PublicNameModel(languageCode: "vi", name: "Xanh da trời"),
        PublicNameModel(languageCode: "km", name: "ខៀវ"),
      ]
      ..color = "#0000FF",
    PublicColorModel()
      ..code = "yellow"
      ..names = [
        PublicNameModel(languageCode: "th", name: "เหลือง"),
        PublicNameModel(languageCode: "en", name: "Yellow"),
        PublicNameModel(languageCode: "cn", name: "黄色"),
        PublicNameModel(languageCode: "jp", name: "黄"),
        PublicNameModel(languageCode: "kr", name: "노란색"),
        PublicNameModel(languageCode: "lo", name: "ສີເຫຼືອ"),
        PublicNameModel(languageCode: "mr", name: "အရောင်"),
        PublicNameModel(languageCode: "my", name: "Kuning"),
        PublicNameModel(languageCode: "vi", name: "Vàng"),
        PublicNameModel(languageCode: "km", name: "លឿង"),
      ]
      ..color = "#FFFF00",
    PublicColorModel()
      ..code = "orange"
      ..names = [
        PublicNameModel(languageCode: "th", name: "ส้ม"),
        PublicNameModel(languageCode: "en", name: "Orange"),
        PublicNameModel(languageCode: "cn", name: "橙色"),
        PublicNameModel(languageCode: "jp", name: "オレンジ"),
        PublicNameModel(languageCode: "kr", name: "주황색"),
        PublicNameModel(languageCode: "lo", name: "ສີເຫຼືອ"),
        PublicNameModel(languageCode: "mr", name: "အရောင်"),
        PublicNameModel(languageCode: "my", name: "Kuning"),
        PublicNameModel(languageCode: "vi", name: "Cam"),
        PublicNameModel(languageCode: "km", name: "លឿង"),
      ]
      ..color = "#FFA500",
    PublicColorModel()
      ..code = "purple"
      ..names = [
        PublicNameModel(languageCode: "th", name: "ม่วง"),
        PublicNameModel(languageCode: "en", name: "Purple"),
        PublicNameModel(languageCode: "cn", name: "紫色"),
        PublicNameModel(languageCode: "jp", name: "紫"),
        PublicNameModel(languageCode: "kr", name: "보라색"),
        PublicNameModel(languageCode: "lo", name: "ສີມາດ"),
        PublicNameModel(languageCode: "mr", name: "အမျိုးသား"),
        PublicNameModel(languageCode: "my", name: "Ungu"),
        PublicNameModel(languageCode: "vi", name: "Tím"),
        PublicNameModel(languageCode: "km", name: "ស្វាយ"),
      ]
      ..color = "#800080",
    PublicColorModel()
      ..code = "brown"
      ..names = [
        PublicNameModel(languageCode: "th", name: "น้ำตาล"),
        PublicNameModel(languageCode: "en", name: "Brown"),
        PublicNameModel(languageCode: "cn", name: "棕色"),
        PublicNameModel(languageCode: "jp", name: "茶色"),
        PublicNameModel(languageCode: "kr", name: "갈색"),
        PublicNameModel(languageCode: "lo", name: "ສີບາດ"),
        PublicNameModel(languageCode: "mr", name: "အဖြူ"),
        PublicNameModel(languageCode: "my", name: "Biru"),
        PublicNameModel(languageCode: "vi", name: "Xanh da trời"),
        PublicNameModel(languageCode: "km", name: "ខៀវ"),
      ]
      ..color = "#A52A2A",
    PublicColorModel()
      ..code = "pink"
      ..names = [
        PublicNameModel(languageCode: "th", name: "ชมพู"),
        PublicNameModel(languageCode: "en", name: "Pink"),
        PublicNameModel(languageCode: "cn", name: "粉色"),
        PublicNameModel(languageCode: "jp", name: "ピンク"),
        PublicNameModel(languageCode: "kr", name: "분홍색"),
        PublicNameModel(languageCode: "lo", name: "ສີມາດ"),
        PublicNameModel(languageCode: "mr", name: "အမျိုးသား"),
        PublicNameModel(languageCode: "my", name: "Ungu"),
        PublicNameModel(languageCode: "vi", name: "Tím"),
        PublicNameModel(languageCode: "km", name: "ស្វាយ"),
      ]
      ..color = "#FFC0CB",
    PublicColorModel()
      ..code = "gray"
      ..names = [
        PublicNameModel(languageCode: "th", name: "เทา"),
        PublicNameModel(languageCode: "en", name: "Gray"),
        PublicNameModel(languageCode: "cn", name: "灰色"),
        PublicNameModel(languageCode: "jp", name: "灰色"),
        PublicNameModel(languageCode: "kr", name: "회색"),
        PublicNameModel(languageCode: "lo", name: "ສີເຫຼືອ"),
        PublicNameModel(languageCode: "mr", name: "အရောင်"),
        PublicNameModel(languageCode: "my", name: "Kuning"),
        PublicNameModel(languageCode: "vi", name: "Vàng"),
        PublicNameModel(languageCode: "km", name: "លឿង"),
      ]
      ..color = "#808080",
  ];

  for (var i = 0; i < publicColors.length; i++) {
    for (var j = 0; j < publicColors[i].names.length; j++) {
      publicColors[i].name = "";
      if (publicColors[i].names[j].languageCode == global.systemLanguage) {
        publicColors[i].name = publicColors[i].names[j].name;
        break;
      }
    }
  }
}

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

void showSnackBar(
    BuildContext context, Icon icon, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      duration: const Duration(seconds: 1),
      content: (Row(
        children: [
          icon,
          const SizedBox(width: 10),
          Flexible(child: Text(message, overflow: TextOverflow.ellipsis)),
        ],
      ))));
}

String language(String code) {
  String result = code.trim();
  for (int i = 0; i < languageSystemData.length; i++) {
    if (languageSystemData[i].code == code) {
      result = languageSystemData[i].text;
      break;
    }
  }
  return (result.trim().isEmpty) ? code : result;
}

void languageSelect(String languageCode) {
  languageSystemData = [];
  for (int i = 0; i < languageSystemCode.length; i++) {
    for (int j = 0; j < languageSystemCode[i].langs.length; j++) {
      if (languageSystemCode[i].langs[j].code == userLanguage) {
        languageSystemData.add(LanguageSystemModel(
            code: languageSystemCode[i].code.trim(),
            text: languageSystemCode[i].langs[j].text.trim()));
      }
    }
  }
  /*global.languageSystemData.sort((a, b) {
    return a.code.compareTo(b.code);
  });*/
}
