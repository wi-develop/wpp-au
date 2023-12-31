import 'enums.dart';
import 'langs/ar.dart';
import 'langs/de.dart';
import 'langs/en.dart';
import 'langs/fa.dart';
import 'langs/fr.dart';
import 'langs/hi.dart';
import 'langs/pt.dart';
import 'langs/ru.dart';
import 'langs/tr.dart';
import 'langs/zh.dart';

class Lang {
  String getTextTR({
    LangEnum langEnum = LangEnum.en,
    required String key,
  }) {
    try {
      var m1 = _tMaps[langEnum];
      if (m1 != null) {
        var t1 = m1[key];
        if (t1 != null) {
          return t1.toString();
        } else {
          return "_";
        }
      } else {
        var m1En = _tMaps[LangEnum.en];
        var t1 = m1En![key];
        if (t1 != null) {
          return t1.toString();
        } else {
          return "_";
        }
      }
    } catch (e) {
      return "-";
    }
  }

  Map<LangEnum, Map<String, String>> _tMaps = {
    LangEnum.ar: ar(),
    LangEnum.de: de(),
    LangEnum.en: en(),
    LangEnum.fa: fa(),
    LangEnum.fr: fr(),
    LangEnum.hi: hi(),
    LangEnum.pt: pt(),
    LangEnum.ru: ru(),
    LangEnum.tr: tr(),
    LangEnum.zh: zh(),
  };
}
