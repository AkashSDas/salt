import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/cart_product.dart/cart_product.dart';
import 'package:salt/providers/cart.dart';
import 'package:salt/services/product.dart';
import 'package:salt/widgets/common/alert.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';
import 'package:salt/widgets/drawer/drawer_body.dart';

class UserCartScreen extends StatelessWidget {
  const UserCartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      children: [
        const SizedBox(height: 20),
        Text(
          'My cart',
          style: DesignSystem.heading4,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: const CartProductsListView(),
        ),
      ],
    );
  }
}

class CartProductsListView extends StatelessWidget {
  const CartProductsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<CartProvider>(context);

    return FutureBuilder(
      future: _provider.getCartProducts(),
      builder: (context, AsyncSnapshot<List<CartProduct>> snapshot) {
        if (!snapshot.hasData) return const SearchLoader();
        if (_provider.products.isEmpty) {
          return Column(
            children: [
              const LogoTV(),
              const SizedBox(height: 20),
              Text('Your cart is empty', style: DesignSystem.bodyMain),
              const SizedBox(height: 20),
              PrimaryButton(
                text: 'Shop',
                horizontalPadding: 128,
                onPressed: () {
                  /// TODO: Push to products screen
                },
              ),
            ],
          );
        }

        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _provider.products.length,
              itemBuilder: (context, idx) {
                return CartProductCard(
                  product: _provider.products[idx],
                  idx: idx,
                );
              },
            ),
            const SizedBox(height: 40),
            PrimaryButton(
              text: 'Checkout',
              horizontalPadding: 64,
              onPressed: () {
                Navigator.pushNamed(context, '/user/checkout');
              },
            ),
          ],
        );
      },
    );
  }
}

class CartProductCard extends StatelessWidget {
  final CartProduct product;
  final int idx;

  const CartProductCard({
    required this.product,
    required this.idx,
    Key? key,
  }) : super(key: key);

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
          Container(
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
          ),
          const SizedBox(width: 8),
          Flexible(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CartProductDeleteButton(id: product.id),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: DesignSystem.card,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_provider.products[idx].quantitySelected >
                                  1) {
                                _provider.updateCartProductQuantity(
                                    product.id, -1);
                              }
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            _provider.products[idx].quantitySelected.toString(),
                            style: DesignSystem.bodyIntro.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            onPressed: () {
                              if (_provider.products[idx].quantitySelected <
                                  product.quantityLeft) {
                                _provider.updateCartProductQuantity(
                                    product.id, 1);
                              }
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
