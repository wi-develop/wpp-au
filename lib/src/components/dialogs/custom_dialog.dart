import 'package:flutter/material.dart';

import '../forms/custom_button.dart';

Future<void> customDialog(
  BuildContext context, {
  String? title,
  required String text,
  Widget? buttonWidget,
}) async {
  String ok = "OK";
  final size = MediaQuery.of(context).size;

  return await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(4.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              if (title != null)
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (title != null) SizedBox(height: 18, child: Container()),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (buttonWidget != null)
                SizedBox(height: 18, child: Container()),
              if (buttonWidget != null) buttonWidget,
              SizedBox(height: 18, child: Container()),
              CustomButton(
                width: size.width,
                text: ok,
                height: 42,
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
