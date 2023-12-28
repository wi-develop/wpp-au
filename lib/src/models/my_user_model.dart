import 'dart:convert';

MyUserModel myUserModelFromJson(String str) =>
    MyUserModel.fromJson(json.decode(str));

class MyUserModel {
  MyUserModel({
    required this.myUserId,
    required this.myUserUsername,
    required this.myUserName,
    required this.myUserMail,
    required this.myUserImage,
    required this.myUserConfirm,
    this.myUserTicket,
    this.myUserPhoneopen,
    this.myUserCreatedat,
    this.myUserUpdatedat,
    this.myUserLang,
    this.myUserGender,
    this.myUserCountryid,
    this.myUserCountryname,
    this.myUserBirthday,
    this.myUserDeviceid,
    this.myUserTopics,
    this.myUserLastlogin,
    this.myUserBandatetime,
    this.myUserDescription,
    this.myUserFollowed,
    this.myUserFollower,
    this.myUserPremium,
    this.myUserDm,
  });

  int myUserId;
  String myUserUsername;
  String myUserName;
  String myUserMail;
  String myUserImage;
  int myUserConfirm;
  String? myUserPhoneopen;
  int? myUserTicket;
  DateTime? myUserCreatedat;
  DateTime? myUserUpdatedat;
  String? myUserLang;
  int? myUserGender;
  int? myUserCountryid;
  String? myUserCountryname;
  dynamic myUserBirthday;
  String? myUserDeviceid;
  List<String>? myUserTopics;
  DateTime? myUserLastlogin;
  DateTime? myUserBandatetime;
  String? myUserDescription;
  int? myUserFollowed;
  int? myUserFollower;
  int? myUserPremium;
  int? myUserDm;

  factory MyUserModel.fromJson(Map<String, dynamic> json) => MyUserModel(
        myUserId: json["my_user_id"],
        myUserUsername: json["my_user_username"],
        myUserName: json["my_user_name"],
        myUserMail: json["my_user_mail"],
        myUserImage: json["my_user_image"] ??
            "https://www.wipepp.com/assets/app_image/useri.jpg",
        myUserPhoneopen: json["my_user_phoneopen"],
        myUserTicket: json["my_user_ticket"],
        myUserConfirm: json["my_user_confirm"],
        myUserCreatedat: json["my_user_createdat"] == null
            ? null
            : DateTime.parse(json["my_user_createdat"]).toLocal(),
        myUserUpdatedat: json["my_user_updatedat"] == null
            ? null
            : DateTime.parse(json["my_user_updatedat"]).toLocal(),
        myUserLang: json["my_user_lang"],
        myUserGender: json["my_user_gender"],
        myUserCountryid: json["my_user_countryid"],
        myUserCountryname: json["my_user_countryname"],
        myUserBirthday: json["my_user_birthday"],
        myUserDeviceid: json["my_user_deviceid"],
        myUserTopics: json["my_user_topics"] == null
            ? []
            : List<String>.from(json["my_user_topics"].map((x) => x)),
        myUserLastlogin: json["my_user_lastlogin"] == null
            ? null
            : DateTime.parse(json["my_user_lastlogin"]).toLocal(),
        myUserBandatetime: json["my_user_bandatetime"] == null
            ? null
            : DateTime.parse(json["my_user_bandatetime"]).toLocal(),
        myUserDescription: json["my_user_description"],
        myUserFollowed: json["my_user_followed"],
        myUserFollower: json["my_user_follower"],
        myUserPremium: json["my_user_premium"],
        myUserDm: json["my_user_dm"],
      );
}
