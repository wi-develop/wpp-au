// ignore_for_file: non_constant_identifier_names

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../wpp_au.dart';
import '../components/dialogs/custom_dialog.dart';
import '../components/dialogs/date_picker_dialog.dart';
import '../components/forms/load_btn.dart';
import '../components/forms/text_form_field.dart';
import '../repository/auth_repository.dart';
import '../utils/lang.dart';
import '../utils/utils.dart';

Future<WpTokenModel?> loginPage({
  required BuildContext context,
  required ClientAppKeys clientAppKeys,
  LangEnum langEnum = LangEnum.en,
  String? infoText,
  String? mail,
  bool redirectEnterPassPage = false,
}) async {
  final _utils = Utils();
  final _lang = Lang();
  final _authRepository = AuthRepository();
  bool _isHiddenPass = true;

  bool isInit = false;

  //LangEnum langEnum = LangEnum.en;
  LoginType _loginType = LoginType.enterMail;

  final _mail = TextEditingController();
  final _pass = TextEditingController();
  final _name = TextEditingController();
  DateTime? _year;

  String? _mailErrorText;
  String? _passErrorText;
  String? _newPassErrorText;
  String? _nameErrorText;
  String? _yearErrorText;

  var _btnCtrl = LoadBtnController.idle;
  String forget = _lang.getTextTR(langEnum: langEnum, key: "forget");

  void changeLoginType(LoginType loginType, setState) {
    if (context.mounted) {
      setState(() {
        _loginType = loginType;
      });
    }
  }

  btnCtrlReset(setState) {
    try {
      if (context.mounted) {
        setState(() {
          _btnCtrl = LoadBtnController.idle;
        });
      }
    } catch (e) {
      //
    }
  }

  void initFunc(setState) {
    if (redirectEnterPassPage && mail != null) {
      _mail.text = mail;
      changeLoginType(LoginType.loginEnterPass, setState);
    }
  }

  Future<bool?> _mailCFunc() async {
    try {
      var value = await _authRepository.mailC(
        baseUrl: clientAppKeys.baseUrl,
        clientAppKeys: clientAppKeys,
        mail: _mail.text.trim(),
      );
      return value;
    } catch (e) {
      return null;
    }
  }

  Future<WpTokenModel?> _loginFunc(setState) async {
    String fill = _lang.getTextTR(langEnum: langEnum, key: "fill");
    String invalidPass =
        _lang.getTextTR(langEnum: langEnum, key: "invalidPass");

    try {
      if (_mail.text.trim().length > 4 && _pass.text.trim().length > 3) {
        var value = await _authRepository.login(
          baseUrl: clientAppKeys.baseUrl,
          clientAppKeys: clientAppKeys,
          loginMail: _mail.text.trim(),
          loginPass: _pass.text,
        );
        if (value.data != null) {
          return value.data;
        } else {
          btnCtrlReset(setState);
          if (context.mounted) {
            customDialog(
              context,
              text: invalidPass,
            );
          }
          return null;
        }
      } else {
        btnCtrlReset(setState);
        if (context.mounted) {
          customDialog(
            context,
            text: fill,
          );
        }
        return null;
      }
    } catch (e) {
      customDialog(
        context,
        text: "OPPS! Try again.",
      );
      return null;
    }
  }

  Future<WpTokenModel?> _signupFunc(dynamic setState) async {
    String fill = _lang.getTextTR(langEnum: langEnum, key: "fill");
    String usertrue = _lang.getTextTR(langEnum: langEnum, key: "usertrue");

    try {
      if (_mail.text.trim().length > 4 &&
          _pass.text.trim().length > 3 &&
          _name.text.trim().length > 0 &&
          _year != null) {
        var value = await _authRepository.signup(
          clientAppKeys: clientAppKeys,
          baseUrl: clientAppKeys.baseUrl,
          signupMail: _mail.text.trim(),
          signupPass: _pass.text,
          signupName: _name.text.trim(),
          signupYear: _year!,
          lang: langEnum != null ? langEnum.name : null,
        );
        if (value.data != null) {
          return value.data;
        } else {
          btnCtrlReset(setState);
          if (context.mounted) {
            if (value.errorMsg.toString() ==
                '{"statusCode":451,"msg":"E_113","errorMessage":"error: duplicate key value violates unique constraint \\"users_mail_key\\"","key":null}'
                    .toString()) {
              changeLoginType(
                LoginType.loginEnterPass,
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
          return null;
        }
      } else {
        if (context.mounted) {
          customDialog(
            context,
            text: fill,
          );
          btnCtrlReset(setState);
        }
        return null;
      }
    } catch (e) {
      btnCtrlReset(setState);
      customDialog(
        context,
        text: "OPPS! Try again.",
      );
      return null;
    }
  }

  Future<WpTokenModel?> _anonimFunc(dynamic setState) async {
    String fill = _lang.getTextTR(langEnum: langEnum, key: "fill");
    String usertrue = _lang.getTextTR(langEnum: langEnum, key: "usertrue");

    try {
      if (_year != null) {
        String deviceId = await _utils.getDeviceId;
        String name = _name.text.trim();
        String mail = deviceId + "@demo.wipepp.com";
        String pass = _utils.generateRandomString(12);

        if (_name.text.trim().length < 2) {
          name = "U${_year!.day.toString().hashCode}";
        }

        var value = await _authRepository.signup(
          clientAppKeys: clientAppKeys,
          baseUrl: clientAppKeys.baseUrl,
          signupMail: mail.trim(),
          signupPass: pass,
          signupName: name.trim(),
          signupYear: _year!,
          lang: langEnum != null ? langEnum.name : null,
        );
        if (value.data != null) {
          return value.data;
        } else {
          btnCtrlReset(setState);
          if (context.mounted) {
            if (value.errorMsg.toString() ==
                '{"statusCode":451,"msg":"E_113","errorMessage":"error: duplicate key value violates unique constraint \\"users_mail_key\\"","key":null}'
                    .toString()) {
              changeLoginType(
                LoginType.enterMail,
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
          return null;
        }
      } else {
        if (context.mounted) {
          customDialog(
            context,
            text: fill,
          );
          btnCtrlReset(setState);
        }
        return null;
      }
    } catch (e) {
      btnCtrlReset(setState);
      customDialog(
        context,
        text: "OPPS! Try again.",
      );
      return null;
    }
  }

  Future<void> _forgetFunc(setState) async {
    String fill = _lang.getTextTR(langEnum: langEnum, key: "fill");
    String forgetSuccess =
        _lang.getTextTR(langEnum: langEnum, key: "forget_p_success");

    try {
      if (_mail.text.trim().length > 4) {
        var value = await _authRepository.forgetPass(
          baseUrl: clientAppKeys.baseUrl,
          clientAppKeys: clientAppKeys,
          mail: _mail.text.trim(),
        );
        if (value.data) {
          btnCtrlReset(setState);
          changeLoginType(LoginType.loginEnterPass, setState);
          customDialog(
            context,
            text: forgetSuccess,
          );
        } else {
          btnCtrlReset(setState);
          if (context.mounted) {
            customDialog(
              context,
              text: "Try again.",
            );
          }
        }
      } else {
        btnCtrlReset(setState);
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

  Future<void> _selectYear(setState, year_warn) async {
    var ge = await showDatePickerDialog(context);
    if (ge != null) {
      // ignore: division_optimization
      if ((((DateTime.now().difference(ge)).inDays) / 365).toInt() < 13) {
        customDialog(
          context,
          text: year_warn,
        );
      } else {
        setState(() {
          _year = ge;
          _yearErrorText = null;
        });
      }
    }
  }

  Widget _mailEnterWidget(setState) {
    // String login = _lang.getTextTR(langEnum: langEnum, key: "login");
    String email = _lang.getTextTR(langEnum: langEnum, key: "email");
    String next = _lang.getTextTR(langEnum: langEnum, key: "next");
    String enterMail = _lang.getTextTR(langEnum: langEnum, key: "email");
    String anonimCon = _lang.getTextTR(langEnum: langEnum, key: "anonimCon");

    String wppAu1 = _lang.getTextTR(langEnum: langEnum, key: "wppAu1");
    String wppAu2 = _lang.getTextTR(langEnum: langEnum, key: "wppAu2");
    String wppAu3 = _lang.getTextTR(langEnum: langEnum, key: "wppAu3");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (infoText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Text(
              infoText,
              style: TextStyle(
                fontSize: 16.8,
                fontWeight: FontWeight.w500,
                fontFamily: "jost",
              ),
            ),
          ),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 18.0, height: 1.56, fontFamily: "jost"),
            children: [
              TextSpan(
                text: wppAu1 + " ",
                style: TextStyle(
                  color: _utils.appColor.titleColor,
                  fontSize: 16.5,
                  fontFamily: "jost",
                ),
              ),
              TextSpan(
                text: wppAu2 + " ",
                style: TextStyle(
                  color: _utils.appColor.titleColor,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w500,
                  fontFamily: "jost",
                ),
              ),
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _utils.goUrl(
                      context,
                      "https://www.wipepp.com/p/en/wipepp-auth",
                    );
                  },
                text: wppAu3,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16.5,
                  fontFamily: "jost",
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 35,
          child: Container(),
        ),
        AutofillGroup(
          child: textFormField(
            context,
            controller: _mail,
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: [AutofillHints.email],
            hintText: "$email...",
            labelText: "$email",
            errorText: _mailErrorText ?? "",
          ),
        ),
        SizedBox(height: 10),
        LoadBtn(
          controller: _btnCtrl,
          text: _utils.stringOneUpper(next),
          onPressed: () async {
            if (_mail.text.trim().length < 4) {
              setState(() {
                _mailErrorText = enterMail;
              });
              btnCtrlReset(setState);
            } else if (_utils.isValidEmail(_mail.text.trim()) == false) {
              setState(() {
                _mailErrorText = email;
              });
              btnCtrlReset(setState);
            } else {
              bool? status = await _mailCFunc();
              if (status == null) {
                btnCtrlReset(setState);
              } else if (status == false) {
                btnCtrlReset(setState);
                changeLoginType(LoginType.newUser, setState);
                setState(() {
                  _mailErrorText = null;
                });
              } else {
                btnCtrlReset(setState);
                changeLoginType(LoginType.loginEnterPass, setState);
                setState(() {
                  _mailErrorText = null;
                });
              }
            }
          },
        ),
        const SizedBox(height: 30),
        LoadBtn(
          controller: _btnCtrl,
          text: _utils.stringOneUpper(anonimCon),
          buttonColor: Colors.transparent,
          textColor: Colors.black,
          onPressed: () async {
            try {
              btnCtrlReset(setState);
              changeLoginType(LoginType.anonimNewUser, setState);
            } catch (e) {
              btnCtrlReset(setState);
            }
          },
        ),
      ],
    );
  }

  Widget _loginEnterPassWidget(setState) {
    String login = _lang.getTextTR(langEnum: langEnum, key: "login");
    String email = _lang.getTextTR(langEnum: langEnum, key: "email");
    String pass = _lang.getTextTR(langEnum: langEnum, key: "pass");
    //String showPass = _lang.getTextTR(langEnum: langEnum, key: "showPass");
    String notEmptyText =
        _lang.getTextTR(langEnum: langEnum, key: "notEmptyText");

    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (infoText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                infoText,
                style: TextStyle(
                  fontSize: 16.8,
                  fontWeight: FontWeight.w500,
                  fontFamily: "jost",
                ),
              ),
            ),
          Text(
            pass,
            style: TextStyle(fontSize: 17.0),
          ),
          SizedBox(height: 25),
          textFormField(
            context,
            controller: _mail,
            enabled: false,
            hintText: "$email...",
            labelText: "$email",
            autofillHints: [AutofillHints.email],
          ),
          SizedBox(height: 25),
          Stack(
            children: [
              textFormField(
                context,
                controller: _pass,
                autofocus: true,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                hintText: "$pass...",
                labelText: "$pass",
                autofillHints: [AutofillHints.password],
                isHiddenPass: _isHiddenPass,
                errorText: _passErrorText,
              ),
              Positioned(
                left: _utils.isDirectionRTL(context) ? 2 : null,
                right: _utils.isDirectionRTL(context) ? null : 2,
                child: IconButton(
                  icon: Icon(
                    _isHiddenPass ? Icons.visibility_off : Icons.visibility,
                    size: 23,
                  ),
                  onPressed: () {
                    setState(() {
                      _isHiddenPass = _isHiddenPass ? false : true;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          LoadBtn(
            controller: _btnCtrl,
            text: _utils.stringOneUpper(login),
            onPressed: () async {
              if (_pass.text.trim().length < 3) {
                btnCtrlReset(setState);
                setState(() {
                  _passErrorText = notEmptyText;
                });
              } else {
                WpTokenModel? value = await _loginFunc(setState);
                if (value != null) {
                  TextInput.finishAutofillContext();
                  Navigator.pop(context, value);
                }
              }
            },
          ),
          SizedBox(height: 25),
          TextButton(
            onPressed: () {
              changeLoginType(LoginType.forgetPass, setState);
            },
            child: Text(
              Utils().stringOneUpper(forget),
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _newUserWidget(setState) {
    String email = _lang.getTextTR(langEnum: langEnum, key: "email");
    String signup = _lang.getTextTR(langEnum: langEnum, key: "signup");
    String new_pass = _lang.getTextTR(langEnum: langEnum, key: "new_pass");
    String name = _lang.getTextTR(langEnum: langEnum, key: "name");
    String year_data = _lang.getTextTR(langEnum: langEnum, key: "year_data");
    String year = _lang.getTextTR(langEnum: langEnum, key: "year");
    String year_warn = _lang.getTextTR(langEnum: langEnum, key: "year_warn");
    String min5 = _lang.getTextTR(langEnum: langEnum, key: "min5");
    String createWp = _lang.getTextTR(langEnum: langEnum, key: "createWp");

    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _utils.stringOneUpper(createWp),
            style: TextStyle(
              fontSize: 17.0,
              color: _utils.appColor.titleColor,
            ),
          ),
          SizedBox(height: 25),
          textFormField(
            context,
            controller: _mail,
            enabled: false,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            hintText: "$email...",
            labelText: "$email",
            autofillHints: [AutofillHints.email],
          ),
          SizedBox(height: 21),
          textFormField(
            context,
            controller: _name,
            autofocus: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            hintText: "$name...",
            labelText: "$name",
            autofillHints: [AutofillHints.name],
            errorText: _nameErrorText,
            onFieldSubmitted: (p0) {
              if (p0.trim().isNotEmpty) {
                setState(() {
                  _nameErrorText = null;
                });
              }
            },
          ),
          SizedBox(height: 21),
          Stack(
            children: [
              textFormField(
                context,
                controller: _pass,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                hintText: "$new_pass...",
                labelText: "$new_pass",
                autofillHints: [AutofillHints.newPassword],
                isHiddenPass: _isHiddenPass,
                errorText: _newPassErrorText,
                onFieldSubmitted: (p0) async {
                  try {
                    if (_pass.text.trim().length < 7) {
                      setState(() {
                        _newPassErrorText = min5;
                      });
                    } else {
                      setState(() {
                        _newPassErrorText = null;
                      });
                      if (_year == null) {
                        _selectYear(setState, year_warn);
                      }
                    }
                  } catch (e) {}
                },
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  icon: Icon(
                    _isHiddenPass ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isHiddenPass = !_isHiddenPass;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 21),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  await _selectYear(setState, year_warn);
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
                            _year == null
                                ? _utils.stringOneUpper(year_data)
                                // ignore: division_optimization
                                : "${_year!.day}.${_year!.month}.${_year!.year}  (${(((DateTime.now().difference(_year!)).inDays) / 365).toInt()} $year)",
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
              if (_yearErrorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "$_yearErrorText",
                    style: TextStyle(
                      fontSize: 16.8,
                      color: _utils.appColor.alertColor,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 21),
          LoadBtn(
            controller: _btnCtrl,
            text: _utils.stringOneUpper(signup),
            onPressed: () async {
              if (_name.text.trim().isEmpty) {
                setState(() {
                  _nameErrorText = name;
                });
                btnCtrlReset(setState);
              } else if (_pass.text.trim().length < 7) {
                setState(() {
                  _newPassErrorText = min5;
                });
                btnCtrlReset(setState);
              } else if (_year == null) {
                setState(() {
                  _yearErrorText = year_data;
                });
                btnCtrlReset(setState);
                _selectYear(setState, year_warn);
              } else {
                WpTokenModel? value = await _signupFunc(setState);
                if (value != null) {
                  TextInput.finishAutofillContext();
                  Navigator.pop(context, value);
                } else {
                  btnCtrlReset(setState);
                }
              }
            },
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _forgetWidgets(setState) {
    String email = _lang.getTextTR(langEnum: langEnum, key: "email");
    String forget_b1 = _lang.getTextTR(langEnum: langEnum, key: "forget_b1");

    String forget = _lang.getTextTR(langEnum: langEnum, key: "forget");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          forget,
          style: TextStyle(
            fontSize: 17.0,
            color: _utils.appColor.titleColor,
          ),
        ),
        SizedBox(height: 25),
        textFormField(
          context,
          controller: _mail,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          hintText: "$email...",
          labelText: "$email",
          autofillHints: [AutofillHints.email],
        ),
        SizedBox(height: 25),
        LoadBtn(
          controller: _btnCtrl,
          text: _utils.stringOneUpper(forget_b1),
          onPressed: () async => await _forgetFunc(setState),
        ),
      ],
    );
  }

  Widget _anonimNewUserWidget(setState) {
    String name = _lang.getTextTR(langEnum: langEnum, key: "name");
    String year_data = _lang.getTextTR(langEnum: langEnum, key: "year_data");
    String year = _lang.getTextTR(langEnum: langEnum, key: "year");
    String year_warn = _lang.getTextTR(langEnum: langEnum, key: "year_warn");
    String anonimT1 = _lang.getTextTR(langEnum: langEnum, key: "anonimT1");
    String continueStr =
        _lang.getTextTR(langEnum: langEnum, key: "continueStr");

    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _utils.stringOneUpper(anonimT1),
            style: TextStyle(
              fontSize: 17.0,
              color: _utils.appColor.titleColor,
            ),
          ),
          SizedBox(height: 25),
          textFormField(
            context,
            controller: _name,
            autofocus: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            hintText: "$name...",
            labelText: "$name",
            autofillHints: [AutofillHints.name],
            errorText: _nameErrorText,
            onFieldSubmitted: (p0) {
              if (_year == null) {
                _selectYear(setState, year_warn);
              }
            },
          ),
          SizedBox(height: 21),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  await _selectYear(setState, year_warn);
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
                            _year == null
                                ? _utils.stringOneUpper(year_data)
                                // ignore: division_optimization
                                : "${_year!.day}.${_year!.month}.${_year!.year}  (${(((DateTime.now().difference(_year!)).inDays) / 365).toInt()} $year)",
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
              if (_yearErrorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "$_yearErrorText",
                    style: TextStyle(
                      fontSize: 16.8,
                      color: _utils.appColor.alertColor,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 21),
          LoadBtn(
            controller: _btnCtrl,
            text: _utils.stringOneUpper(continueStr),
            onPressed: () async {
              if (_year == null) {
                setState(() {
                  _yearErrorText = year_data;
                });
                btnCtrlReset(setState);
                _selectYear(setState, year_warn);
              } else {
                WpTokenModel? value = await _anonimFunc(setState);
                if (value != null) {
                  Navigator.pop(context, value);
                } else {
                  btnCtrlReset(setState);
                }
              }
            },
          ),
          SizedBox(height: 25),
        ],
      ),
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
                if (isInit == false) {
                  initFunc(setState);
                  setState(() {
                    isInit = true;
                  });
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width,
                        color: _utils.appColor.scaffoldBg,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                if (_loginType != LoginType.enterMail) {
                                  changeLoginType(
                                      LoginType.enterMail, setState);
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: 20,
                                  bottom: 20,
                                  left:
                                      Utils().isDirectionRTL(context) ? 0 : 15,
                                  right:
                                      Utils().isDirectionRTL(context) ? 15 : 0,
                                ),
                                child: Icon(
                                  (_loginType != LoginType.enterMail)
                                      ? Icons.arrow_back_ios
                                      : Icons.close,
                                  size: 25,
                                  color: _utils.appColor.titleColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: _utils.isDirectionRTL(context) ? 8 : 0,
                                right: _utils.isDirectionRTL(context) ? 0 : 8,
                              ),
                              child: Image.network(
                                "https://www.wipepp.com/images/wpp_a1_img1.png",
                                fit: BoxFit.cover,
                                height: 32,
                              ),
                            ),
                          ],
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
                                if (_loginType == LoginType.enterMail)
                                  _mailEnterWidget(setState),
                                if (_loginType == LoginType.loginEnterPass)
                                  _loginEnterPassWidget(setState),
                                if (_loginType == LoginType.forgetPass)
                                  _forgetWidgets(setState),
                                if (_loginType == LoginType.newUser)
                                  _newUserWidget(setState),
                                if (_loginType == LoginType.anonimNewUser)
                                  _anonimNewUserWidget(setState),
                                SizedBox(height: size.height / 3),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}
