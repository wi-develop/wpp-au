import 'package:flutter/widgets.dart';

import '../models/api_model.dart';
import '../models/client_app_keys_model.dart';
import '../models/my_user_model.dart';
import '../models/response_model.dart';
import '../models/wp_token_model.dart';
import '../services/token_service.dart';
import '../utils/api.dart';
import '../utils/utils.dart';

class AuthRepository {
  final _api = Api();
  final _tokenService = TokenService();
  final _utils = Utils();

  Future<ResponseModel<WpTokenModel?>> wipeppLogin({
    required ClientAppKeys clientAppKeys,
    required String token,
    required String baseUrl,
  }) async {
    try {
      String deviceid = await _utils.getDeviceId;
      String t1 = _tokenService.wipeppLogin(
        clientAppKeys: clientAppKeys,
        token: token,
      );

      var res = await _api.post(
        baseUrl: baseUrl,
        url: "/a2/login/wipepp",
        token: t1,
        body: {
          "deviceid": deviceid,
        },
      );

      if (res.status == ResponseStatus.success) {
        var wpTokenModel = WpTokenModel.fromJson(res.jsonBody!);
        return ResponseModel(
          data: wpTokenModel,
        );
      } else {
        return ResponseModel(
          data: null,
          errorMsg: res.errorDetail,
        );
      }
    } catch (e) {
      return ResponseModel(
        data: null,
        errorMsg: e.toString(),
      );
    }
  }

  Future<ResponseModel<WpTokenModel?>> login({
    required ClientAppKeys clientAppKeys,
    required String loginMail,
    required String loginPass,
    required String baseUrl,
    String? lang,
  }) async {
    try {
      String deviceid = await _utils.getDeviceId;
      String token = _tokenService.login(
        clientAppKeys: clientAppKeys,
        loginMail: loginMail,
        deviceid: deviceid,
      );

      var res = await _api.post(
        baseUrl: baseUrl,
        url: "/a2/login",
        token: token,
        body: {
          "login_pass": loginPass,
          "deviceid": deviceid,
          "lang": lang ?? _utils.getLang,
        },
      );

      if (res.status == ResponseStatus.success) {
        var wpTokenModel = WpTokenModel.fromJson(res.jsonBody!);
        return ResponseModel(
          data: wpTokenModel,
        );
      } else {
        return ResponseModel(
          data: null,
          errorMsg: res.errorDetail,
        );
      }
    } catch (e) {
      return ResponseModel(
        data: null,
        errorMsg: e.toString(),
      );
    }
  }

