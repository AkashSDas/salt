import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/post/post.dart';
import 'package:salt/models/product/product.dart';
import 'package:salt/models/tag/tag.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/providers/search_provider.dart';
import 'package:salt/screens/product.dart';
import 'package:salt/screens/search_posts.dart';
import 'package:salt/screens/search_products.dart';
import 'package:salt/screens/tag.dart';
import 'package:salt/services/post.dart';
import 'package:salt/services/product.dart';
import 'package:salt/services/tag.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/widgets/common/cool.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animated_drawer.dart';
import 'package:salt/widgets/others/scroll_behavior.dart';
import 'package:salt/widgets/post/big_post.dart';
import 'package:salt/widgets/product/related_inline_products.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      child: ChangeNotifierProvider(
        create: (context) => SearchProvider(),
        child: const _SearchListView(),
      ),
    );
  }
}

/// List view

class _SearchListView extends StatefulWidget {
  const _SearchListView({Key? key}) : super(key: key);

  @override
  __SearchListViewState createState() => __SearchListViewState();
}

class __SearchListViewState extends State<_SearchListView> {
  final ScrollController _ctrl = ScrollController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _ctrl.addListener(() {
        var pixels = _ctrl.position.pixels;
        if (pixels >= 0) {
          /// Listview has be scrolled (when == 0 you're at top)
          Provider.of<AnimatedDrawerProvider>(
            context,
            listen: false,
          ).animateAppBar(pixels);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoHighlightBehavior(),
      child: ListView(
        controller: _ctrl,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const _SearchInputField(),
          DesignSystem.spaceH20,
          const TagsInlineView(),
          DesignSystem.spaceH20,
          const _NotFound(),
          const _InlineProducts(),
          DesignSystem.spaceH20,
          const _Posts(),
        ],
      ),
    );
  }
}

/// Not found
class _NotFound extends StatelessWidget {
  const _NotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<SearchProvider>(context);

    if (_p.postsNotFound && _p.productsNotFound) {
      return const SizedBox(
        height: 300,
        child: Center(
          child: Text(
            'No results found',
            style: TextStyle(
              color: DesignSystem.text1,
              fontSize: 17,
              fontFamily: DesignSystem.fontHighlight,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }

    return const SizedBox();
  }
}

/// Search Input field
class _SearchInputField extends StatelessWidget {
  const _SearchInputField({Key? key}) : super(key: key);

  InputDecoration _inputDecoration(BuildContext context) {
    final _p = Provider.of<SearchProvider>(context);

    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(width: 0, style: BorderStyle.none),
    );

    var hintStyle = DesignSystem.bodyIntro.copyWith(
      color: DesignSystem.placeholder,
    );
    var errorStyle = DesignSystem.caption.copyWith(
      color: DesignSystem.error,
    );

    return InputDecoration(
      fillColor: Theme.of(context).cardColor,
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintText: 'Search...',
      border: border,
      hintStyle: hintStyle,
      errorStyle: errorStyle,
      suffixIcon: InkWell(
        onTap: () async {
          await _p.searchForQuery();
        },
        child: const Icon(IconlyLight.search, color: DesignSystem.icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<SearchProvider>(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextFormField(
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.text,
        onChanged: (value) => _p.setQuery(value),
        onFieldSubmitted: (value) async {
          await _p.searchForQuery();
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: _inputDecoration(context),
        cursorColor: Theme.of(context).colorScheme.secondary,
        style: DesignSystem.bodyIntro.copyWith(color: DesignSystem.text1),
      ),
    );
  }
}

/// Display [tags] in horizontal scroll view

class TagsInlineView extends StatefulWidget {
  const TagsInlineView({Key? key}) : super(key: key);

  @override
  State<TagsInlineView> createState() => _TagsInlineViewState();
}

class _TagsInlineViewState extends State<TagsInlineView>
    with AutomaticKeepAliveClientMixin {
  final _service = TagService();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SizedBox(
      height: 44,
      child: FutureBuilder(
        future: _service.getTags(),
        builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
          if (!snapshot.hasData) return _buildLoader();
          var response = snapshot.data!;
          if (response.error || response.data == null) return _buildLoader();

          List<Tag> tags = [];
          for (var i = 0; i < response.data['tags'].length; i++) {
            tags.add(Tag.fromJson(response.data['tags'][i]));
          }
          return _buildListView(tags);
        },
      ),
    );
  }

  /// Loader
  Widget _buildLoader() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 8,
      itemBuilder: (context, idx) => Shimmer.fromColors(
        child: Container(
          height: 44,
          width: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        baseColor: DesignSystem.shimmerBaseColor,
        highlightColor: DesignSystem.shimmerHighlightColor,
      ),
      separatorBuilder: (context, idx) => const SizedBox(width: 16),
    );
  }

  /// Tags listview
  Widget _buildListView(List<Tag> tags) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: tags.length,
      itemBuilder: (context, idx) => _buildTag(tags[idx]),
      separatorBuilder: (context, idx) => const SizedBox(width: 16),
    );
  }

  /// Tag card
  Widget _buildTag(Tag tag) {
    var tagName =
        '${tag.emoji} ${tag.name[0].toUpperCase()}${tag.name.substring(1)}';
    tagName = tagName
        .split('-')
        .map((char) => '${char[0].toUpperCase()}${char.substring(1)}')
        .join(' ');

    return Builder(builder: (context) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TagScreen(tagId: tag.id),
            ),
          );
        },
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: DesignSystem.card,
          ),
          child: Text(
            tagName,
            style: DesignSystem.caption,
          ),
        ),
      );
    });
  }
}

