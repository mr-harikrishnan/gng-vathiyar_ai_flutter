import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vathiyar_ai_flutter/app-colors.dart';

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
    backgroundColor: result == "Error" ? Colors.red : AppColors.primary,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
