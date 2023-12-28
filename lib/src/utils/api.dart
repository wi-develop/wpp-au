import 'dart:convert';
import '../models/api_model.dart';
import 'package:http/http.dart' as http;

class Api {
  Future<ApiModel> post({
    required String baseUrl,
    required String url,
    required String token,
    required Map<String, dynamic> body,
    ResponseType responseType = ResponseType.map,
  }) async {
    try {
      Uri uri = Uri.parse(baseUrl + url);
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };
      var _body = json.encode(body);
      var res = await http.post(uri, headers: headers, body: _body);

      if (res.body == '{"msg":"jwt expired"}') {
        throw "jwt expired";
      }

      Map<String, dynamic>? resBodyMap;
      List? resBodyList;

      switch (responseType) {
        case ResponseType.map:
          resBodyMap = json.decode(res.body) as Map<String, dynamic>;
          break;
        case ResponseType.list:
          resBodyList = json.decode(res.body) as List;
          break;
      }

      if (res.statusCode == 200) {
        return ApiModel(
          status: ResponseStatus.success,
          jsonBody: resBodyMap,
          listBody: resBodyList,
          statusCode: res.statusCode,
        );
      } else {
        return ApiModel(
          status: ResponseStatus.error,
          jsonBody: resBodyMap,
          listBody: resBodyList,
          statusCode: res.statusCode,
          errorDetail: res.body,
        );
      }
    } catch (e) {
      return ApiModel(
        status: ResponseStatus.error,
        jsonBody: {"error": e.toString()},
        listBody: [
          {"error": e.toString()}
        ],
        statusCode: 501,
        errorDetail: "$e",
      );
    }
  }

  Future<ApiModel> get({
    required String baseUrl,
    required String url,
    required String token,
    ResponseType responseType = ResponseType.map,
  }) async {
    try {
      Uri uri = Uri.parse(baseUrl + url);
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };
      var res = await http.get(uri, headers: headers);

      Map<String, dynamic>? resBodyMap;
      List? resBodyList;

      if (res.statusCode == 200) {
        switch (responseType) {
          case ResponseType.map:
            resBodyMap = jsonDecode(res.body) as Map<String, dynamic>;
            break;
          case ResponseType.list:
            resBodyList = jsonDecode(res.body) as List;
            break;
        }

        return ApiModel(
          status: ResponseStatus.success,
          jsonBody: resBodyMap,
          listBody: resBodyList,
          statusCode: res.statusCode,
        );
      } else {
        return ApiModel(
          status: ResponseStatus.error,
          errorDetail: res.body,
          jsonBody: resBodyMap,
          listBody: resBodyList,
          statusCode: res.statusCode,
        );
      }
    } catch (e) {
      return ApiModel(
        errorDetail: e.toString(),
        status: ResponseStatus.error,
        jsonBody: {"error": e.toString()},
        statusCode: 501,
      );
    }
  }
}
