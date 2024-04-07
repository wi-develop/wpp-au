import 'wp_token_model.dart';

class ResponseModel<T> {
  T data;
  WpTokenModel? wpTokenModel;
  String? errorMsg;
  int? statusCode;
  VerifierRequiredModel? verifierRequiredModel;

  ResponseModel({
    required this.data,
    this.wpTokenModel,
    this.errorMsg,
    this.statusCode,
    this.verifierRequiredModel,
  });
}

class VerifierRequiredModel {
  String errorKey;
  String? email;
  bool isDemoMail;

  VerifierRequiredModel({
    required this.errorKey,
    this.email,
    this.isDemoMail = false,
  });
}
