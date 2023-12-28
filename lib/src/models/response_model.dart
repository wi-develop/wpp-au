import 'wp_token_model.dart';

class ResponseModel<T> {
  T data;
  WpTokenModel? wpTokenModel;
  String? errorMsg;
  int? statusCode;

  ResponseModel({
    required this.data,
    this.wpTokenModel,
    this.errorMsg,
    this.statusCode,
  });
}
