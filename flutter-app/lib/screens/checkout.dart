import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:salt/models/cart_product.dart/cart_product.dart';
import 'package:salt/providers/user_provider.dart';
import 'package:salt/services/product.dart';
import 'package:salt/widgets/common/alert.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';
import 'package:salt/widgets/drawer/drawer_body.dart';

import '../design_system.dart';

class CheckoutScreen extends StatelessWidget {
  final _service = ProductService();
  CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      children: [
        const SizedBox(height: 20),
        Text(
          'Checkout',
          style: DesignSystem.heading4,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        FutureBuilder(
          future: _service.getCartProducts(),
          builder: (context, AsyncSnapshot<List<CartProduct>> snapshot) {
            if (!snapshot.hasData) {
              return Column(
                children: [
                  const LogoTV(),
                  const SizedBox(height: 40),
                  Text(
                    "You're cart is empty",
                    style: DesignSystem.bodyMain,
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }

            final products = snapshot.data!;
            double totalAmount = 0;
            products.forEach((prod) => {
                  totalAmount = totalAmount + prod.price * prod.quantitySelected
                });

            return ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Text(
                  'Total amount is \$$totalAmount',
                  style: DesignSystem.bodyMain,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Divider(color: DesignSystem.border),
                const SizedBox(height: 20),
                const _TestCardInfo(),
                const SizedBox(height: 40),
                _PaymentSection(products: products),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _TestCardInfo extends StatelessWidget {
  const _TestCardInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Test card info',
          style: TextStyle(
            color: DesignSystem.success,
            fontSize: 20,
            fontFamily: DesignSystem.fontHighlight,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 20),
        Text('4242424242424242', style: DesignSystem.bodyIntro),
      ],
    );
  }
}

class _PaymentSection extends StatefulWidget {
  final List<CartProduct> products;

  const _PaymentSection({
    required this.products,
    Key? key,
  }) : super(key: key);

  @override
  State<_PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<_PaymentSection> {
  final _ctrl = CardEditController();
  final _service = ProductService();
  var loading = false;

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserProvider>(context);

    return Column(
      children: [
        CardField(
          controller: _ctrl,
          cursorColor: DesignSystem.secondary,
          style: DesignSystem.bodyMain,
          decoration: InputDecoration(
            fillColor: DesignSystem.card,
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            hintStyle: DesignSystem.bodyMain.copyWith(
              color: const Color(0xff484848),
            ),
          ),
        ),
        const SizedBox(height: 40),
        PrimaryButton(
          text: loading ? 'Payment in process...' : 'Pay',
          horizontalPadding: loading ? 32 : 100,
          onPressed: () async {
            if (!_ctrl.complete) {
              failedSnackBar(context: context, msg: 'Fill card information');
              return;
            }

            /// User info
            final details = BillingDetails(email: _user.user?.email ?? '');

            /// Create payment method
            final paymentMethod = await Stripe.instance.createPaymentMethod(
              PaymentMethodParams.card(billingDetails: details),
            );

            setState(() => loading = true);
            final response = await _service.purchaseProducts(
              paymentMethod: paymentMethod.id,
              products: widget.products,
              token: _user.token ?? '',
              userId: _user.user?.id ?? '',
            );
            setState(() => loading = false);

            if (response['error']) {
              failedSnackBar(context: context, msg: response['msg']);
            } else {
              await _service.emptyCart();
              successSnackBar(context: context, msg: response['msg']);
            }
          },
        ),
      ],
    );
  }
}
