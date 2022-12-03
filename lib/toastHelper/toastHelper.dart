// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

ToastMassage(String message, BuildContext context) {
  Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.greenAccent,
      textColor: Colors.black,
      fontSize: 20.0);
}

AlertMassage(String message, BuildContext context) {
  Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 20.0);
}
