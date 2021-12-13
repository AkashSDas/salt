import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> successSnackBar({
  required BuildContext context,
  required String msg,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        style: DesignSystem.bodyIntro.copyWith(color: Colors.white),
      ),
      backgroundColor: DesignSystem.success,
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
        style: DesignSystem.bodyIntro.copyWith(color: Colors.white),
      ),
      backgroundColor: DesignSystem.error,
    ),
  );
}
