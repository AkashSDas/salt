import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/cart.dart';
import 'package:salt/providers/products_infinite_scroll.dart';
import 'package:salt/widgets/buttons/index.dart';
import 'package:salt/widgets/product/product_view.dart';
import 'package:shimmer/shimmer.dart';

class ProductsListView extends StatelessWidget {
  const ProductsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductsInfiniteScrollProvider>(context);

    if (_provider.firstLoading) return const _Loader();
    if (_provider.firstError) {
      return Center(
        child: Text(
          _provider.firstApiResponseMsg,
          style: DesignSystem.bodyIntro,
        ),
      );
    }

    return const _ProductsGridView();
  }
}

class _ProductsGridView extends StatelessWidget {
  const _ProductsGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductsInfiniteScrollProvider>(context);
    return GridView.builder(
      itemCount: _provider.products.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.575,
      ),
      itemBuilder: (context, idx) {
        var product = _provider.products[idx];

        return ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: DesignSystem.gallery,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductViewScreen(product: product),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CoverImage(
                      coverImgURL: product.coverImgURLs[0],
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        '\$${product.price}',
                        style: DesignSystem.bodyMain.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 6, right: 6, bottom: 6),
                      child: Flexible(
                        child: Text(
                          product.title,
                          style: DesignSystem.caption,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Builder(builder: (ctx) {
                      final _p = Provider.of<CartProvider>(ctx);
                      return SizedBox(
                        width: double.infinity,
                        child: RoundedCornerButton(
                          onPressed: () async {
                            var prod = product.toJson();
                            prod = {...prod, 'quantity': 1};
                            await _p.saveProductToCart(context, prod);
                          },
                          text: _p.loading ? 'Saving...' : 'Add to cart',
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 8,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.575,
      ),
      itemBuilder: (context, idx) {
        return Shimmer.fromColors(
          key: Key(idx.toString()),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          baseColor: DesignSystem.gallery,
          highlightColor: DesignSystem.alabaster,
        );
      },
    );
  }
}

class _CoverImage extends StatelessWidget {
  final String coverImgURL;
  const _CoverImage({required this.coverImgURL, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 167,
      decoration: BoxDecoration(
        color: DesignSystem.gallery,
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(coverImgURL),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
