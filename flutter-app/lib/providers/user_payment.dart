import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:salt/services/payment.dart';

class UserPaymentProvider extends ChangeNotifier {
  /// User payment cards saved
  List cards = [];
  SetupIntent? setupIntent;
  bool error = false;
  String msg = '';

  var loading = false;

  /// Update cards
  void updateCards(List value) {
    cards = value;
    notifyListeners();
  }

  /// Update loading
  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  /// Update setup intent
  void setSetupIntent(SetupIntent value) {
    setupIntent = value;
    notifyListeners();
  }

  /// Get user's all payment cards
  /// The return here is of [bool] type representing the [loading state]
  Future<bool> getPaymentCards(String userId, String token) async {
    final service = PaymentService();
    final data = await service.getUserPaymentCards(userId, token);
    if (data['error'] || data['cards'] == null) {
      error = true;
      msg = data['msg'];
    } else {
      if (data['cards'].isNotEmpty) {
        cards = data['cards'];
      }
    }
    notifyListeners();
    return true;
  }
}