/// Inline products

class _InlineProducts extends StatefulWidget {
  const _InlineProducts({Key? key}) : super(key: key);

  @override
  State<_InlineProducts> createState() => _InlineProductsState();
}

class _InlineProductsState extends State<_InlineProducts>
    with AutomaticKeepAliveClientMixin {
  final _service = ProductService();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _p = Provider.of<SearchProvider>(context);
    if (_p.productLoading) return const InlineTagProductsLoader();
    if (_p.productsNotFound && _p.postsNotFound) return const SizedBox();
    if (_p.productsNotFound) return const _NotFound();
    if (_p.products.isEmpty) return _buildDefaultProducts();

    var itemCount = _p.products.length;
    if (_p.nextProducts != null) {
      itemCount = itemCount + 1; // +1 for others btn
    }

    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, idx) {
          if (idx != _p.products.length) {
            return _ProductCard(product: _p.products[idx]);
          }
          return _buildNavigateToOtherProducts(false, _p.query);
        },
        separatorBuilder: (context, idx) => const SizedBox(width: 16),
      ),
    );
  }

  Widget _buildNavigateToOtherProducts(bool goToDefault, String? query) {
    return SizedBox(
      height: 300,
      width: 200,
      child: OthersShortCard(
        onTap: () {
          if (goToDefault) {
            Navigator.pushNamed(context, '/products');
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchProductsScreen(
                  searchQuery: query ?? '',
                ),
              ),
            );
          }
        },
      ),
    );
  }

  /// Default products
  Widget _buildDefaultProducts() {
    return FutureBuilder(
      future: _service.getProductsPagniated(limit: 10),
      builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
        if (!snapshot.hasData) return const InlineTagProductsLoader();
        var response = snapshot.data!;
        if (response.error || response.data == null) {
          return const InlineTagProductsLoader();
        }

        List<Product> products = [];
        for (int i = 0; i < response.data['products'].length; i++) {
          products.add(Product.fromJson(response.data['products'][i]));
        }

        return SizedBox(
          height: 300,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length + 1,
            itemBuilder: (context, idx) {
              if (idx != products.length) {
                return _ProductCard(product: products[idx]);
              }
              return _buildNavigateToOtherProducts(true, '');
            },
            separatorBuilder: (context, idx) => const SizedBox(width: 16),
          ),
        );
      },
    );
  }
}

/// Post card
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

/// Posts

class _Posts extends StatefulWidget {
  const _Posts({Key? key}) : super(key: key);

  @override
  State<_Posts> createState() => _PostsState();
}

class _PostsState extends State<_Posts> with AutomaticKeepAliveClientMixin {
  final _service = PostService();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _p = Provider.of<SearchProvider>(context);
    if (_p.postLoading) return const SearchLoader();
    if (_p.productsNotFound && _p.postsNotFound) return const SizedBox();
    if (_p.postsNotFound) return const _NotFound();
    if (_p.posts.isEmpty) return _buildDefaultPosts();

    var itemCount = _p.posts.length;
    if (_p.nextPosts != null) {
      itemCount = itemCount + 1; // +1 for others btn
    }

    return AnimationLimiter(
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 40),
        physics: const ClampingScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, idx) {
          if (idx == _p.posts.length) {
            return _buildNavigateToOtherPosts(false, _p.query);
          }

          return AnimationConfiguration.staggeredList(
            position: idx,
            duration: const Duration(milliseconds: 375),
            delay: const Duration(milliseconds: 600),
            child: SlideAnimation(
              horizontalOffset: -100,
              child: FadeInAnimation(
                child: BigPostCard(post: _p.posts[idx]),
              ),
            ),
          );
        },
        separatorBuilder: (context, idx) => DesignSystem.spaceH20,
      ),
    );
  }

  /// Display default products
  Widget _buildDefaultPosts() {
    return FutureBuilder(
      future: _service.getPostsPagniated(limit: 10),
      builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
        if (!snapshot.hasData) return const SearchLoader();
        var response = snapshot.data!;
        if (response.error || response.data == null) {
          return const SearchLoader();
        }

        List<Post> posts = [];
        for (int i = 0; i < response.data['posts'].length; i++) {
          posts.add(Post.fromJson(response.data['posts'][i]));
        }

        return AnimationLimiter(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 40),
            physics: const ClampingScrollPhysics(),
            itemCount: posts.length + 1, // +1 for the others btn
            itemBuilder: (context, idx) {
              if (idx == posts.length) {
                return _buildNavigateToOtherPosts(true, '');
              }

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
      },
    );
  }

  Widget _buildNavigateToOtherPosts(bool goToDefault, String? query) {
    return SizedBox(
      height: 100,
      child: OthersShortCard(
        onTap: () {
          if (goToDefault) {
            Navigator.pushNamed(context, '/posts');
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPostsScreen(
                  searchQuery: query ?? '',
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
