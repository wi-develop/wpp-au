// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../wipepp_auth.dart';
import '../components/dialogs/custom_dialog.dart';
import '../components/dialogs/date_picker_dialog.dart';
import '../components/forms/custom_button.dart';
import '../components/forms/text_form_field.dart';
import '../repository/auth_repository.dart';
import '../utils/lang.dart';
import '../utils/utils.dart';

Future<WpTokenModel?> loginPage({
  required BuildContext context,
  required ClientAppKeys clientAppKeys,
  LangEnum? langEnum,
  Widget? topWidget,
}) async {
  final _utils = Utils();
  final _lang = Lang();
  final _authRepository = AuthRepository();
  bool _isHiddenPass = true;

  LangEnum _langEnum = LangEnum.en;
  LoginType _loginType = LoginType.login;

  final _loginMail = TextEditingController();
  final _loginPass = TextEditingController();

  final _signupName = TextEditingController();
  DateTime? _signupYear;
  final _signupMail = TextEditingController();
  final _signupPass = TextEditingController();
  final _signupRePass = TextEditingController();

  final _forgetMail = TextEditingController();

  final _btnCtrl = RoundedLoadingButtonController();

  String login = _lang.getTextTR(langEnum: _langEnum, key: "login");
  String forget = _lang.getTextTR(langEnum: _langEnum, key: "forget");
  String signup = _lang.getTextTR(langEnum: _langEnum, key: "signup");

  void changeLoginType(LoginType loginType, setState) {
    if (context.mounted) {
      setState(() {
        _loginType = loginType;
      });
    }
  }

  Future<bool> _loginFunc() async {
    String fill = _lang.getTextTR(langEnum: _langEnum, key: "fill");
    String notC = _lang.getTextTR(langEnum: _langEnum, key: "not_c");

    try {
      if (_loginMail.text.trim().length > 4 &&
          _loginPass.text.trim().length > 3) {
        var value = await _authRepository.login(
          baseUrl: clientAppKeys.baseUrl,
          clientAppKeys: clientAppKeys,
          loginMail: _loginMail.text.trim(),
          loginPass: _loginPass.text,
        );
        if (value.data != null) {
          Navigator.pop(context, value.data);
          return true;
        } else {
          _btnCtrl.reset();
          if (context.mounted) {
            customDialog(
              context,
              text: notC,
            );
          }
          return false;
        }
      } else {
        _btnCtrl.reset();
        if (context.mounted) {
          customDialog(
            context,
            text: fill,
          );
        }
        return false;
      }
    } catch (e) {
      customDialog(
        context,
        text: "OPPS! Try again.",
      );
      return false;
    }
  }

  Future<bool> _signupFunc(dynamic setState) async {
    String fill = _lang.getTextTR(langEnum: _langEnum, key: "fill");
    String passReW = _lang.getTextTR(langEnum: _langEnum, key: "pass_re_w");
    String usertrue = _lang.getTextTR(langEnum: _langEnum, key: "usertrue");

    try {
      if (_signupMail.text.trim().length > 4 &&
          _signupPass.text.trim().length > 3 &&
          _signupRePass.text.trim().length > 3 &&
          _signupName.text.trim().length > 0 &&
          _signupYear != null) {
        if (_signupPass.text == _signupRePass.text) {
          var value = await _authRepository.signup(
            clientAppKeys: clientAppKeys,
            baseUrl: clientAppKeys.baseUrl,
            signupMail: _signupMail.text.trim(),
            signupPass: _signupPass.text,
            signupName: _signupName.text.trim(),
            signupYear: _signupYear!,
          );
          if (value.data != null) {
            Navigator.pop(context, value.data);
            return true;
          } else {
            _btnCtrl.reset();
            if (context.mounted) {
              if (value.errorMsg.toString() ==
                  '{"statusCode":451,"msg":"E_113","errorMessage":"error: duplicate key value violates unique constraint \\"users_mail_key\\"","key":null}'
                      .toString()) {
                setState(() {
                  _loginMail.text = _signupMail.text;
                });
                changeLoginType(
                  LoginType.login,
                  setState,
                );
                customDialog(
                  context,
                  text: usertrue,
                );
              } else {
                customDialog(
                  context,
                  text: "Try Again.",
                );
              }
            }
            return false;
          }
        } else {
          _btnCtrl.reset();
          if (context.mounted) {
            customDialog(
              context,
              text: passReW,
            );
          }
          return false;
        }
      } else {
        if (context.mounted) {
          customDialog(
            context,
            text: fill,
          );
          _btnCtrl.reset();
        }
        return false;
      }
    } catch (e) {
      _btnCtrl.reset();
      customDialog(
        context,
        text: "OPPS! Try again.",
      );
      return false;
    }
  }

  Future<void> _forgetFunc() async {
    String fill = _lang.getTextTR(langEnum: _langEnum, key: "fill");
    String forgetSuccess =
        _lang.getTextTR(langEnum: _langEnum, key: "forget_p_success");

    try {
      if (_forgetMail.text.trim().length > 4) {
        var value = await _authRepository.forgetPass(
          baseUrl: clientAppKeys.baseUrl,
          clientAppKeys: clientAppKeys,
          mail: _forgetMail.text.trim(),
        );
        if (value.data) {
          _btnCtrl.reset();
          _forgetMail.clear();
          customDialog(
            context,
            text: forgetSuccess,
          );
        } else {
          _btnCtrl.reset();
          if (context.mounted) {
            customDialog(
              context,
              text: "Try again.",
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

  Widget _loginWidgets(setState) {
    String login = _lang.getTextTR(langEnum: _langEnum, key: "login");
    String email = _lang.getTextTR(langEnum: _langEnum, key: "email");
    String pass = _lang.getTextTR(langEnum: _langEnum, key: "pass");
    String forget = _lang.getTextTR(langEnum: _langEnum, key: "forget");
    String login_have = _lang.getTextTR(langEnum: _langEnum, key: "login_have");

    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textFormField(
            context,
            controller: _loginMail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            hintText: "$email...",
            labelText: "$email",
            autofillHints: [AutofillHints.email],
          ),
          SizedBox(height: 21),
          Row(
            children: [
              Expanded(
                child: textFormField(
                  context,
                  controller: _loginPass,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  hintText: "$pass...",
                  labelText: "$pass",
                  autofillHints: [AutofillHints.password],
                  isHiddenPass: _isHiddenPass,
                ),
              ),
              IconButton(
                icon: Icon(
                  _isHiddenPass ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isHiddenPass = !_isHiddenPass;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              changeLoginType(LoginType.forget, setState);
            },
            child: Text(
              forget,
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.indigo,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
                decorationColor: Colors.indigo,
                decorationThickness: 0.6,
              ),
            ),
          ),
          SizedBox(height: 25),
          CustomButton(
            controller: _btnCtrl,
            text: _utils.stringOneUpper(login),
            onPressed: () async {
              bool status = await _loginFunc();
              if (status) {
                TextInput.finishAutofillContext();
              }
            },
          ),
          SizedBox(height: 25),
          InkWell(
            onTap: () {
              changeLoginType(LoginType.signup, setState);
            },
            child: Center(
              child: Text(
                Utils().stringOneUpper(login_have),
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _signupWidgets(setState) {
    String email = _lang.getTextTR(langEnum: _langEnum, key: "email");
    String signup = _lang.getTextTR(langEnum: _langEnum, key: "signup");
    String new_pass = _lang.getTextTR(langEnum: _langEnum, key: "new_pass");
    String re_new_pass =
        _lang.getTextTR(langEnum: _langEnum, key: "re_new_pass");
    String signup_have =
        _lang.getTextTR(langEnum: _langEnum, key: "signup_have");
    String name = _lang.getTextTR(langEnum: _langEnum, key: "name");
    String year_data = _lang.getTextTR(langEnum: _langEnum, key: "year_data");
    String year = _lang.getTextTR(langEnum: _langEnum, key: "year");
    String year_warn = _lang.getTextTR(langEnum: _langEnum, key: "year_warn");

    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textFormField(
            context,
            controller: _signupName,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            hintText: "$name...",
            labelText: "$name",
            autofillHints: [AutofillHints.name],
          ),
          SizedBox(height: 21),
          textFormField(
            context,
            controller: _signupMail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            hintText: "$email...",
            labelText: "$email",
            autofillHints: [AutofillHints.email],
          ),
          SizedBox(height: 21),
          Row(
            children: [
              Expanded(
                child: textFormField(
                  context,
                  controller: _signupPass,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  hintText: "$new_pass...",
                  labelText: "$new_pass",
                  autofillHints: [AutofillHints.newPassword],
                  isHiddenPass: _isHiddenPass,
                ),
              ),
              IconButton(
                icon: Icon(
                  _isHiddenPass ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isHiddenPass = !_isHiddenPass;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 21),
          Row(
            children: [
              Expanded(
                child: textFormField(
                  context,
                  controller: _signupRePass,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  hintText: "$re_new_pass...",
                  labelText: "$re_new_pass",
                  isHiddenPass: _isHiddenPass,
                ),
              ),
              IconButton(
                icon: Icon(
                  _isHiddenPass ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isHiddenPass = !_isHiddenPass;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 21),
          InkWell(
            onTap: () async {
              var ge = await showDatePickerDialog(context);
              if (ge != null) {
                // ignore: division_optimization
                if ((((DateTime.now().difference(ge)).inDays) / 365).toInt() <
                    13) {
                  customDialog(
                    context,
                    text: year_warn,
                  );
                } else {
                  setState(() {
                    _signupYear = ge;
                  });
                }
              }
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              padding: const EdgeInsets.all(1.1),
              child: Container(
                height: 46,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                padding: const EdgeInsets.all(9.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(
                      Icons.date_range,
                      color: Colors.black87,
                    ),
                    Flexible(
                      child: Text(
                        _signupYear == null
                            ? _utils.stringOneUpper(year_data)
                            // ignore: division_optimization
                            : "${_signupYear!.day}.${_signupYear!.month}.${_signupYear!.year}  (${(((DateTime.now().difference(_signupYear!)).inDays) / 365).toInt()} $year)",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16.8,
                        ),
                      ),
                    ),
                    Container(),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 21),
          CustomButton(
            controller: _btnCtrl,
            text: _utils.stringOneUpper(signup),
            onPressed: () async {
              bool status = await _signupFunc(setState);
              if (status) {
                TextInput.finishAutofillContext();
              }
            },
          ),
          SizedBox(height: 25),
          InkWell(
            onTap: () {
              changeLoginType(LoginType.login, setState);
            },
            child: Center(
              child: Text(
                signup_have,
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _forgetWidgets(setState) {
    // String back = _lang.getTextTR(langEnum: _langEnum, key: "back");
    String email = _lang.getTextTR(langEnum: _langEnum, key: "email");
    String forget_b1 = _lang.getTextTR(langEnum: _langEnum, key: "forget_b1");

    String forget_w1 = _lang.getTextTR(langEnum: _langEnum, key: "forget_w1");
    String forget_enter_mail =
        _lang.getTextTR(langEnum: _langEnum, key: "forget_enter_mail");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          forget_enter_mail,
          style: TextStyle(
            fontSize: 15.2,
            color: _utils.appColor.titleColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 21),
        textFormField(
          context,
          controller: _forgetMail,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          hintText: "$email...",
          labelText: "$email",
          autofillHints: [AutofillHints.email],
        ),
        SizedBox(height: 25),
        CustomButton(
          controller: _btnCtrl,
          text: _utils.stringOneUpper(forget_b1),
          onPressed: () async => await _forgetFunc(),
        ),
        SizedBox(height: 20),
        InkWell(
          onTap: () {
            changeLoginType(LoginType.signup, setState);
          },
          child: Text(
            forget_w1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.2,
              color: Colors.red,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
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
        child: SafeArea(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      if (_loginType == LoginType.forget) {
                        changeLoginType(LoginType.login, setState);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: size.width,
                      padding: EdgeInsets.all(20),
                      color: _utils.appColor.scaffoldBg,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            (_loginType == LoginType.forget)
                                ? Icons.arrow_back_ios
                                : Icons.close,
                            size: 25,
                            color: _utils.appColor.titleColor,
                          ),
                          SizedBox(width: 9.0),
                          Flexible(
                            child: Text(
                              (_loginType == LoginType.login)
                                  ? login.toUpperCase()
                                  : (_loginType == LoginType.signup)
                                      ? signup.toUpperCase()
                                      : (_loginType == LoginType.forget)
                                          ? forget.toUpperCase()
                                          : "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 17.0,
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
                            if (topWidget != null) topWidget,
                            if (topWidget != null) SizedBox(height: 10),
                            if (_loginType == LoginType.login)
                              _loginWidgets(setState),
                            if (_loginType == LoginType.signup)
                              _signupWidgets(setState),
                            if (_loginType == LoginType.forget)
                              _forgetWidgets(setState),
                            SizedBox(height: size.height / 3),
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
      );
    },
  );
}
