import 'package:flutter/material.dart';

import '../../utils/utils.dart';

enum LoadBtnController { idle, loading, success, error }

// ignore: must_be_immutable
class LoadBtn extends StatefulWidget {
  LoadBtnController controller;
  String text;
  VoidCallback onPressed;
  Color? buttonColor;
  Color? textColor;
  double? width;
  double height;
  double iconSize;
  IconData? icon;
  Alignment? textAlign;
  TextStyle? textStyle;

  LoadBtn({
    required this.controller,
    required this.onPressed,
    required this.text,
    this.buttonColor,
    this.height = 40,
    this.icon,
    this.iconSize = 25,
    this.textAlign,
    this.textColor,
    this.textStyle,
    this.width,
  });

  @override
  State<LoadBtn> createState() => _LoadBtnState();
}

class _LoadBtnState extends State<LoadBtn> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final utils = Utils();

    switch (widget.controller) {
      case LoadBtnController.loading:
        return Container(
          height: widget.height,
          alignment: widget.textAlign ?? Alignment.center,
          width: widget.width ?? size.width,
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: widget.buttonColor ?? utils.appColor.buttonColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: SizedBox(
            height: widget.height - 8,
            width: widget.height - 8,
            child: CircularProgressIndicator(
              color: widget.textColor ?? Colors.white,
              strokeWidth: 2.2,
            ),
          ),
        );
      case LoadBtnController.idle:
        return InkWell(
          onTap: () async {
            try {
              if (widget.controller == LoadBtnController.idle) {
                setState(() {
                  widget.controller = LoadBtnController.loading;
                });
                widget.onPressed();
              }
            } catch (e) {
              try {
                setState(() {
                  widget.controller = LoadBtnController.idle;
                });
              } catch (e) {
                //
              }
            }
          },
          child: Container(
            height: widget.height,
            alignment: widget.textAlign ?? Alignment.center,
            width: widget.width ?? size.width,
            decoration: BoxDecoration(
              color: widget.buttonColor ?? utils.appColor.buttonColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null)
                  Padding(
                    padding: EdgeInsets.only(
                      left: utils.isDirectionRTL(context) ? 8.0 : 0.0,
                      right: utils.isDirectionRTL(context) ? 0.0 : 8.0,
                    ),
                    child: Icon(
                      widget.icon,
                      size: widget.iconSize,
                      color: widget.textColor ?? Colors.white,
                    ),
                  ),
                Flexible(
                  child: Text(
                    widget.text,
                    overflow: TextOverflow.ellipsis,
                    style: widget.textStyle ??
                        TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: widget.textColor ?? Colors.white,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );

      case LoadBtnController.success:
        return Container(
          height: widget.height,
          alignment: widget.textAlign ?? Alignment.center,
          width: widget.width ?? size.width,
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: widget.buttonColor ?? utils.appColor.buttonColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: Icon(
            Icons.done,
            size: widget.iconSize,
            color: widget.textColor ?? Colors.white,
          ),
        );
      case LoadBtnController.error:
        return Container(
          height: widget.height,
          alignment: widget.textAlign ?? Alignment.center,
          width: widget.width ?? size.width,
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: widget.buttonColor ?? utils.appColor.buttonColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: Icon(
            Icons.close,
            size: widget.iconSize,
            color: widget.textColor ?? Colors.white,
          ),
        );
    }
  }
}
