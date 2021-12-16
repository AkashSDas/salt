import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salt/models/product/product.dart';
import 'package:salt/models/tag/tag.dart';
import 'package:salt/providers/user_provider.dart';
import 'package:salt/screens/product.dart';
import 'package:salt/services/product.dart';
import 'package:salt/services/tag.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/widgets/common/alert.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';
import 'package:salt/widgets/product/no_product_available.dart';

import '../design_system.dart';

class TagScreen extends StatelessWidget {
  final String tagId;
  TagScreen({required this.tagId, Key? key}) : super(key: key);

  final _service = TagService();
  final _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      children: [
        FutureBuilder(
          future: _service.getTag(tagId),
          builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
            if (!snapshot.hasData) return const SearchLoader();
            final response = snapshot.data;
            if (response == null) return const SearchLoader();
            if (response.error || response.data == null) {
              return const SearchLoader();
            }
            final tag = Tag.fromJson(response.data['tag']);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Center(
                      child: Text(
                        tag.emoji,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${tag.name[0].toUpperCase()}${tag.name.substring(1)}',
                    style: DesignSystem.heading3,
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: DesignSystem.border),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Buy ',
                        style: DesignSystem.heading4,
                        children: [
                          TextSpan(
                            text: tag.name,
                            style: DesignSystem.heading4.copyWith(
                              color: DesignSystem.secondary,
                            ),
                          ),
                          const TextSpan(text: ' product'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder(
                    future: _productService.getProductForTag(tagId, limit: 6),
                    builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
                      if (!snapshot.hasData) return const SearchLoader();
                      final response = snapshot.data;
                      if (response == null) return const SearchLoader();
                      if (response.error || response.data == null) {
                        return const SearchLoader();
                      }
                      final products = response.data['products']
                          .map((p) => Product.fromJson(p))
                          .toList() as List;

                      if (products.isEmpty) return const NoProductAvailable();
                      return Products(products: products);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class Products extends StatelessWidget {
  final List products;
  const Products({required this.products, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 278,
        childAspectRatio: 164 / 278,
        crossAxisSpacing: 7,
        mainAxisSpacing: 8,
      ),
      itemCount: products.length,
      itemBuilder: (BuildContext ctx, idx) => ProductCard(
        product: products[idx],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final dynamic product;
  const ProductCard({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserProvider>(context);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductScreen(product: product),
          ),
        );
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              // fit: StackFit.loose,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(product.coverImgURLs[0]),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: DesignSystem.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(IconlyLight.buy),
                      onPressed: () async {
                        if (_user.token == null) {
                          failedSnackBar(
                              context: context, msg: 'You are not logged in');
                          Navigator.pushNamed(context, '/auth/login');
                        } else {
                          final service = ProductService();
                          var res = await service.saveProductToCart({
                            ...product.toJson(),
                            'quantitySelected': 1,
                          });
                          if (res['error']) {
                            failedSnackBar(context: context, msg: res['msg']);
                          } else {
                            successSnackBar(context: context, msg: res['msg']);
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
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
}
