import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:platform_device_id/platform_device_id.dart';

import '../models/app_color_model.dart';

class Utils {
  AppColor get appColor => _appColor;
  Future<String> get getDeviceId async => await _getDeviceId();

  AppColor _appColor = AppColor(
    scaffoldBg: Colors.grey.shade100,
    containerColor: Colors.white,
    titleColor: Colors.black87,
    subTitleColor: Colors.black54,
    alertColor: Colors.red,
    buttonColor: Colors.blue,
  );

  Future<String> _getDeviceId() async {
    try {
      String? deviceId = await PlatformDeviceId.getDeviceId;
      return deviceId.toString();
    } catch (e) {
      return "null";
    }
  }

  bool isDirectionRTL(BuildContext context) {
    return intl.Bidi.isRtlLanguage(
        Localizations.localeOf(context).languageCode);
  }

  bool isTablet(BuildContext context) {
    int width = MediaQuery.of(context).size.width.toInt();
    return (width > 550) ? true : false;
  }

  String stringOneUpper(String str) {
    try {
      var strList = str.split(" ");
      String newStr = "";
      for (var i = 0; i < strList.length; i++) {
        var k = strList[i].trim();
        k = _getCapitalizeString(k);

        if (newStr == "") {
          newStr = k;
        } else {
          newStr = newStr + " " + k;
        }
      }
      return newStr;
    } catch (e) {
      return str;
    }
  }

  String _getCapitalizeString(String str) {
    try {
      if (str.length <= 1) {
        return str.toUpperCase();
      }
      return '${str[0].toUpperCase()}${str.substring(1)}';
    } catch (e) {
      return str;
    }
  }
}
