import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomFlutterToast {
  static Future showErrorToast(String title) {
    Fluttertoast.cancel();
    return Fluttertoast.showToast(
        msg: title,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red[500],
        textColor: Colors.white,
        timeInSecForIosWeb: 5,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 16.0);
  }

  static Future showOkayToast(String title) {
    Fluttertoast.cancel();
    return Fluttertoast.showToast(
        msg: title,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
        timeInSecForIosWeb: 5,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 16.0);
  }
}
