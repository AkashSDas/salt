import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/product/product.dart';
import 'package:salt/screens/tag.dart';
import 'package:salt/services/product.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/widgets/animations/translate.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/common/cool.dart';
import 'package:salt/widgets/common/divider.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';
import 'package:spring/spring.dart';

class TagProductsScreen extends StatelessWidget {
  final _service = ProductService();
  final String tagId;
  final String tagName;

  TagProductsScreen({
    required this.tagId,
    required this.tagName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      children: [
        _TagProductsHeading(tagName: tagName),
        DesignSystem.spaceH20,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: DashedSeparator(height: 1.6),
        ),
        DesignSystem.spaceH20,
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

/// Tag products heading

class _TagProductsHeading extends StatefulWidget {
  final String tagName;
  const _TagProductsHeading({Key? key, required this.tagName})
      : super(key: key);

  @override
  __TagProductsHeadingState createState() => __TagProductsHeadingState();
}

class __TagProductsHeadingState extends State<_TagProductsHeading>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildAnimation(
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Shop ',
          style: DesignSystem.heading2,
          children: [
            TextSpan(
              text: ' ${widget.tagName}',
              style: DesignSystem.heading2.copyWith(
                color: DesignSystem.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimation(Widget child) {
    return Spring.rotate(
      startAngle: 30,
      endAngle: 0,
      animDuration: const Duration(milliseconds: 1000),
      delay: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: TranslateAnimation(
        child: child,
        duration: const Duration(milliseconds: 1000),
        delay: const Duration(milliseconds: 100),
        beginOffset: const Offset(0, 60),
        endOffset: const Offset(0, 0),
        curve: Curves.easeInOut,
      ),
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
