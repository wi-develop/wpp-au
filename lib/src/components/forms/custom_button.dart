import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/utils.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  RoundedLoadingButtonController? controller;
  String text;
  VoidCallback onPressed;
  double borderRadius;
  Color buttonColor;
  Color textColor;
  double? width;
  double height;
  double iconSize;
  IconData? icon;
  Alignment? textAlign;
  TextStyle? textStyle;
  MainAxisAlignment? mainAxisAlignment;
  CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.borderRadius = 10,
    this.buttonColor = Colors.blue,
    this.controller,
    this.height = 43,
    this.icon,
    this.iconSize = 25.0,
    this.mainAxisAlignment,
    this.textAlign,
    this.textColor = Colors.white,
    this.textStyle,
    this.width,
  }) : super(key: key);

  final _utils = Utils();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (controller != null) {
      return RoundedLoadingButton(
        controller: controller!,
        borderRadius: borderRadius,
        color: Theme.of(context).scaffoldBackgroundColor,
        height: height,
        width: width ?? size.width,
        valueColor: Colors.indigo,
        errorColor: Colors.grey.shade200,
        successColor: Colors.grey.shade200,
        elevation: 0.0,
        onPressed: onPressed,
        child: Container(
          height: height,
          alignment: textAlign ?? Alignment.center,
          width: width ?? size.width,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
          child: Row(
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
            children: [
              if (icon != null)
                Padding(
                  padding: EdgeInsets.only(
                    left: _utils.isDirectionRTL(context) ? 8.0 : 0.0,
                    right: _utils.isDirectionRTL(context) ? 0.0 : 8.0,
                  ),
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: textColor,
                  ),
                ),
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle ??
                      TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: InkWell(
          onTap: onPressed,
          child: Container(
            height: height,
            alignment: Alignment.center,
            width: width ?? size.width,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Padding(
                    padding: EdgeInsets.only(
                      left: _utils.isDirectionRTL(context) ? 8.0 : 0.0,
                      right: _utils.isDirectionRTL(context) ? 0.0 : 8.0,
                    ),
                    child: Icon(
                      icon,
                      size: iconSize,
                      color: textColor,
                    ),
                  ),
                Flexible(
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle ??
                        TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
