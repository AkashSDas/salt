import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/cart_product/cart_product.dart';
import 'package:salt/providers/cart.dart';
import 'package:salt/providers/payment.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/widgets/alerts/index.dart';
import 'package:salt/widgets/buttons/index.dart';
import 'package:shimmer/shimmer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<UserCartProvider>(
        context,
        listen: false,
      ).getAll(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<UserCartProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('My Cart', style: DesignSystem.heading4),
          const SizedBox(height: 16),
          _p.loading ? const _Loader() : const _CartProductsListView(),
          const SizedBox(height: 16),
          _PaymentSection(),
        ],
      ),
    );
  }
}

class _PaymentSection extends StatelessWidget {
  final _ctrl = CardEditController();
  _PaymentSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PaymentProvider(),
      child: Expanded(
        child: Column(
          children: [
            CardField(
              controller: _ctrl,
              cursorColor: DesignSystem.tundora,
              style: DesignSystem.bodyMain,
              decoration: InputDecoration(
                fillColor: DesignSystem.gallery,
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
                  color: DesignSystem.tundora.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Builder(builder: (context) {
              final _p = Provider.of<PaymentProvider>(context);
              final _user = Provider.of<UserProvider>(context);
              final _cart = Provider.of<UserCartProvider>(context);

              return SizedBox(
                width: double.infinity,
                child: RoundedCornerButton(
                  onPressed: () async {
                    if (!_ctrl.complete) {
                      failedSnackBar(
                        context: context,
                        msg: 'Fill card information',
                      );
                      return;
                    }

                    /// User data
                    final details = BillingDetails(
                      email: _user.user?.email ?? '',

                      /// TODO: Add address and other infos here
                    );

                    /// create payment method
                    final paymentMethod =
                        await Stripe.instance.createPaymentMethod(
                      PaymentMethodParams.card(billingDetails: details),
                    );

                    /// amount
                    double amount = 0;
                    for (var prod in _cart.products) {
                      amount += prod.price * prod.quantity;
                    }

                    await _p.checkout(
                      context,
                      _user.user!.id,
                      _user.token.toString(),
                      amount,
                      paymentMethod.id,
                    );
                  },
                  text: _p.loading ? 'Loading...' : 'Checkout',
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 94,
      child: ListView.builder(
          clipBehavior: Clip.none,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: 4,
          itemBuilder: (context, idx) {
            return Shimmer.fromColors(
              key: Key(idx.toString()),
              child: Container(
                height: 343,
                margin: const EdgeInsets.only(right: 24),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              baseColor: DesignSystem.gallery,
              highlightColor: DesignSystem.alabaster,
            );
          }),
    );
  }
}

class _CartProductsListView extends StatelessWidget {
  const _CartProductsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<UserCartProvider>(context);

    return ListView.separated(
      separatorBuilder: (context, idx) {
        return const SizedBox(height: 24);
      },
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: _p.products.length,
      itemBuilder: (context, idx) {
        CartProduct _product = _p.products[idx];
        return _Card(product: _product);
      },
    );
  }
}

class _Card extends StatelessWidget {
  final CartProduct product;
  const _Card({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CoverImage(imgURL: product.coverImgURLs[0]),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Title(title: product.title),
              const SizedBox(height: 8),
              _Price(price: product.price),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _QuantityButton(product: product),
                  const SizedBox(width: 20),
                  _RemoveButton(product: product),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CoverImage extends StatelessWidget {
  final String imgURL;
  const _CoverImage({required this.imgURL, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 130,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: DesignSystem.gallery,
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imgURL),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  const _Title({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: DesignSystem.heading4.copyWith(fontSize: 17),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _Price extends StatelessWidget {
  final double price;
  const _Price({required this.price, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      price.toString(),
      style: DesignSystem.bodyIntro.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final CartProduct product;
  const _QuantityButton({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<UserCartProvider>(context);

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: DesignSystem.tundora),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                _p.updateProductQuantity(context, product.id, -1);
              },
              icon: const Icon(Icons.remove),
            ),
            const SizedBox(width: 16),
            Text(
              product.quantity.toString(),
              style: DesignSystem.bodyIntro.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () {
                _p.updateProductQuantity(context, product.id, 1);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  final CartProduct product;
  const _RemoveButton({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<UserCartProvider>(context);

    return Container(
      decoration: BoxDecoration(
          // color: DesignSystem.gallery,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: DesignSystem.tundora)),
      child: IconButton(
        onPressed: () {
          _p.removeProduct(product.id);

          successSnackBar(
            context: context,
            msg: 'Successfully removed item',
          );
        },
        icon: const SizedBox(
          height: 24,
          width: 24,
          child: AspectRatio(
            aspectRatio: 1,
            child: FlareActor(
              'assets/flare-icons/delete.flr',
              animation: 'idle',
              alignment: Alignment.center,
            ),
          ),
        ),
      ),
    );
  }
}
