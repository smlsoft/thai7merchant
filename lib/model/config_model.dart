import 'package:thai7merchant/model/language_model.dart';
import 'package:thai7merchant/model/price_model.dart';

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
