import '../../wpp_au.dart';

class VerifierModel {
  bool status;
  WpTokenModel? wpTokenModel;
  MyUserModel? myUserModel;

  VerifierModel({
    required this.status,
    required this.wpTokenModel,
    required this.myUserModel,
  });
}
