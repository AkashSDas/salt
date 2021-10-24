import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> successSnackBar({
  required BuildContext context,
  required String msg,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
              color: Colors.white,
            ),
      ),
      backgroundColor: Colors.green,
    ),
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> failedSnackBar({
  required BuildContext context,
  required String msg,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
              color: Colors.white,
            ),
      ),
      backgroundColor: Colors.red,
    ),
  );
}
