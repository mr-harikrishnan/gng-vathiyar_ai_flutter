import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> showPopError(
  BuildContext context,
  String message,
  String result,
) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: result == "Error" ? Colors.red : const Color(0xFF016A63),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
