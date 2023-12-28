import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:url_launcher/url_launcher.dart' as url_l;

import 'utils.dart';

Future<void> customWebView({
  required BuildContext context,
  required String url,
}) async {
  final theme = Theme.of(context);
  final appColor = Utils().appColor;

  try {
    await launch(
      url,
      customTabsOption: CustomTabsOption(
        toolbarColor: theme.appBarTheme.backgroundColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        animation: CustomTabsSystemAnimation.fade(),
        extraCustomTabs: const [
          'com.android.chrome',
          'org.mozilla.firefox',
          'com.microsoft.emmx',
        ],
      ),
      safariVCOption: SafariViewControllerOption(
        preferredBarTintColor: theme.appBarTheme.backgroundColor,
        preferredControlTintColor: appColor.titleColor,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    debugPrint("customLaunchURL ERROR (catch) : " + e.toString());
    await url_l.launchUrl(
      Uri.parse(url),
      mode: url_l.LaunchMode.externalApplication,
    );
  }
}

List<String>? _deepLinkCtrl(BuildContext context, String link) {
  try {
    var lSp = link.split("wipepp.com");
    if (lSp.length < 2) {
      return null;
    } else if (lSp.first != "https://www." &&
        lSp.first != "https://" &&
        lSp.first != "http://www." &&
        lSp.first != "http://" &&
        lSp.first != "wipepp://" &&
        lSp.first != "wipepp://www.") {
      return null;
    }

    String yeniPath = link.replaceAll(RegExp(r'https://www.wipepp.com'), '');
    if (yeniPath == link) {
      yeniPath = link.replaceAll(RegExp(r'https://wipepp.com'), '');
    }
    if (yeniPath == link) {
      yeniPath = link.replaceAll(RegExp(r'http://www.wipepp.com'), '');
    }
    if (yeniPath == link) {
      yeniPath = link.replaceAll(RegExp(r'http://wipepp.com'), '');
    }
    if (yeniPath == link) {
      yeniPath = link.replaceAll(RegExp(r'wipepp://wipepp.com'), '');
    }
    if (yeniPath == link) {
      yeniPath = link.replaceAll(RegExp(r'wipepp://www.wipepp.com'), '');
    }

    List<String> list = yeniPath.split("/");
    if (list.length >= 2) {
      List<String> newList = [];

      for (var i = 0; i < list.length; i++) {
        String ele = list[i];
        if (ele != "") {
          newList.add(ele);
        }
      }
      return newList;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}
