import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/product/product.dart';
import 'package:salt/screens/tag.dart';
import 'package:salt/services/product.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/common/cool.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';

class TagProductsScreen extends StatelessWidget {
  final _service = ProductService();
  final String tagId;
  TagProductsScreen({required this.tagId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      children: [
        Text('Shop', style: DesignSystem.heading3, textAlign: TextAlign.center),
        DesignSystem.spaceH40,
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

            if (products.isEmpty) return const _NoProductsAvailable();

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Products(products: products),
            );
          },
        ),
      ],
    );
  }
}

/// No products available
class _NoProductsAvailable extends StatelessWidget {
  const _NoProductsAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LogoTV(),
        DesignSystem.spaceH20,
        Text(
          'No products available for this category',
          style: DesignSystem.bodyMain,
        ),
        DesignSystem.spaceH20,
        PrimaryButton(
          text: 'Shop something else',
          horizontalPadding: 32,
          onPressed: () => Navigator.pushNamed(context, '/products'),
        ),
      ],
    );
  }
}
