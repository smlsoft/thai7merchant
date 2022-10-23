import 'package:thai7merchant/model/language_mode.dart';

class ConfigModel {
  late List<LanguageMode> languages;

  int indexLanguage(String code) {
    int index = 0;
    for (int i = 0; i < languages.length; i++) {
      if (languages[i].code == code) {
        index = i;
        break;
      }
    }
    return index;
  }

  String name(String code) {
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
