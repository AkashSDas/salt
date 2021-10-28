import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/product/product.dart';
import 'package:salt/providers/cart.dart';
import 'package:salt/providers/product_quantity.dart';
import 'package:salt/widgets/alerts/index.dart';
import 'package:salt/widgets/animated_drawer/animated_drawer.dart';
import 'package:salt/widgets/buttons/index.dart';

class ProductViewScreen extends StatelessWidget {
  final Product product;
  const ProductViewScreen({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductQuantityProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: AnimatedDrawer(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Text(product.title, style: DesignSystem.heading1),
              const SizedBox(height: 16),
              _CoverImages(product: product),
              const SizedBox(height: 16),
              _QuantitiesLeft(quantityLeft: product.quantityLeft),
              const SizedBox(height: 16),
              _Details(description: product.description),
              const SizedBox(height: 16),
              _PriceAndQuantity(
                price: product.price,
                quantityLeft: product.quantityLeft,
              ),
              const SizedBox(height: 16),
              _AddToCartButton(product: product),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  final Product product;
  const _AddToCartButton({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _quantityProivder = Provider.of<ProductQuantityProvider>(context);
    final _cartProvider = Provider.of<CartProvider>(context);

    return RoundedCornerButton(
      verticalPadding: 24,
      onPressed: () async {
        if (_quantityProivder.quantity < 0) {
          failedSnackBar(context: context, msg: 'Increase quantity');
          return;
        } else if (_quantityProivder.quantity > product.quantityLeft) {
          failedSnackBar(
            context: context,
            msg: '${product.quantityLeft} left, decrease your quantity',
          );
          return;
        }

        var prod = product.toJson();
        prod = {...prod, 'quantity': _quantityProivder.quantity};
        await _cartProvider.saveProductToCart(context, prod);
      },
      text: _cartProvider.loading ? 'Adding...' : 'Add to cart',
    );
  }
}

class _PriceAndQuantity extends StatelessWidget {
  final double price;
  final int quantityLeft;

  const _PriceAndQuantity({
    required this.price,
    required this.quantityLeft,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '\$$price',
            style: DesignSystem.bodyIntro.copyWith(fontSize: 40),
          ),
          _QuantityButton(quantityLeft: quantityLeft),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final int quantityLeft;

  const _QuantityButton({
    required this.quantityLeft,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<ProductQuantityProvider>(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: DesignSystem.gallery)),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (_p.quantity > 0) {
                _p.decrement();
              }
            },
            icon: const Icon(Icons.remove),
          ),
          const SizedBox(width: 16),
          Text(
            _p.quantity.toString(),
            style: DesignSystem.bodyIntro.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              if (_p.quantity < quantityLeft) {
                _p.increment();
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class _Details extends StatelessWidget {
  final String description;
  const _Details({required this.description, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Details',
            style: DesignSystem.heading4.copyWith(fontSize: 17),
          ),
          const SizedBox(height: 4),
          Text(description, style: DesignSystem.bodyMain),
        ],
      ),
    );
  }
}

class _QuantitiesLeft extends StatelessWidget {
  final int quantityLeft;

  const _QuantitiesLeft({
    required this.quantityLeft,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      alignment: Alignment.centerRight,
      child: RoundedCornerIconButton(
        horizontalPadding: 32,
        onPressed: () {},
        text: '$quantityLeft left',
        icon: const SizedBox(
          height: 24,
          width: 24,
          child: AspectRatio(
            aspectRatio: 1,
            child: FlareActor('assets/flare-icons/bag.flr'),
          ),
        ),
      ),
    );
  }
}

class _CoverImages extends StatelessWidget {
  final Product product;
  final PageController _ctrl = PageController(viewportFraction: 0.9);
  _CoverImages({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: product.coverImgURLs.length,
        controller: _ctrl,
        clipBehavior: Clip.none,
        itemBuilder: (context, idx) {
          return Container(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: InteractiveViewer(
              child: Container(
                decoration: BoxDecoration(
                  color: DesignSystem.gallery,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(product.coverImgURLs[idx]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
