import 'package:flutter/cupertino.dart';
import 'package:salt/services/payment.dart';
import 'package:salt/widgets/alerts/index.dart';

class PaymentProvider extends ChangeNotifier {
  var loading = false;

  Future<void> checkout(
    BuildContext context,
    String userId,
    String token,
    double amount,
    String paymentMethodId,
  ) async {
    final _service = PaymentService();
    setLoading(true);
    await _service.productsCheckout(userId, token, amount, paymentMethodId);
    setLoading(false);

    if (_service.error) {
      failedSnackBar(context: context, msg: _service.msg);
    } else {
      successSnackBar(context: context, msg: _service.msg);
    }
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }
}
