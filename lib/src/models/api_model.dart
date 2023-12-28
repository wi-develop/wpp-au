enum ResponseStatus { success, error }

enum ResponseType { map, list }

class ApiModel {
  Map<String, dynamic>? jsonBody;
  List? listBody;
  ResponseStatus status;
  String? errorDetail;
  int statusCode;

  ApiModel({
    this.jsonBody,
    this.errorDetail,
    this.listBody,
    required this.status,
    required this.statusCode,
  });
}
