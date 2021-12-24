import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:salt/design_system.dart';
import 'package:salt/widgets/animations/translate.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';
import 'package:salt/widgets/post/big_post.dart';
import 'package:salt/widgets/post/inline_posts.dart';
import 'package:salt/widgets/product/covers.dart';
import 'package:salt/widgets/product/groceries_inline_tags.dart';
import 'package:salt/widgets/recipe/recipe_categories_section.dart';
import 'package:salt/widgets/tag/tags_section.dart';
import 'package:spring/spring.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      bottomNavIdx: 0,
      children: [
        DesignSystem.spaceH20,
        const _TagsSection(),
        DesignSystem.spaceH40,
        const GroceriesSection(),
        DesignSystem.spaceH40,
        const RecipesSection(),
        DesignSystem.spaceH40,
        const PostsSection(),
        DesignSystem.spaceH40,
      ],
    );
  }
}

/// Inline tag posts

class _InlineRecipesSection extends StatefulWidget {
  const _InlineRecipesSection({Key? key}) : super(key: key);

  @override
  __InlineRecipesSectionState createState() => __InlineRecipesSectionState();
}

class __InlineRecipesSectionState extends State<_InlineRecipesSection> {
  @override
  Widget build(BuildContext context) {
    return TranslateAnimation(
      child: InlineTagPosts(tagId: '61bcb1529a229216955b03fe'),
      duration: const Duration(milliseconds: 1500),
      delay: const Duration(milliseconds: 900),
      beginOffset: Offset(MediaQuery.of(context).size.width, 0),
      endOffset: const Offset(0, 0),
      curve: Curves.easeInOut,
    );
  }
}

/// Tags section

class _TagsSection extends StatefulWidget {
  const _TagsSection({Key? key}) : super(key: key);

  @override
  __TagsSectionState createState() => __TagsSectionState();
}

class __TagsSectionState extends State<_TagsSection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: CircluarTagsSection(),
    );
  }
}

/// Posts section

class PostsSection extends StatefulWidget {
  const PostsSection({Key? key}) : super(key: key);

  @override
  State<PostsSection> createState() => _PostsSectionState();
}

class _PostsSectionState extends State<PostsSection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        _buildHeading(),
        DesignSystem.spaceH20,
        TranslateAnimation(
          child: PostsFiniteListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            limit: 5,
          ),
          duration: const Duration(milliseconds: 1500),
          delay: const Duration(milliseconds: 900),
          beginOffset: Offset(MediaQuery.of(context).size.width, 0),
          endOffset: const Offset(0, 0),
          curve: Curves.easeInOut,
        ),
        DesignSystem.spaceH20,
        SecondaryButton(
          text: 'See more...',
          onPressed: () => Navigator.pushNamed(context, '/posts'),
          horizontalPadding: 64,
        ),
      ],
    );
  }

  Widget _buildHeading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "Let's ",
          style: DesignSystem.heading3,
          children: [
            TextSpan(
              text: 'explore',
              style: DesignSystem.heading3.copyWith(
                color: DesignSystem.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Recipes section

class RecipesSection extends StatefulWidget {
  const RecipesSection({Key? key}) : super(key: key);

  @override
  State<RecipesSection> createState() => _RecipesSectionState();
}

class _RecipesSectionState extends State<RecipesSection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        _buildHeading(),
        DesignSystem.spaceH20,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: RecipeCategoriesSection(),
        ),
        DesignSystem.spaceH20,
        const _InlineRecipesSection(),
      ],
    );
  }

  Widget _buildHeading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Cook ',
          style: DesignSystem.heading3.copyWith(
            color: DesignSystem.secondary,
          ),
          children: [
            TextSpan(
              text: 'something new',
              style: DesignSystem.heading3,
            ),
          ],
        ),
      ),
    );
  }
}

/// Groceries section

class GroceriesSection extends StatefulWidget {
  const GroceriesSection({Key? key}) : super(key: key);

  @override
  State<GroceriesSection> createState() => _GroceriesSectionState();
}

class _GroceriesSectionState extends State<GroceriesSection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        _buildHeading(),
        DesignSystem.spaceH20,
        Spring.rotate(
          startAngle: 4,
          endAngle: 0,
          animDuration: const Duration(milliseconds: 1000),
          delay: const Duration(milliseconds: 1500),
          curve: Curves.easeOut,
          child: Spring.opacity(
            startOpacity: 0,
            endOpacity: 1,
            animDuration: const Duration(milliseconds: 1000),
            delay: const Duration(milliseconds: 1500),
            curve: Curves.easeIn,
            child: const TranslateAnimation(
              duration: Duration(milliseconds: 1000),
              delay: Duration(milliseconds: 1500),
              beginOffset: Offset(0, 60),
              endOffset: Offset(0, 0),
              curve: Curves.easeInOut,
              child: GroceriesCovers(),
            ),
          ),
        ),
        DesignSystem.spaceH20,
        GroceriesInlineTags(),
        DesignSystem.spaceH20,
        SecondaryButton(
          text: 'See more...',
          onPressed: () => Navigator.pushNamed(context, '/products'),
          horizontalPadding: 64,
        ),
      ],
    );
  }

  Widget _buildHeading() {
    return Spring.rotate(
      startAngle: 10,
      endAngle: 0,
      animDuration: const Duration(milliseconds: 1000),
      delay: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      child: TranslateAnimation(
        duration: const Duration(milliseconds: 1000),
        delay: const Duration(milliseconds: 800),
        beginOffset: const Offset(0, 100),
        endOffset: const Offset(0, 0),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Wanna buy ',
              style: DesignSystem.heading3,
              children: [
                TextSpan(
                  text: 'groceries?',
                  style: DesignSystem.heading3.copyWith(
                    color: DesignSystem.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
