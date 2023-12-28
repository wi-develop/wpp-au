import 'dart:convert';

WpTokenModel wpTokenModelFromJson(String str) =>
    WpTokenModel.fromJson(json.decode(str));

String wpTokenModelToJson(WpTokenModel data) => json.encode(data.toJson());

class WpTokenModel {
  String wpToken;
  String wpReToken;

  WpTokenModel({
    required this.wpToken,
    required this.wpReToken,
  });

  factory WpTokenModel.fromJson(Map<String, dynamic> json) => WpTokenModel(
        wpToken: json["wp_token"],
        wpReToken: json["wp_re_token"],
      );

  Map<String, dynamic> toJson() => {
        "wp_token": wpToken,
        "wp_re_token": wpReToken,
      };
}
