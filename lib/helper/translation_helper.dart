import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TranslationsHelper {
  TranslationsHelper._();

  static getDeviceLanguage(BuildContext context) {
    var device = context.deviceLocale.languageCode;
    switch (device) {
      case "az":
        return LocaleType.az;  
      default:
        return LocaleType.en;
    }
  }
}
