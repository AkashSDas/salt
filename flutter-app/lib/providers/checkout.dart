import 'package:flutter/material.dart';

class CheckoutProvider extends ChangeNotifier {
  String? paymentMethodId;

  /// Update payment method id
  void setPaymentMethodId(String? value) {
    paymentMethodId = value;
    notifyListeners();
  }
}
