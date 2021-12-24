import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/cart_product.dart/cart_product.dart';
import 'package:salt/providers/cart.dart';
import 'package:salt/services/product.dart';
import 'package:salt/widgets/common/alert.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/common/cool.dart';
import 'package:salt/widgets/common/divider.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';

class UserCartScreen extends StatelessWidget {
  const UserCartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('My cart', style: DesignSystem.heading1),
        ),
        DesignSystem.spaceH20,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: DashedSeparator(height: 1.6),
        ),
        DesignSystem.spaceH20,
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: const CartProductsListView(),
        ),
      ],
    );
  }
}

/// Display cart products
class CartProductsListView extends StatelessWidget {
  const CartProductsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<CartProvider>(context);

    return FutureBuilder(
      future: _provider.getCartProducts(),
      builder: (context, AsyncSnapshot<List<CartProduct>> snapshot) {
        if (!snapshot.hasData) return const SearchLoader();
        if (_provider.products.isEmpty) return const _EmptyCart();

        return Column(
          children: [
            AnimationLimiter(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _provider.products.length,
                itemBuilder: (context, idx) {
                  return AnimationConfiguration.staggeredList(
                    position: idx,
                    duration: const Duration(milliseconds: 375),
                    delay: const Duration(milliseconds: 300),
                    child: SlideAnimation(
                      horizontalOffset: -100,
                      child: FadeInAnimation(
                        child: CartProductCard(
                          product: _provider.products[idx],
                          idx: idx,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            DesignSystem.spaceH40,
            PrimaryButton(
              text: 'Checkout',
              horizontalPadding: 64,
              onPressed: () {
                Navigator.pushNamed(context, '/user/checkout');
              },
            ),
            DesignSystem.spaceH40,
          ],
        );
      },
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
        DesignSystem.spaceH20,
        Text('Your cart is empty', style: DesignSystem.bodyMain),
        DesignSystem.spaceH20,
        PrimaryButton(
          text: 'Shop',
          horizontalPadding: 128,
          onPressed: () => Navigator.pushNamed(context, '/products'),
        ),
      ],
    );
  }
}

/// Cart product card
class CartProductCard extends StatelessWidget {
  final int idx;
  final CartProduct product;

  const CartProductCard({
    required this.idx,
    required this.product,
    Key? key,
  }) : super(key: key);

  Widget _buildImg() {
    return Container(
      height: 150,
      width: 126,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: DesignSystem.primary,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(product.coverImgURLs[0]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<CartProvider>(context);

    return Container(
      height: 182,
      padding: const EdgeInsets.all(8),
      margin: EdgeInsets.only(
        bottom: _provider.products.length == idx + 1 ? 0 : 20,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: DesignSystem.border, width: 1.5),
        borderRadius: BorderRadius.circular(20),
        color: DesignSystem.primary,
      ),
      child: Row(
        children: [
          _buildImg(),
          const SizedBox(width: 8),
          CartProductCardInfoAndActions(idx: idx, product: product),
        ],
      ),
    );
  }
}

/// Cart product card info and actions
class CartProductCardInfoAndActions extends StatelessWidget {
  final int idx;
  final CartProduct product;

  const CartProductCardInfoAndActions({
    required this.idx,
    required this.product,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            style: DesignSystem.bodyMain.copyWith(
              color: DesignSystem.text1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Text(
            '${product.price * product.quantitySelected}',
            style: const TextStyle(
              color: DesignSystem.success,
              fontFamily: DesignSystem.fontHighlight,
              fontWeight: FontWeight.w400,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 10),
          CartProductCardActions(idx: idx, product: product)
        ],
      ),
    );
  }
}

/// Cart product card actions
class CartProductCardActions extends StatelessWidget {
  final int idx;
  final CartProduct product;

  const CartProductCardActions({
    required this.idx,
    required this.product,
    Key? key,
  }) : super(key: key);

  Widget _buildCartUpdateQuantityBtn(BuildContext context) {
    final _provider = Provider.of<CartProvider>(context);

    var incrementBtn = IconButton(
      onPressed: () {
        if (_provider.products[idx].quantitySelected > 1) {
          _provider.updateCartProductQuantity(product.id, -1);
        }
      },
      icon: const Icon(Icons.remove),
    );

    var decrementBtn = IconButton(
      onPressed: () {
        if (_provider.products[idx].quantitySelected < product.quantityLeft) {
          _provider.updateCartProductQuantity(product.id, 1);
        }
      },
      icon: const Icon(Icons.add),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: DesignSystem.card,
      ),
      child: Row(
        children: [
          incrementBtn,
          const SizedBox(width: 16),
          Text(
            _provider.products[idx].quantitySelected.toString(),
            style: DesignSystem.bodyIntro.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 16),
          decrementBtn,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CartProductDeleteButton(id: product.id),
        const SizedBox(height: 16),
        _buildCartUpdateQuantityBtn(context),
      ],
    );
  }
}

/// Delete product from cart btn
class CartProductDeleteButton extends StatelessWidget {
  final String id;
  final _service = ProductService();
  CartProductDeleteButton({required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<CartProvider>(context);

    return Container(
      decoration: const BoxDecoration(
        color: DesignSystem.card,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () async {
          final res = await _service.removeProductFromCart(id);

          if (res['error']) {
            failedSnackBar(context: context, msg: res['msg']);
          } else {
            _provider.updateProducts(
              _provider.products.where((prod) => prod.id != id).toList(),
            );
            successSnackBar(context: context, msg: res['msg']);
          }
        },
        icon: const Icon(IconlyLight.delete),
      ),
    );
  }
}
