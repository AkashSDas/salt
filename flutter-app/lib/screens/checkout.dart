import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/cart_product.dart/cart_product.dart';
import 'package:salt/models/user/user.dart';
import 'package:salt/providers/checkout.dart';
import 'package:salt/providers/user_payment.dart';
import 'package:salt/providers/user_provider.dart';
import 'package:salt/services/product.dart';
import 'package:salt/widgets/common/alert.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/common/cool.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';
import 'package:salt/widgets/others/payment.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      children: [
        DesignSystem.spaceH20,
        Text(
          'Checkout',
          style: DesignSystem.heading4,
          textAlign: TextAlign.center,
        ),
        DesignSystem.spaceH40,
        _CartPaymentSection(),
      ],
    );
  }
}

/// Empty cart
class _EmptyCart extends StatelessWidget {
  const _EmptyCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}

/// Payment section
class _CartPaymentSection extends StatelessWidget {
  final _service = ProductService();
  _CartPaymentSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _service.getCartProducts(),
      builder: (context, AsyncSnapshot<List<CartProduct>> snapshot) {
        if (!snapshot.hasData) return const _EmptyCart();

        // Get products total price
        final products = snapshot.data!;
        double totalAmount = 0;
        products.forEach(
          (prod) {
            totalAmount = totalAmount + prod.price * prod.quantitySelected;
          },
        );

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
              DesignSystem.spaceH40,
              const TestCardInfo(),
              DesignSystem.spaceH40,
              _UserPaymentSection(products: products),
            ],
          ),
        );
      },
    );
  }
}

/// Payment section has `payment card input` and user's saved `payment methods`
class _UserPaymentSection extends StatelessWidget {
  final List<CartProduct> products;
  final _ctrl = CardEditController();
  _UserPaymentSection({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCard(),
        const SizedBox(height: 20),
        const UserOtherPaymentMethods(),
        const SizedBox(height: 40),
        _PaymentButton(products: products, cardEditController: _ctrl),
      ],
    );
  }

  Widget _buildCard() {
    return CardField(
      controller: _ctrl,
      cursorColor: DesignSystem.secondary,
      style: DesignSystem.bodyMain,
      decoration: InputDecoration(
        fillColor: DesignSystem.card,
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
        ),
        hintStyle: DesignSystem.bodyMain.copyWith(
          color: const Color(0xff484848),
        ),
      ),
    );
  }
}

/// User payment btn

class _PaymentButton extends StatefulWidget {
  final List<CartProduct> products;
  final CardEditController cardEditController;

  const _PaymentButton({
    Key? key,
    required this.products,
    required this.cardEditController,
  }) : super(key: key);

  @override
  State<_PaymentButton> createState() => _PaymentButtonState();
}

class _PaymentButtonState extends State<_PaymentButton> {
  var loading = false;
  final _service = ProductService();

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserProvider>(context);
    final _provider = Provider.of<CheckoutProvider>(context);

    return PrimaryButton(
      text: loading ? 'Payment in process...' : 'Pay',
      horizontalPadding: loading ? 32 : 100,
      onPressed: () async {
        if (_provider.paymentMethodId != null) {
          _processSelectedCard(
            _provider.paymentMethodId.toString(),
            _user.token ?? '',
            _user.user?.id ?? '',
          );
        } else {
          _processNotSelectedCard(_user.user, _user.token);
        }
      },
    );
  }

  // FUNCTIONS

  /// Process card payment for card that is selected from saved user's
  /// payment cards
  Future<void> _processSelectedCard(
    String paymentMethodId,
    String token,
    String id,
  ) async {
    setState(() => loading = true);
    final response = await _service.purchaseProducts(
      paymentMethod: paymentMethodId,
      products: widget.products,
      token: token,
      userId: id,
    );
    setState(() => loading = false);

    if (response['error']) {
      failedSnackBar(context: context, msg: response['msg']);
    } else {
      await _service.emptyCart();
      successSnackBar(context: context, msg: response['msg']);
    }
  }

  /// Process card payment for card where user places their card info
  Future<void> _processNotSelectedCard(User? user, String? token) async {
    if (!widget.cardEditController.complete) {
      failedSnackBar(context: context, msg: 'Fill card information');
      return;
    }

    setState(() => loading = true);
    final details = BillingDetails(email: user?.email ?? '');
    final paymentMethod = await Stripe.instance.createPaymentMethod(
      PaymentMethodParams.card(billingDetails: details),
    );
    final response = await _service.purchaseProducts(
      paymentMethod: paymentMethod.id,
      products: widget.products,
      token: token ?? '',
      userId: user?.id ?? '',
    );
    setState(() => loading = false);

    if (response['error']) {
      failedSnackBar(context: context, msg: response['msg']);
    } else {
      await _service.emptyCart();
      successSnackBar(context: context, msg: response['msg']);
    }
  }
}

/// User's other payment methods section
class UserOtherPaymentMethods extends StatelessWidget {
  const UserOtherPaymentMethods({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeading(),
        const SizedBox(height: 20),
        ChangeNotifierProvider(
          create: (context) => UserPaymentProvider(),
          child: const _UserPaymentCards(),
        ),
      ],
    );
  }

  Widget _buildHeading() {
    return RichText(
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
    );
  }
}

/// User's payment cards
class _UserPaymentCards extends StatelessWidget {
  const _UserPaymentCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserPaymentProvider>(context);
    final _user = Provider.of<UserProvider>(context);
    var future = _provider.getPaymentCards(
      _user.user?.id ?? '',
      _user.token ?? '',
    );

    return FutureBuilder(
      future: future,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) return const SearchLoader();
        if (_provider.error) {
          failedSnackBar(context: context, msg: _provider.msg);
          return const LogoTV();
        }

        if (_provider.cards.isEmpty) {
          return Center(
            child: Text('No saved cards', style: DesignSystem.bodyIntro),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: _provider.cards.length,
          itemBuilder: (context, idx) {
            return _PaymentCard(
              card: _provider.cards[idx],
              topLeftRadius: idx == 0 ? 14 : 0,
              topRightRadius: idx == 0 ? 14 : 0,
              bottomLeftRadius: idx == _provider.cards.length - 1 ? 14 : 0,
              bottomRightRadius: idx == _provider.cards.length - 1 ? 14 : 0,
            );
          },
        );
      },
    );
  }
}

/// This card will be user's saved payment card which has `onTap` event
/// by tapping at which the user select's the `payment method`.
class _PaymentCard extends StatelessWidget {
  final dynamic card;
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomRightRadius;
  final double bottomLeftRadius;

  const _PaymentCard({
    Key? key,
    required this.card,
    required this.topLeftRadius,
    required this.topRightRadius,
    required this.bottomLeftRadius,
    required this.bottomRightRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<CheckoutProvider>(context);
    var active = _provider.paymentMethodId == card['id'];

    return InkWell(
      onTap: () {
        if (_provider.paymentMethodId == card['id']) {
          _provider.setPaymentMethodId(null);
        } else {
          _provider.setPaymentMethodId(card['id']);
        }
      },
      child: _buildCardBody(active),
    );
  }

  Widget _buildCardBody(bool active) {
    return Container(
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
      child: _buildCardInfo(),
    );
  }

  Widget _buildCardInfo() {
    var data = card['card'];
    var text =
        "${data['brand']} **** **** **** ${data['last4']} expires ${data['exp_month']}/${data['exp_year']}";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(IconlyLight.wallet),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: DesignSystem.caption,
          ),
        ),
      ],
    );
  }
}