  Future<bool?> mailC({
    required ClientAppKeys clientAppKeys,
    required String mail,
    required String baseUrl,
  }) async {
    try {
      String deviceid = await _utils.getDeviceId;
      String token = _tokenService.login(
        clientAppKeys: clientAppKeys,
        loginMail: mail,
        deviceid: deviceid,
      );

      var res = await _api.post(
        baseUrl: baseUrl,
        url: "/a2/mailC",
        token: token,
        body: {
          "deviceid": deviceid,
        },
      );

      if (res.status == ResponseStatus.success) {
        var c1 = res.jsonBody!["ctrl"];
        if (c1 == true) {
          return true;
        } else {
          return false;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<ResponseModel<WpTokenModel?>> signup({
    required ClientAppKeys clientAppKeys,
    required String signupMail,
    required String signupPass,
    required String signupName,
    required DateTime signupYear,
    required String baseUrl,
    String? lang,
  }) async {
    try {
      String deviceid = await _utils.getDeviceId;

      String birthdayString =
          "${signupYear.year}-${signupYear.month}-${signupYear.day} 00:00:00";

      String token = _tokenService.signup(
        clientAppKeys: clientAppKeys,
        signupMail: signupMail,
        deviceid: deviceid,
      );

      var res = await _api.post(
        baseUrl: baseUrl,
        url: "/a2/signup",
        token: token,
        body: {
          "deviceid": deviceid,
          "signup_name": signupName,
          "signup_year": birthdayString,
          "signup_pass": signupPass,
          "lang": lang ?? _utils.getLang,
        },
      );

      if (res.status == ResponseStatus.success) {
        var wpTokenModel = WpTokenModel.fromJson(res.jsonBody!);
        return ResponseModel(
          data: wpTokenModel,
        );
      } else {
        return ResponseModel(
          data: null,
          errorMsg: res.errorDetail,
        );
      }
    } catch (e) {
      return ResponseModel(
        data: null,
        errorMsg: e.toString(),
      );
    }
  }

  Future<ResponseModel<bool>> forgetPass({
    required ClientAppKeys clientAppKeys,
    required String mail,
    required String baseUrl,
  }) async {
    try {
      String deviceid = await _utils.getDeviceId;

      String token = _tokenService.forgetPass(
        mail: mail,
        clientAppKeys: clientAppKeys,
      );

      var res = await _api.post(
        baseUrl: baseUrl,
        url: "/a2/forgetPass",
        token: token,
        body: {
          "deviceid": deviceid,
        },
      );

      if (res.status == ResponseStatus.success) {
        return ResponseModel(
          data: true,
        );
      } else {
        return ResponseModel(
          data: false,
          errorMsg: res.errorDetail,
        );
      }
    } catch (e) {
      return ResponseModel(
        data: false,
        errorMsg: e.toString(),
      );
    }
  }

  Future<ResponseModel<WpTokenModel?>> getReToken({
    required WpTokenModel wpTokenModel,
    required String baseUrl,
  }) async {
    try {
      String deviceid = await _utils.getDeviceId;
      ApiModel res = await _api.post(
        baseUrl: baseUrl,
        url: "/a2/getReToken",
        token: wpTokenModel.wpReToken,
        body: {
          "deviceid": deviceid,
        },
      );
      if (res.status == ResponseStatus.success) {
        var _wpTokenModel = WpTokenModel.fromJson(res.jsonBody!);
        return ResponseModel(
          data: _wpTokenModel,
        );
      } else {
        return ResponseModel(
          data: null,
          errorMsg: res.errorDetail,
        );
      }
    } catch (e) {
      return ResponseModel(
        data: null,
        errorMsg: e.toString(),
      );
    }
  }

  Future<WpTokenModel> _tokenExpCtrl({
    required WpTokenModel wpTokenModel,
    required String baseUrl,
  }) async {
    try {
      bool isExp = _tokenService.isTokenExpired(wpTokenModel.wpToken);
      if (isExp) {
        var value =
            await getReToken(wpTokenModel: wpTokenModel, baseUrl: baseUrl);
        if (value.data != null) {
          return value.data!;
        } else {
          return wpTokenModel;
        }
      } else {
        return wpTokenModel;
      }
    } catch (e) {
      return wpTokenModel;
    }
  }

  Future<ResponseModel<MyUserModel?>> getMyUser({
    required WpTokenModel wpTokenModel,
    required String baseUrl,
  }) async {
    try {
      String deviceid = await _utils.getDeviceId;
      var newWpTokenModel = await _tokenExpCtrl(
        wpTokenModel: wpTokenModel,
        baseUrl: baseUrl,
      );
      ApiModel res = await _api.post(
        baseUrl: baseUrl,
        url: "/user/getMe",
        token: newWpTokenModel.wpToken,
        body: {
          "deviceid": deviceid,
        },
      );
      if (res.status == ResponseStatus.success) {
        return ResponseModel(
          data: MyUserModel.fromJson(res.jsonBody!),
          wpTokenModel: newWpTokenModel,
          errorMsg: res.errorDetail,
        );
      } else {
        return ResponseModel(
          data: null,
          errorMsg: res.errorDetail,
          wpTokenModel: newWpTokenModel,
        );
      }
    } catch (e) {
      return ResponseModel(
        data: null,
        errorMsg: e.toString(),
      );
    }
  }

  Future<ResponseModel<bool>> verifierEmailAccont({
    required WpTokenModel wpTokenModel,
    required String code,
    required String baseUrl,
  }) async {
    try {
      String deviceid = await _utils.getDeviceId;
      var newWpTokenModel =
          await _tokenExpCtrl(wpTokenModel: wpTokenModel, baseUrl: baseUrl);
      ApiModel res = await _api.post(
        baseUrl: baseUrl,
        url: "/a2/verifierEmailAccont",
        token: newWpTokenModel.wpToken,
        body: {
          "deviceid": deviceid,
          "code": code,
        },
      );
      if (res.status == ResponseStatus.success) {
        return ResponseModel(
          data: true,
          wpTokenModel: newWpTokenModel,
        );
      } else {
        return ResponseModel(
          data: false,
          errorMsg: res.errorDetail,
          wpTokenModel: newWpTokenModel,
        );
      }
    } catch (e) {
      return ResponseModel(
        data: false,
        errorMsg: e.toString(),
      );
    }
  }

  Future<ResponseModel<bool>> mailCodeCtrl({
    required WpTokenModel wpTokenModel,
    required String baseUrl,
  }) async {
    try {
      var newWpTokenModel = await _tokenExpCtrl(
        wpTokenModel: wpTokenModel,
        baseUrl: baseUrl,
      );
      ApiModel res = await _api.post(
        baseUrl: baseUrl,
        url: "/a2/mailCodeCtrl",
        token: newWpTokenModel.wpToken,
        body: {},
      );
      if (res.status == ResponseStatus.success) {
        return ResponseModel(
          data: true,
          wpTokenModel: newWpTokenModel,
        );
      } else {
        return ResponseModel(
          data: false,
          errorMsg: res.errorDetail,
          wpTokenModel: newWpTokenModel,
        );
      }
    } catch (e) {
      return ResponseModel(
        data: false,
        errorMsg: e.toString(),
      );
    }
  }

  Future<ResponseModel<bool>> changeMail({
    required String baseUrl,
    required WpTokenModel wpTokenModel,
    required String newEmail,
  }) async {
    try {
      String deviceid = await _utils.getDeviceId;
      var newWpTokenModel = await _tokenExpCtrl(
        wpTokenModel: wpTokenModel,
        baseUrl: baseUrl,
      );
      ApiModel res = await _api.post(
        baseUrl: baseUrl,
        url: "/a2/changeMail",
        token: newWpTokenModel.wpToken,
        body: {
          "deviceid": deviceid,
          "newMail": newEmail,
        },
      );
      if (res.status == ResponseStatus.success) {
        return ResponseModel(
          data: true,
          wpTokenModel: newWpTokenModel,
        );
      } else {
        return ResponseModel(
          data: false,
          errorMsg: res.errorDetail,
          wpTokenModel: newWpTokenModel,
        );
      }
    } catch (e) {
      return ResponseModel(
        data: false,
        errorMsg: e.toString(),
      );
    }
  }

  Future<ResponseModel<bool>> againVerifierCode({
    required WpTokenModel wpTokenModel,
    required String baseUrl,
  }) async {
    try {
      String deviceid = await _utils.getDeviceId;
      var newWpTokenModel = await _tokenExpCtrl(
        wpTokenModel: wpTokenModel,
        baseUrl: baseUrl,
      );
      ApiModel res = await _api.post(
        baseUrl: baseUrl,
        url: "/a2/againVerifierCode",
        token: newWpTokenModel.wpToken,
        body: {
          "deviceid": deviceid,
        },
      );
      if (res.status == ResponseStatus.success) {
        return ResponseModel(
          data: true,
          wpTokenModel: newWpTokenModel,
        );
      } else {
        return ResponseModel(
          data: false,
          errorMsg: res.errorDetail,
          wpTokenModel: newWpTokenModel,
        );
      }
    } catch (e) {
      return ResponseModel(
        data: false,
        errorMsg: e.toString(),
      );
    }
  }
}
