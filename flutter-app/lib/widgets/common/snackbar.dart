import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> displaySnackBar({
  required BuildContext context,
  required bool success,
  required String msg,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style:
          Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.white),
    ),
    backgroundColor: success ? Colors.green : Colors.red,
  ));
}
