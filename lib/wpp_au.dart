// ignore_for_file: non_constant_identifier_names

library wpp_au;

import 'dart:developer';

import 'package:flutter/material.dart';
import 'src/components/dialogs/custom_dialog.dart';
import 'src/models/my_user_model.dart';
import 'src/models/client_app_keys_model.dart';
import 'src/models/response_model.dart';
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
          topWidget: topWidget,
        );
        return value;
      }
    } catch (e) {
      debugPrint("login(catch) : $e");
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
        if (value.errorMsg.toString() ==
            '{"statusCode":401,"msg":"U_P_0","errorMessage":"","key":null}') {
          //* change password.
          return _loginAndReturnUser();
        } else if (value.errorMsg.toString() ==
            '{"statusCode":401,"msg":"U_0","errorMessage":"","key":"U_0"}') {
          //* confirm accont
          var value2 = await verifierAccontPage(
            context: _initializeContext!,
            wpTokenModel: wpTokenModel,
            langEnum: _langEnum,
            baseUrl: _clientAppKeys!.baseUrl,
          );
          if (value2 != null) {
            return value2;
          } else {
            return value;
          }
        } else if (value.errorMsg.toString() ==
            '{"statusCode":400,"msg":"jwt expired","errorMessage":"","key":null}') {
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
