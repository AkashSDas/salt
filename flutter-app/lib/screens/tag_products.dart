import 'package:flutter/material.dart';
import 'package:salt/models/product/product.dart';
import 'package:salt/screens/tag.dart';
import 'package:salt/services/product.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';
import 'package:salt/widgets/drawer/drawer_body.dart';

import '../design_system.dart';

class TagProductsScreen extends StatelessWidget {
  final _service = ProductService();
  final String tagId;
  TagProductsScreen({required this.tagId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      children: [
        FutureBuilder(
          future: _service.getProductForTag(tagId),
          builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
            if (!snapshot.hasData) return const SearchLoader();
            final response = snapshot.data;
            if (response == null) return const SearchLoader();
            if (response.error || response.data == null) {
              return const SearchLoader();
            }

            final products = response.data['products']
                .map((prod) => Product.fromJson(prod))
                .toList();

            if (products.isEmpty) {
              return Column(
                children: [
                  const LogoTV(),
                  const SizedBox(height: 20),
                  Text(
                    'No products available for this category',
                    style: DesignSystem.bodyMain,
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: 'Shop something else',
                    horizontalPadding: 32,
                    onPressed: () => Navigator.pushNamed(context, '/products'),
                  ),
                ],
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Products(products: products),
            );
          },
        ),
      ],
    );
  }
}
