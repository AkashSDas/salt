import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/product/product.dart';
import 'package:salt/providers/product.dart';
import 'package:salt/providers/user_provider.dart';
import 'package:salt/services/product.dart';
import 'package:salt/widgets/common/alert.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/common/markdown.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';
import 'package:salt/widgets/product/related_inline_products.dart';

class ProductScreen extends StatelessWidget {
  final Product product;
  const ProductScreen({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductProvider(price: product.price),
      child: AnimateAppBarOnScroll(
        children: [
          DesignSystem.spaceH20,
          _CoverImgsSlideshow(imgs: product.coverImgURLs),
          DesignSystem.spaceH20,
          Padding(
            padding: const EdgeInsets.all(16).copyWith(top: 0),
            child: Column(
              children: [
                Text(product.title, style: DesignSystem.heading4),
                DesignSystem.spaceH20,
                MarkdownContent(
                  text: product.description,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                ),
                DesignSystem.spaceH20,
                MarkdownContent(
                  text: product.info,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                ),
                DesignSystem.spaceH20,
                ProductToCart(product: product),
                DesignSystem.spaceH40,
                RelatedInlineProducts(
                  tags: product.tags,
                  productId: product.id,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Product price and quantity section

class ProductToCart extends StatefulWidget {
  final Product product;
  const ProductToCart({required this.product, Key? key}) : super(key: key);

  @override
  _ProductToCartState createState() => _ProductToCartState();
}

class _ProductToCartState extends State<ProductToCart> {
  Widget _buildPrice(BuildContext context) {
    final _provider = Provider.of<ProductProvider>(context);

    return Text(
      _provider.displayPrice.toString(),
      style: const TextStyle(
        color: DesignSystem.success,
        fontFamily: DesignSystem.fontHighlight,
        fontWeight: FontWeight.w400,
        fontSize: 40,
      ),
    );
  }

  Widget _buildQuantityUpdateBtns(BuildContext context) {
    final _provider = Provider.of<ProductProvider>(context);

    var decrementIcon = IconButton(
      onPressed: () {
        if (_provider.quantity > 1) _provider.updateProductQuantity(-1);
      },
      icon: const Icon(Icons.remove),
    );

    var space = const SizedBox(width: 16);

    var incrementIcon = IconButton(
      onPressed: () {
        if (_provider.quantity < widget.product.quantityLeft) {
          _provider.updateProductQuantity(1);
        }
      },
      icon: const Icon(Icons.add),
    );

    return Row(
      children: [
        decrementIcon,
        space,
        Text(
          _provider.quantity.toString(),
          style: DesignSystem.bodyIntro.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        space,
        incrementIcon,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPrice(context),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: DesignSystem.card,
              ),
              child: _buildQuantityUpdateBtns(context),
            ),
          ],
        ),
        DesignSystem.spaceH20,
        _AddToCartButton(product: widget.product),
      ],
    );
  }
}

/// Add to cart btn
class _AddToCartButton extends StatelessWidget {
  final Product product;
  const _AddToCartButton({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductProvider>(context);
    final _user = Provider.of<UserProvider>(context);

    return PrimaryButton(
      text: _provider.loading ? 'Saving...' : 'Add to cart',
      onPressed: () async {
        if (_user.token == null) {
          failedSnackBar(context: context, msg: 'You are not logged in');
          Navigator.pushNamed(context, '/auth/login');
        } else {
          final _service = ProductService();
          _provider.updateLoading(true);
          var response = await _service.saveProductToCart({
            ...product.toJson(),
            'quantitySelected': _provider.quantity,
          });
          _provider.updateLoading(false);

          if (response['error']) {
            failedSnackBar(context: context, msg: response['msg']);
          } else {
            successSnackBar(context: context, msg: response['msg']);
          }
        }
      },
      horizontalPadding: 64,
    );
  }
}

/// Cover img carousel

class _CoverImgsSlideshow extends StatefulWidget {
  final List<String> imgs;
  const _CoverImgsSlideshow({required this.imgs, Key? key}) : super(key: key);

  @override
  State<_CoverImgsSlideshow> createState() => _CoverImgsSlideshowState();
}

class _CoverImgsSlideshowState extends State<_CoverImgsSlideshow> {
  int imgIdx = 0;

  Widget _buildCoverImg() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.imgs[imgIdx]),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.imgs.length,
        itemBuilder: (context, idx) {
          return _buildCarouselImgCard(idx);
        },
      ),
    );
  }

  Widget _buildCarouselImgCard(int idx) {
    var current = imgIdx == idx;

    return InkWell(
      onTap: () => setState(() => imgIdx = idx),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildCarouselImgCardBorder(idx, current),
          Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.only(
              right: idx + 1 == widget.imgs.length ? 0 : 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: DesignSystem.border,
                width: current ? 1.5 : 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselImgCardBorder(int idx, bool current) {
    return Container(
      height: current ? 90 : 100,
      width: current ? 90 : 100,
      margin: EdgeInsets.only(
        right: idx + 1 == widget.imgs.length ? 0 : 10,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.imgs[idx]),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(current ? 16 : 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildCoverImg(),
          DesignSystem.spaceH20,
          _buildCarousel(),
        ],
      ),
    );
  }
}
