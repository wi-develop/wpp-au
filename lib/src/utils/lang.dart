import 'enums.dart';

class Lang {
  String getTextTR({
    LangEnum langEnum = LangEnum.en,
    required String key,
  }) {
    try {
      var m1 = _tMaps[langEnum];
      if (m1 != null) {
        var t1 = m1[key];
        if (t1 != null) {
          return t1.toString();
        } else {
          return "_";
        }
      } else {
        var m1En = _tMaps[LangEnum.en];
        var t1 = m1En![key];
        if (t1 != null) {
          return t1.toString();
        } else {
          return "_";
        }
      }
    } catch (e) {
      return "-";
    }
  }

  Map<LangEnum, Map<String, String>> _tMaps = {
    LangEnum.en: {
      "changeMailSuccess":
          "Success! Please check your email inbox. The confirmation code is usually delivered within 2 minutes. (Also, check your spam folder.)",
      "demoUserEnterMail":
          "Please enter your email address. (A confirmation code will be sent.)",
      "mail": "Your email address",
      "createWp": "Create a Wipepp Account",
      "min5": "The password must be at least 6 characters long.",
      "invalidPass":
          "Invalid password. Please try again or click 'Forgot Password' to reset your password.",
      "wppAu1":
          "Use your Wippe account. If you don't have an account, a new one will be created.",
      "wppAu2": "First, enter your email address.",
      "wppAu3": "More information.",
      "next": "Next",
      "showPass": "Show password.",
      "notEmptyText": "Required field. Please fill in.",
      "login": "Login",
      "email": "Enter your email",
      "pass": "Enter your password",
      "forget": "Forget password?",
      "login_have": "Don't have an account? Signup",
      "signup": "Signup",
      "new_pass": "Create a password",
      "re_new_pass": "Confirm your password",
      "signup_have": "Already have an account? Login",
      "name": "Enter your name",
      "year": "Age",
      "year_data": "Enter your date of birth",
      "back": "Back",
      "forget_enter_mail": "Type your email address in the field below.",
      "forget_b1": "Send Password Reset Request",
      "fill": "Fill in the required fields.",
      "not_c": "Email and/or password are not correct. Please check accuracy.",
      "wp_token_error": "Try again or sign in with email.",
      "pass_re_w":
          "You made a mistake in password confirmation. The two passwords you enter must be the same.",
      "forget_p_success":
          "Your password change request has been sent to your e-mail address. Check your email box. (Check your spam folder too.)",
      "send": "Send",
      "verifier_T1":
          "Enter the confirmation code sent to your email address below.",
      "verifier_B1": "Resend verification code",
      "change_email_T1":
          "This email address doesn't belong to you? Change your email address.",
      "change_email_B1": "Change E-mail Address",
      "verifier_code": "Enter the Confirmation Code",
      "enter_new_email": "Enter your new email address",
      "verify_acc": "Verify Account",
      "v_c_err": "Verification code is incorrect.",
      "login_again_c_pass": "Log in again. Password has been changed.",
      "again_code": "Check your email box. (Check your spam folder too.)",
      "err_again_code_limit":
          "You have made too many requests. Please try again in 1 hour.",
      "year_warn":
          "You must be 13 years old or older to use the application and create an account.",
      "usertrue":
          "There is an account with this email address. Please log in. If you don't remember your password, click the 'I forgot my password' button.",
    },
  };
}
