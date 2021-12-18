import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salt/models/cart_product.dart/cart_product.dart';
import 'package:salt/providers/checkout.dart';
import 'package:salt/providers/user_payment.dart';
import 'package:salt/providers/user_provider.dart';
import 'package:salt/services/product.dart';
import 'package:salt/widgets/common/alert.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/common/cool.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';

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

            return ChangeNotifierProvider(
              create: (context) => CheckoutProvider(),
              child: ListView(
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
                  const SizedBox(height: 20),
                  const _TestCardInfo(),
                  const SizedBox(height: 40),
                  _PaymentSection(products: products),
                ],
              ),
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: DesignSystem.success),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
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
          RichText(
            text: TextSpan(
              text: 'Card number 👉 ',
              style: const TextStyle(
                color: DesignSystem.text1,
                fontSize: 17,
                fontFamily: DesignSystem.fontHighlight,
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(
                  text: '4242424242424242',
                  style: DesignSystem.bodyIntro,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              text: 'MM/YY 👉 ',
              style: const TextStyle(
                color: DesignSystem.text1,
                fontSize: 17,
                fontFamily: DesignSystem.fontHighlight,
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(
                  text: 'any (in future from now)',
                  style: DesignSystem.bodyIntro,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              text: 'CVV 👉 ',
              style: const TextStyle(
                color: DesignSystem.text1,
                fontSize: 17,
                fontFamily: DesignSystem.fontHighlight,
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(
                  text: 'any 3 digit number',
                  style: DesignSystem.bodyIntro,
                ),
              ],
            ),
          ),
        ],
      ),
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
  String? userPaymentMethodId;

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserProvider>(context);
    final _provider = Provider.of<CheckoutProvider>(context);

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
        const SizedBox(height: 20),
        const _UserPaymentCardsInfo(),
        const SizedBox(height: 40),
        PrimaryButton(
          text: loading ? 'Payment in process...' : 'Pay',
          horizontalPadding: loading ? 32 : 100,
          onPressed: () async {
            if (_provider.paymentMethodId != null) {
              setState(() => loading = true);
              final response = await _service.purchaseProducts(
                paymentMethod: _provider.paymentMethodId.toString(),
                products: widget.products,
                token: _user.token ?? '',
                userId: _user.user?.id ?? '',
              );
              setState(() => loading = false);

              if (response['error']) {
                failedSnackBar(context: context, msg: response['msg']);
              } else {
                await _service.emptyCart();

                /// TODO: Navigate to products screen
                successSnackBar(context: context, msg: response['msg']);
              }
            } else {
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

                /// TODO: Navigate to products screen
                successSnackBar(context: context, msg: response['msg']);
              }
            }
          },
        ),
      ],
    );
  }
}

class _UserPaymentCardsInfo extends StatelessWidget {
  const _UserPaymentCardsInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: 'OR ',
            style: const TextStyle(
              color: DesignSystem.text1,
              fontSize: 17,
              fontFamily: DesignSystem.fontHighlight,
              fontWeight: FontWeight.w400,
            ),
            children: [
              TextSpan(text: 'select a card', style: DesignSystem.bodyMain),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ChangeNotifierProvider(
          create: (context) => UserPaymentProvider(),
          child: const _UserPaymentCards(),
        ),
      ],
    );
  }
}

class _UserPaymentCards extends StatelessWidget {
  const _UserPaymentCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserPaymentProvider>(context);
    final _user = Provider.of<UserProvider>(context);

    return FutureBuilder(
        future: _provider.getPaymentCards(
          _user.user?.id ?? '',
          _user.token ?? '',
        ),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) return const SearchLoader();
          if (_provider.error) {
            failedSnackBar(context: context, msg: _provider.msg);
            return const LogoTV();
          }

          if (_provider.cards.isEmpty) {
            return Center(
              child: Text(
                'No saved cards',
                style: DesignSystem.bodyIntro,
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: _provider.cards.length,
            itemBuilder: (context, idx) {
              return _CreditCard(
                card: _provider.cards[idx],
                topLeftRadius: idx == 0 ? 14 : 0,
                topRightRadius: idx == 0 ? 14 : 0,
                bottomLeftRadius: idx == _provider.cards.length - 1 ? 14 : 0,
                bottomRightRadius: idx == _provider.cards.length - 1 ? 14 : 0,
              );
            },
          );
        });
  }
}

class _CreditCard extends StatelessWidget {
  final dynamic card;
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomRightRadius;
  final double bottomLeftRadius;

  const _CreditCard({
    required this.card,
    required this.topLeftRadius,
    required this.topRightRadius,
    required this.bottomLeftRadius,
    required this.bottomRightRadius,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<CheckoutProvider>(context);
    var data = card['card'];
    var active = _provider.paymentMethodId == card['id'];

    return InkWell(
      onTap: () {
        if (_provider.paymentMethodId == card['id']) {
          _provider.setPaymentMethodId(null);
        } else {
          _provider.setPaymentMethodId(card['id']);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        decoration: BoxDecoration(
          color: DesignSystem.card,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(bottomLeftRadius),
            bottomRight: Radius.circular(bottomRightRadius),
            topLeft: Radius.circular(topLeftRadius),
            topRight: Radius.circular(topRightRadius),
          ),
          border: active ? Border.all(color: DesignSystem.success) : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(IconlyLight.wallet),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "${data['brand']} **** **** **** ${data['last4']} expires ${data['exp_month']}/${data['exp_year']}",
                style: DesignSystem.caption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
