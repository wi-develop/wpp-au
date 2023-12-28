import 'package:flutter/material.dart';

enum FormFieldTheme { light, dark, system }

TextFormField textFormField(
  BuildContext context, {
  required TextEditingController? controller,
  String? initialValue,
  String? hintText,
  String? labelText,
  String? helperText,
  int maxLines = 1,
  int minLines = 1,
  int? maxLength,
  TextInputType? keyboardType,
  Function(String)? onChanged,
  Function(String)? onFieldSubmitted,
  TextInputAction textInputAction = TextInputAction.done,
  bool? enabled,
  FocusNode? focusNode,
  bool autofocus = false,
  bool hiddenMaxLength = false,
  List<String>? autofillHints,
  bool isHiddenPass = false,
}) {
  if (controller == null && initialValue == null) {
    throw ErrorWidget(
        "controller == null && initialValue == null : is not true");
  }

  Color _color = Colors.black87;
  Color _cursorColor = Colors.indigo;

  return TextFormField(
    enabled: enabled,
    cursorHeight: 25,
    controller: controller,
    initialValue: initialValue,
    maxLines: maxLines,
    minLines: minLines,
    onChanged: onChanged,
    onFieldSubmitted: onFieldSubmitted,
    maxLength: maxLength,
    textInputAction: textInputAction,
    keyboardType: keyboardType,
    cursorColor: _cursorColor,
    focusNode: focusNode,
    autofocus: autofocus,
    obscureText: isHiddenPass,
    autofillHints: autofillHints,
    decoration: InputDecoration(
      counterText: hiddenMaxLength ? '' : null,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: _color),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _color),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _color),
        borderRadius: BorderRadius.circular(10.0),
      ),
      hintText: hintText,
      labelText: labelText,
      helperText: helperText,
      hintStyle: TextStyle(color: _color),
      labelStyle: TextStyle(color: _color),
      helperStyle: TextStyle(color: _color),
      counterStyle: TextStyle(color: _color),
      contentPadding:
          const EdgeInsets.only(left: 10, bottom: 16, top: 0, right: 10),
    ),
    style: TextStyle(color: _color),
  );
}
