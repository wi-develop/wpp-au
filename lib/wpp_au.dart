// ignore_for_file: non_constant_identifier_names

library wpp_au;

import 'dart:developer';

import 'package:flutter/material.dart';
import 'src/components/dialogs/custom_dialog.dart';
import 'src/models/my_user_model.dart';
import 'src/models/client_app_keys_model.dart';
import 'src/models/response_model.dart';
import 'src/models/verifier_model.dart';
import 'src/models/wp_token_model.dart';
import 'src/pages/login_page.dart';
import 'src/pages/verifier_accont_page.dart';
import 'src/repository/auth_repository.dart';
import 'src/utils/enums.dart';
import 'src/utils/lang.dart';

export 'src/utils/enums.dart';
export 'src/models/client_app_keys_model.dart';
export 'src/models/wp_token_model.dart';
export 'src/models/response_model.dart';
export 'src/models/my_user_model.dart';

class WipeppAuth {
  final authRepository = AuthRepository();
  BuildContext? _initializeContext;
  LangEnum _langEnum = LangEnum.en;
  ClientAppKeys? _clientAppKeys;
  final _lang = Lang();

  initialize(
    BuildContext context, {
    required ClientAppKeys clientAppKeys,
    LangEnum? langEnum,
  }) {
    _initializeContext = context;
    if (langEnum != null) {
      _langEnum = langEnum;
    }
    _clientAppKeys = clientAppKeys;
  }

  Future<WpTokenModel?> login({Widget? topWidget}) async {
    try {
      if (_initializeContext == null || _clientAppKeys == null) {
        log(
          "initialize ERROR.",
          error: "initialize ERROR.",
          stackTrace: StackTrace.current,
        );
        return null;
      } else {
        var value = await loginPage(
          context: _initializeContext!,
          clientAppKeys: _clientAppKeys!,
          langEnum: _langEnum,
        );
        return value;
      }
    } catch (e) {
      debugPrint("login(catch) : $e");
      return null;
    }
  }

  Future<VerifierModel?> verifierAccont({
    required WpTokenModel wpTokenModel,
    bool isDemoMail = false,
    String? userMail,
  }) async {
    try {
      if (_initializeContext == null || _clientAppKeys == null) {
        log(
          "initialize ERROR.",
          error: "initialize ERROR.",
          stackTrace: StackTrace.current,
        );
        return null;
      } else {
        ResponseModel<VerifierModel?>? value = await verifierAccontPage(
          context: _initializeContext!,
          wpTokenModel: wpTokenModel,
          langEnum: _langEnum,
          isDemoMail: isDemoMail,
          userMail: userMail,
          clientAppKeys: _clientAppKeys!,
        );
        if (value != null) {
          return value.data;
        } else {
          return null;
        }
      }
    } catch (e) {
      debugPrint("verifierAccont(catch) : $e");
      return null;
    }
  }

  Future<ResponseModel<MyUserModel?>> _loginAndReturnUser() async {
    try {
      if (_initializeContext == null || _clientAppKeys == null) {
        log(
          "initialize ERROR.",
          error: "initialize ERROR.",
          stackTrace: StackTrace.current,
        );
        return ResponseModel(
          data: null,
          errorMsg: "initialize ERROR.",
        );
      } else {
        String loginAgain =
            _lang.getTextTR(langEnum: _langEnum, key: "login_again_c_pass");

        customDialog(
          _initializeContext!,
          text: loginAgain,
        );

        var newWpTokenModel = await loginPage(
          context: _initializeContext!,
          clientAppKeys: _clientAppKeys!,
          langEnum: _langEnum,
        );
        if (newWpTokenModel != null) {
          var valueUser = await authRepository.getMyUser(
            wpTokenModel: newWpTokenModel,
            baseUrl: _clientAppKeys!.baseUrl,
          );

          return valueUser;
        } else {
          return ResponseModel(data: null);
        }
      }
    } catch (e) {
      return ResponseModel(data: null);
    }
  }

  Future<WpTokenModel?> wipeppLogin({
    required String token,
  }) async {
    try {
      if (_initializeContext == null || _clientAppKeys == null) {
        log(
          "initialize ERROR.",
          error: "initialize ERROR.",
          stackTrace: StackTrace.current,
        );
        return null;
      } else {
        String wpTokenError =
            _lang.getTextTR(langEnum: _langEnum, key: "wp_token_error");

        var value = await authRepository.wipeppLogin(
          clientAppKeys: _clientAppKeys!,
          token: token,
          baseUrl: _clientAppKeys!.baseUrl,
        );
        if (value.errorMsg != null) {
          customDialog(
            _initializeContext!,
            text: wpTokenError,
          );
          return value.data;
        } else {
          return value.data;
        }
      }
    } catch (e) {
      return null;
    }
  }

  Future<ResponseModel<MyUserModel?>> getMyUser({
    required WpTokenModel wpTokenModel,
  }) async {
    try {
      var value = await authRepository.getMyUser(
        wpTokenModel: wpTokenModel,
        baseUrl: _clientAppKeys!.baseUrl,
      );

      if (value.data == null && _initializeContext != null) {
        String errorKey = "";
        String? userMail;

        try {
          var arr1 = value.errorMsg
              .toString()
              .replaceAll('"', "")
              .replaceAll('{', "")
              .replaceAll('}', "")
              .split(",");

          for (var i = 0; i < arr1.length; i++) {
            var element = arr1[i].trim();
            var arr2 = element.split(":");

            if (arr2.length == 2 && arr2[0] == "key") {
              errorKey = arr2[1].trim();
            }

            if (arr2.length == 2 && arr2[0] == "errorMessage") {
              String yy1 = arr2[1].trim();
              var arrMail = yy1.split("@");
              if (arrMail.length == 2) {
                userMail = yy1.trim();
              }
            }
          }
        } catch (e) {
          //
        }

        if (errorKey == "U_P_0") {
          //* change password.
          return _loginAndReturnUser();
        } else if (errorKey == "U_0" || errorKey == "U_0_demo") {
          //* confirm accont
          var value2 = await verifierAccontPage(
            context: _initializeContext!,
            wpTokenModel: wpTokenModel,
            langEnum: _langEnum,
            clientAppKeys: _clientAppKeys!,
            isDemoMail: errorKey == "U_0_demo" ? true : false,
            userMail: errorKey == "U_0_demo" ? null : userMail,
          );
          if (value2 != null) {
            return ResponseModel(
              data: value2.data?.myUserModel,
            );
          } else {
            return value;
          }
        } else if (errorKey == "null") {
          var valueUser2 = await authRepository.getMyUser(
            wpTokenModel: wpTokenModel,
            baseUrl: _clientAppKeys!.baseUrl,
          );

          return valueUser2;
        } else {
          return value;
        }
      } else if (_initializeContext == null) {
        log(
          "initialize ERROR.",
          error: "initialize ERROR.",
          stackTrace: StackTrace.current,
        );
        return ResponseModel(
          data: null,
          errorMsg: "initialize ERROR.",
        );
      } else {
        return value;
      }
    } catch (e) {
      return ResponseModel(
        data: null,
      );
    }
  }

  Future<ResponseModel<WpTokenModel?>> reWpToken({
    required WpTokenModel wpTokenModel,
  }) async {
    try {
      var value = await authRepository.getReToken(
        wpTokenModel: wpTokenModel,
        baseUrl: _clientAppKeys!.baseUrl,
      );
      return value;
    } catch (e) {
      return ResponseModel(
        data: null,
      );
    }
  }
}
