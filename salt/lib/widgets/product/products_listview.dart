import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/products_infinite_scroll.dart';

class ProductsListView extends StatelessWidget {
  const ProductsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductsInfiniteScrollProvider>(context);

    if (_provider.firstLoading) return const CircularProgressIndicator();
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
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, idx) {
        var product = _provider.products[idx];

        return Container(
          decoration: BoxDecoration(
            color: DesignSystem.gallery,
            borderRadius: BorderRadius.circular(16),
          ),
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
                padding: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
                child: Flexible(
                  child: Text(
                    product.title,
                    style: DesignSystem.caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
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
