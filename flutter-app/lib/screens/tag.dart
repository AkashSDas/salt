import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/post/post.dart';
import 'package:salt/models/product/product.dart';
import 'package:salt/models/tag/tag.dart';
import 'package:salt/providers/user_provider.dart';
import 'package:salt/screens/product.dart';
import 'package:salt/screens/tag_products.dart';
import 'package:salt/services/post.dart';
import 'package:salt/services/product.dart';
import 'package:salt/services/tag.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/widgets/common/alert.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/common/divider.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';
import 'package:salt/widgets/post/big_post.dart';
import 'package:salt/widgets/post/no_post_available.dart';
import 'package:salt/widgets/product/no_product_available.dart';

class TagScreen extends StatelessWidget {
  final String tagId;
  TagScreen({required this.tagId, Key? key}) : super(key: key);

  final _service = TagService();

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
                  _buildEmojiCard(context, tag.emoji),
                  DesignSystem.spaceH20,
                  Text(
                    '${tag.name[0].toUpperCase()}${tag.name.substring(1)}',
                    style: DesignSystem.heading3,
                  ),
                  DesignSystem.spaceH40,
                  TagLimitedProducts(tagId: tagId, tagName: tag.name),
                  DesignSystem.spaceH40,
                  TagLimitedPosts(tagId: tagId, tagName: tag.name),
                  DesignSystem.spaceH40,
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmojiCard(BuildContext context, String emoji) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor,
      ),
      child: Center(
        child: Text(emoji, style: const TextStyle(fontSize: 40)),
      ),
    );
  }
}

/// Display limited posts
class TagLimitedPosts extends StatelessWidget {
  final _service = PostService();
  final String tagId;
  final String tagName;

  TagLimitedPosts({
    required this.tagId,
    required this.tagName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _service.getPostsForTag(tagId, limit: 6),
      builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
        if (!snapshot.hasData) return const SearchLoader();
        final response = snapshot.data;
        if (response == null) return const SearchLoader();
        if (response.error || response.data == null) {
          return const SearchLoader();
        }

        List<Post> posts = [];
        for (int i = 0; i < response.data['posts'].length; i++) {
          posts.add(Post.fromJson(response.data['posts'][i]));
        }

        if (posts.isEmpty) return const NoPostAvailable();
        return Column(
          children: [
            _buildHeading(tagName),
            DesignSystem.spaceH20,
            const DashedSeparator(height: 1.6),
            DesignSystem.spaceH20,
            Posts(posts: posts),
            DesignSystem.spaceH20,
            _buildSeeMoreBtn(context),
          ],
        );
      },
    );
  }

  Widget _buildSeeMoreBtn(BuildContext context) {
    return Center(
      child: SecondaryButton(
        text: 'See more...',
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => TagProductsScreen(
          //       tagId: tagId,
          //     ),
          //   ),
          // );
        },
        horizontalPadding: 64,
      ),
    );
  }

  Widget _buildHeading(String name) {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Read articles on ',
          style: DesignSystem.heading4,
          children: [
            TextSpan(
              text: name,
              style: DesignSystem.heading4.copyWith(
                color: DesignSystem.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Posts listview
class Posts extends StatelessWidget {
  final List<Post> posts;
  const Posts({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: posts.length,
        itemBuilder: (context, idx) {
          return AnimationConfiguration.staggeredList(
            position: idx,
            duration: const Duration(milliseconds: 375),
            delay: const Duration(milliseconds: 600),
            child: SlideAnimation(
              horizontalOffset: -100,
              child: FadeInAnimation(
                child: BigPostCard(post: posts[idx]),
              ),
            ),
          );
        },
        separatorBuilder: (context, idx) => DesignSystem.spaceH20,
      ),
    );
  }
}

/// Display limited products
class TagLimitedProducts extends StatelessWidget {
  final _service = ProductService();
  final String tagId;
  final String tagName;

  TagLimitedProducts({
    required this.tagId,
    required this.tagName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _service.getProductForTag(tagId, limit: 6),
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
        return Column(
          children: [
            _buildBuyProductHeading(tagName),
            DesignSystem.spaceH20,
            const DashedSeparator(height: 1.6),
            DesignSystem.spaceH20,
            Products(products: products),
            DesignSystem.spaceH20,
            _buildSeeMoreBtn(context),
          ],
        );
      },
    );
  }

  Widget _buildSeeMoreBtn(BuildContext context) {
    return Center(
      child: SecondaryButton(
        text: 'See more...',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TagProductsScreen(
                tagId: tagId,
                tagName: tagName,
              ),
            ),
          );
        },
        horizontalPadding: 64,
      ),
    );
  }

  Widget _buildBuyProductHeading(String name) {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Buy ',
          style: DesignSystem.heading4,
          children: [
            TextSpan(
              text: name,
              style: DesignSystem.heading4.copyWith(
                color: DesignSystem.secondary,
              ),
            ),
            const TextSpan(text: ' product'),
          ],
        ),
      ),
    );
  }
}

/// Products grid view
class Products extends StatelessWidget {
  final List products;
  const Products({required this.products, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 278,
          childAspectRatio: 164 / 278,
          crossAxisSpacing: 7,
          mainAxisSpacing: 8,
        ),
        itemCount: products.length,
        itemBuilder: (BuildContext ctx, idx) {
          return AnimationConfiguration.staggeredGrid(
            position: idx,
            duration: const Duration(milliseconds: 375),
            delay: const Duration(milliseconds: 100),
            columnCount: products.length,
            child: ScaleAnimation(
              curve: Curves.easeOut,
              child: FadeInAnimation(
                curve: Curves.easeOut,
                child: ProductCard(
                  product: products[idx],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Product cart with add to cart btn
class ProductCard extends StatelessWidget {
  final dynamic product;
  const ProductCard({required this.product, Key? key}) : super(key: key);

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
        _ProductCardAddToCartButton(product: product),
      ],
    );
  }
}

/// Add to cart btn for product cart
class _ProductCardAddToCartButton extends StatelessWidget {
  final Product product;

  const _ProductCardAddToCartButton({
    required this.product,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
        child: _buildIconBtn(context),
      ),
    );
  }

  Widget _buildIconBtn(BuildContext context) {
    final _user = Provider.of<UserProvider>(context);

    return IconButton(
      icon: const Icon(IconlyLight.buy),
      onPressed: () async {
        if (_user.token == null) {
          failedSnackBar(context: context, msg: 'You are not logged in');
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
    );
  }
}
