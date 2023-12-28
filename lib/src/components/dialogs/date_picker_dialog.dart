// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<DateTime?> showDatePickerDialog(BuildContext context) async {
  String ok = "OK";

  String tamaT = ok.toUpperCase();
  int gun = DateTime.now().day;
  int ay = DateTime.now().month;
  int yil = DateTime.now().year; //- 18;

  final picked = await showCupertinoModalPopup(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) {
        return Container(
          height: 238,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              SizedBox(
                height: 48,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 6.0,
                      top: 4.0,
                      bottom: 4.0,
                    ),
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () => Navigator.of(context).pop(
                        DateTime(yil, ay, gun),
                      ),
                      icon: const Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      label: Text(
                        tamaT,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17.2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 190,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime(yil, ay, gun),
                  use24hFormat: true,
                  minimumDate: DateTime(1940, 1, 1),
                  maximumDate: DateTime.now(),
                  dateOrder: DatePickerDateOrder.ymd,
                  onDateTimeChanged: (val) {
                    setState(() {
                      gun = val.day;
                      ay = val.month;
                      yil = val.year;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
  return picked;
}
