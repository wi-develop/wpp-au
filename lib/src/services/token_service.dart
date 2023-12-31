import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../models/client_app_keys_model.dart';

class TokenService {
  bool isTokenExpired(String token) {
    try {
      final Map<String, dynamic> payload = Jwt.parseJwt(token);

      if (payload.containsKey("exp")) {
        final int expiryTimeInSeconds = payload["exp"];
        final DateTime expiryDate =
            DateTime.fromMillisecondsSinceEpoch(expiryTimeInSeconds * 1000);
        final DateTime now = DateTime.now();
        return now.isAfter(expiryDate);
      } else {
        return true;
      }
    } catch (e) {
      return true;
    }
  }

  String forgetPass({
    required ClientAppKeys clientAppKeys,
    required String mail,
  }) {
    var jwt = JWT({
      "mail": mail,
      "app_id": clientAppKeys.appId,
    });

    String key = clientAppKeys.appLoginKey;

    String t = jwt.sign(
      SecretKey(key),
      expiresIn: const Duration(seconds: 50),
    );
    return t;
  }

  String signup({
    required ClientAppKeys clientAppKeys,
    required String signupMail,
    required String deviceid,
  }) {
    var jwt = JWT({
      "signup_mail": signupMail,
      "app_id": clientAppKeys.appId,
      "token_deviceid": deviceid,
    });

    String key = clientAppKeys.appLoginKey;

    String t = jwt.sign(
      SecretKey(key),
      expiresIn: const Duration(seconds: 50),
    );
    return t;
  }

  String login({
    required ClientAppKeys clientAppKeys,
    required String loginMail,
    required String deviceid,
  }) {
    var jwt = JWT({
      "login_mail": loginMail,
      "app_id": clientAppKeys.appId,
      "token_deviceid": deviceid,
    });

    String key = clientAppKeys.appLoginKey;

    String t = jwt.sign(
      SecretKey(key),
      expiresIn: const Duration(seconds: 50),
    );
    return t;
  }

  String wipeppLogin({
    required ClientAppKeys clientAppKeys,
    required String token,
  }) {
    var jwt = JWT({
      "token": token,
      "app_id": clientAppKeys.appId,
    });

    String key = clientAppKeys.appLoginKey;

    String t = jwt.sign(
      SecretKey(key),
      expiresIn: const Duration(seconds: 50),
    );
    return t;
  }
}
