// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../wpp_au.dart';
import '../components/dialogs/custom_dialog.dart';
import '../components/forms/custom_button.dart';
import '../components/forms/text_form_field.dart';
import '../repository/auth_repository.dart';
import '../utils/lang.dart';
import '../utils/utils.dart';

enum _PageType { verifier, changeMail }

Future<ResponseModel<MyUserModel?>?> verifierAccontPage({
  required BuildContext context,
  required WpTokenModel wpTokenModel,
  required LangEnum langEnum,
  required String baseUrl,
}) async {
  final _utils = Utils();
  final _lang = Lang();
  final _authRepository = AuthRepository();

  _PageType _pageType = _PageType.verifier;

  final _newMail = TextEditingController();
  final _code = TextEditingController();
  final _btnCtrl = RoundedLoadingButtonController();

  String verify_acc = _lang.getTextTR(langEnum: langEnum, key: "verify_acc");
  String change_email_B1 =
      _lang.getTextTR(langEnum: langEnum, key: "change_email_B1");

  void changePageType(_PageType pageType, setState) {
    if (context.mounted) {
      setState(() {
        _pageType = pageType;
      });
    }
  }

  Future<void> _verifierFunc() async {
    String fill = _lang.getTextTR(langEnum: langEnum, key: "fill");
    String v_c_err = _lang.getTextTR(langEnum: langEnum, key: "v_c_err");

    try {
      if (_code.text.trim().length > 1) {
        var value = await _authRepository.verifierEmailAccont(
          baseUrl: baseUrl,
          wpTokenModel: wpTokenModel,
          code: _code.text.trim(),
        );
        if (value.data) {
          var valueUser = await _authRepository.getMyUser(
            baseUrl: baseUrl,
            wpTokenModel: wpTokenModel,
          );

          Navigator.pop(context, valueUser);
        } else {
          _btnCtrl.reset();
          if (context.mounted) {
            customDialog(
              context,
              text: v_c_err,
            );
          }
        }
      } else {
        _btnCtrl.reset();
        if (context.mounted) {
          customDialog(
            context,
            text: fill,
          );
        }
      }
    } catch (e) {
      customDialog(
        context,
        text: "OPPS! Try again.",
      );
    }
  }

  Future<void> _changeEmailFunc(setState) async {
    String fill = _lang.getTextTR(langEnum: langEnum, key: "fill");
    String verifier_T1 =
        _lang.getTextTR(langEnum: langEnum, key: "verifier_T1");

    try {
      if (_newMail.text.trim().length > 1) {
        var value = await _authRepository.changeMail(
          baseUrl: baseUrl,
          wpTokenModel: wpTokenModel,
          newEmail: _newMail.text.trim(),
        );
        if (value.data) {
          changePageType(_PageType.verifier, setState);
          customDialog(
            context,
            text: "${_newMail.text.trim()} \n" + verifier_T1,
          );
          _newMail.clear();
        } else {
          _btnCtrl.reset();
          if (context.mounted) {
            customDialog(
              context,
              text: "Try Again.",
            );
          }
        }
      } else {
        _btnCtrl.reset();
        if (context.mounted) {
          customDialog(
            context,
            text: fill,
          );
        }
      }
    } catch (e) {
      customDialog(
        context,
        text: "OPPS! Try again.",
      );
    }
  }

  Widget _verifierWidgets(setState) {
    String send = _lang.getTextTR(langEnum: langEnum, key: "send");
    String verifier_T1 =
        _lang.getTextTR(langEnum: langEnum, key: "verifier_T1");
    String verifier_B1 =
        _lang.getTextTR(langEnum: langEnum, key: "verifier_B1");
    String change_email_T1 =
        _lang.getTextTR(langEnum: langEnum, key: "change_email_T1");
    String verifier_code =
        _lang.getTextTR(langEnum: langEnum, key: "verifier_code");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          verifier_T1,
          style: TextStyle(
            fontSize: 16.6,
          ),
        ),
        SizedBox(height: 25),
        textFormField(
          context,
          controller: _code,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          hintText: "$verifier_code...",
          labelText: "$verifier_code",
        ),
        SizedBox(height: 25),
        CustomButton(
          controller: _btnCtrl,
          text: _utils.stringOneUpper(send),
          onPressed: () async => await _verifierFunc(),
        ),
        SizedBox(height: 25),
        InkWell(
          onTap: () async {
            String again_code =
                _lang.getTextTR(langEnum: langEnum, key: "again_code");
            String err_again_code_limit = _lang.getTextTR(
                langEnum: langEnum, key: "err_again_code_limit");

            try {
              customDialog(
                context,
                text: again_code,
              );

              var value = await _authRepository.againVerifierCode(
                wpTokenModel: wpTokenModel,
                baseUrl: baseUrl,
              );
              if (!value.data && context.mounted) {
                if (value.errorMsg.toString() ==
                    '{"statusCode":400,"msg":"E_397_6005","errorMessage":"limit","key":null}') {
                  customDialog(
                    context,
                    text: err_again_code_limit,
                  );
                } else {
                  customDialog(
                    context,
                    text: "Try Again.",
                  );
                }
              }
            } catch (e) {
              customDialog(
                context,
                text: "OPPS! Try again.",
              );
            }
          },
          child: Center(
            child: Text(
              verifier_B1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(height: 25),
        InkWell(
          onTap: () {
            changePageType(_PageType.changeMail, setState);
          },
          child: Center(
            child: Text(
              change_email_T1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.6,
                color: Colors.orange.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _changeEmailWidgets(setState) {
    String back = _lang.getTextTR(langEnum: langEnum, key: "back");

    String enter_new_email =
        _lang.getTextTR(langEnum: langEnum, key: "enter_new_email");
    String change_email_B1 =
        _lang.getTextTR(langEnum: langEnum, key: "change_email_B1");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            changePageType(_PageType.verifier, setState);
          },
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  changePageType(_PageType.verifier, setState);
                },
                icon: Icon(
                  _utils.isDirectionRTL(context)
                      ? Icons.arrow_forward
                      : Icons.arrow_back,
                  color: _utils.appColor.titleColor,
                ),
              ),
              Flexible(
                child: Text(
                  _utils.stringOneUpper(back),
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                    color: _utils.appColor.titleColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
        textFormField(
          context,
          controller: _newMail,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          hintText: "$enter_new_email...",
          labelText: "$enter_new_email",
        ),
        SizedBox(height: 25),
        CustomButton(
          controller: _btnCtrl,
          text: _utils.stringOneUpper(change_email_B1),
          onPressed: () async => await _changeEmailFunc(setState),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: _utils.appColor.scaffoldBg,
    enableDrag: false,
    useSafeArea: true,
    builder: (context) {
      final size = MediaQuery.of(context).size;

      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: size.height,
          minWidth: size.width,
          maxHeight: size.height,
          maxWidth: size.width,
        ),
        child: Theme(
          data: ThemeData(
            fontFamily: "jost",
            useMaterial3: true,
            primarySwatch: Colors.blue,
          ),
          child: SafeArea(
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: size.width,
                        padding: EdgeInsets.all(20),
                        color: _utils.appColor.scaffoldBg,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.close,
                              size: 26,
                              color: _utils.appColor.titleColor,
                            ),
                            SizedBox(width: 8.0),
                            Flexible(
                              child: Text(
                                (_pageType == _PageType.verifier)
                                    ? verify_acc.toUpperCase()
                                    : (_pageType == _PageType.changeMail)
                                        ? change_email_B1.toUpperCase()
                                        : "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(0.0), //! 8.0
                        decoration: BoxDecoration(
                          color: _utils.appColor.scaffoldBg,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: _utils.appColor.containerColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: ListView(
                            children: [
                              SizedBox(height: 8),
                              if (_pageType == _PageType.verifier)
                                _verifierWidgets(setState),
                              if (_pageType == _PageType.changeMail)
                                _changeEmailWidgets(setState),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    },
  );
}
