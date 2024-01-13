// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:wpp_au/src/pages/login_page.dart';

import '../../wpp_au.dart';
import '../components/dialogs/custom_dialog.dart';
import '../components/forms/custom_button.dart';
import '../components/forms/text_form_field.dart';
import '../models/verifier_model.dart';
import '../repository/auth_repository.dart';
import '../utils/lang.dart';
import '../utils/utils.dart';

enum _PageType { verifier, changeMail, enterMailDemoMail }

Future<ResponseModel<VerifierModel?>?> verifierAccontPage({
  required BuildContext context,
  required WpTokenModel wpTokenModel,
  required LangEnum langEnum,
  required ClientAppKeys clientAppKeys,
  bool isDemoMail = false,
  String? userMail,
}) async {
  final _utils = Utils();
  final _lang = Lang();
  final _authRepository = AuthRepository();

  _PageType _pageType = _PageType.verifier;

  if (isDemoMail) {
    _pageType = _PageType.enterMailDemoMail;
  }

  Future<void> initMailCodeCtrl() async {
    try {
      if (isDemoMail == false) {
        var value = await _authRepository.mailCodeCtrl(
          baseUrl: clientAppKeys.baseUrl,
          wpTokenModel: wpTokenModel,
        );
        if (value.data) {
          // true
        } else {
          // false
        }
      }
    } catch (e) {
      //
    }
  }

  initMailCodeCtrl();

  final _newMail = TextEditingController();
  final _code = TextEditingController();
  final _btnCtrl = RoundedLoadingButtonController();

  String? newMailErrorText;

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

  Future<bool?> _mailCFunc({required String mail}) async {
    try {
      var value = await _authRepository.mailC(
        baseUrl: clientAppKeys.baseUrl,
        clientAppKeys: clientAppKeys,
        mail: mail.trim(),
      );
      return value;
    } catch (e) {
      return null;
    }
  }

  Future<void> _verifierFunc() async {
    String fill = _lang.getTextTR(langEnum: langEnum, key: "fill");
    String v_c_err = _lang.getTextTR(langEnum: langEnum, key: "v_c_err");

    try {
      if (_code.text.trim().length > 1) {
        var value = await _authRepository.verifierEmailAccont(
          baseUrl: clientAppKeys.baseUrl,
          wpTokenModel: wpTokenModel,
          code: _code.text.trim(),
        );
        if (value.data) {
          var valueUser = await _authRepository.getMyUser(
            baseUrl: clientAppKeys.baseUrl,
            wpTokenModel: wpTokenModel,
          );

          Navigator.pop(
            context,
            ResponseModel(
              data: VerifierModel(
                status: true,
                wpTokenModel: null,
                myUserModel: valueUser.data,
              ),
            ),
          );
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
    String changeMailSuccess =
        _lang.getTextTR(langEnum: langEnum, key: "changeMailSuccess");

    try {
      if (_newMail.text.trim().length > 1) {
        var value = await _authRepository.changeMail(
          baseUrl: clientAppKeys.baseUrl,
          wpTokenModel: wpTokenModel,
          newEmail: _newMail.text.trim(),
        );
        if (value.data) {
          setState(() {
            userMail = _newMail.text.trim();
            isDemoMail = false;
          });
          changePageType(_PageType.verifier, setState);

          customDialog(
            context,
            text: "${_newMail.text.trim()} \n" + changeMailSuccess,
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
    String mail = _lang.getTextTR(langEnum: langEnum, key: "mail");
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
        if (userMail != null && !isDemoMail) SizedBox(height: 8),
        if (userMail != null && !isDemoMail)
          Text(
            _utils.stringOneUpper(mail) + ": $userMail",
            style: TextStyle(
              fontSize: 16.6,
              fontWeight: FontWeight.w500,
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
                baseUrl: clientAppKeys.baseUrl,
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

  Widget _enterEmailWidgets(setState) {
    String demoUserEnterMail =
        _lang.getTextTR(langEnum: langEnum, key: "demoUserEnterMail");
    String email = _lang.getTextTR(langEnum: langEnum, key: "email");
    String next = _lang.getTextTR(langEnum: langEnum, key: "next");
    String dUserW1 = _lang.getTextTR(langEnum: langEnum, key: "dUserW1");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          demoUserEnterMail,
          style: TextStyle(
            fontSize: 16.8,
          ),
        ),
        SizedBox(height: 30.0),
        textFormField(
          context,
          controller: _newMail,
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          textInputAction: TextInputAction.done,
          hintText: "$email...",
          labelText: "$email",
          errorText: newMailErrorText,
          onFieldSubmitted: (p0) {
            if (_utils.isValidEmail(_newMail.text.trim())) {
              if (newMailErrorText != null) {
                setState(() {
                  newMailErrorText = null;
                });
              }
            } else {
              setState(() {
                newMailErrorText = email;
              });
            }
          },
        ),
        SizedBox(height: 25),
        CustomButton(
          controller: _btnCtrl,
          text: _utils.stringOneUpper(next),
          onPressed: () async {
            if (_utils.isValidEmail(_newMail.text.trim())) {
              setState(() {
                newMailErrorText = null;
              });

              bool? ctrlM = await _mailCFunc(mail: _newMail.text.trim());
              if (ctrlM == true) {
                var newWpTokenModel = await loginPage(
                  langEnum: langEnum,
                  context: context,
                  clientAppKeys: clientAppKeys,
                  infoText: "${_newMail.text.trim()} : $dUserW1",
                  redirectEnterPassPage: true,
                  mail: _newMail.text.trim(),
                );
                if (newWpTokenModel != null) {
                  var valueUser = await _authRepository.getMyUser(
                    wpTokenModel: newWpTokenModel,
                    baseUrl: clientAppKeys.baseUrl,
                  );

                  Navigator.pop(
                    context,
                    ResponseModel(
                      data: VerifierModel(
                        status: true,
                        wpTokenModel: newWpTokenModel,
                        myUserModel: valueUser.data,
                      ),
                    ),
                  );
                } else {
                  Navigator.pop(
                    context,
                    ResponseModel(
                      data: VerifierModel(
                        status: false,
                        wpTokenModel: null,
                        myUserModel: null,
                      ),
                    ),
                  );
                }
              } else {
                await _changeEmailFunc(setState);
              }
            } else {
              setState(() {
                newMailErrorText = email;
              });
              _btnCtrl.reset();
            }
          },
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
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            children: [
                              SizedBox(height: 8),
                              if (_pageType == _PageType.verifier)
                                _verifierWidgets(setState),
                              if (_pageType == _PageType.changeMail)
                                _changeEmailWidgets(setState),
                              if (_pageType == _PageType.enterMailDemoMail)
                                _enterEmailWidgets(setState),
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
