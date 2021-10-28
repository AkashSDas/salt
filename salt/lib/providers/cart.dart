import 'package:flutter/cupertino.dart';
import 'package:salt/services/product.dart';
import 'package:salt/widgets/alerts/index.dart';

class CartProvider extends ChangeNotifier {
  bool loading = false;

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Future<void> saveProductToCart(BuildContext context, Map product) async {
    final _service = ProductService();

    setLoading(true);
    await _service.saveProductToCart(product);
    setLoading(false);

    if (_service.error) {
      failedSnackBar(context: context, msg: _service.msg);
    } else {
      successSnackBar(context: context, msg: _service.msg);
    }
  }
}
