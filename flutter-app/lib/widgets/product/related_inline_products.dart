import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/product/product.dart';
import 'package:salt/models/tag/tag.dart';
import 'package:salt/screens/product.dart';
import 'package:salt/screens/tag.dart';
import 'package:salt/services/product.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/widgets/animations/reveal.dart';
import 'package:shimmer/shimmer.dart';

/// Related products
///
/// If [tags] is empty list then it will display latest products having any tag.
/// If [productId] is given then the resulted products will filter out post with [productId]
class RelatedInlineProducts extends StatelessWidget {
  final List<Tag> tags;
  final String? productId;

  const RelatedInlineProducts({
    Key? key,
    required this.tags,
    this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RevealAnimation(
          child: Text('Related products', style: DesignSystem.heading3),
          startAngle: 10,
          delay: 100,
          startYOffset: 60,
          duration: 1000,
        ),
        DesignSystem.spaceH20,
        _InlineProducts(tags: tags, productId: productId),
      ],
    );
  }
}

/// Inline tag products
class _InlineProducts extends StatelessWidget {
  final _service = ProductService();
  final List<Tag> tags;
  final String? productId;

  _InlineProducts({
    required this.tags,
    this.productId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _service.getRelatedProducts(tags, 10),
      builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
        if (!snapshot.hasData) return const InlineTagProductsLoader();
        var response = snapshot.data!;
        if (response.error || response.data == null) {
          return const InlineTagProductsLoader();
        }

        List<Product> products = [];
        for (int i = 0; i < response.data['products'].length; i++) {
          if (productId != response.data['products'][i]['id']) {
            products.add(Product.fromJson(response.data['products'][i]));
          }
        }

        return SizedBox(
          height: 300,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, idx) => _ProductCard(product: products[idx]),
            separatorBuilder: (context, idx) => const SizedBox(width: 16),
          ),
        );
      },
    );
  }
}

/// Product cart with add to cart btn
class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product, Key? key}) : super(key: key);

  void _navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigate(context),
      child: Container(
        height: 300,
        width: 180,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _builderHeader(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                product.price.toString(),
                style: const TextStyle(
                  color: DesignSystem.success,
                  fontSize: 20,
                  fontFamily: DesignSystem.fontHighlight,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                product.title,
                style: DesignSystem.caption.copyWith(
                  color: DesignSystem.text1,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImg() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(product.coverImgURLs[0]),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
    );
  }

  Widget _builderHeader() {
    return Stack(
      children: [
        _buildCoverImg(),
        ProductCardAddToCartButton(product: product),
      ],
    );
  }
}

/// Inline tag products loader
class InlineTagProductsLoader extends StatelessWidget {
  const InlineTagProductsLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, idx) => const InlineProductCardLoader(),
        separatorBuilder: (context, idx) => const SizedBox(width: 16),
      ),
    );
  }
}

/// Inline product card loader
class InlineProductCardLoader extends StatelessWidget {
  const InlineProductCardLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Container(
        height: 300,
        width: 180,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      baseColor: DesignSystem.shimmerBaseColor,
      highlightColor: DesignSystem.shimmerHighlightColor,
    );
  }
}
