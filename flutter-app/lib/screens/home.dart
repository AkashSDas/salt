import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:salt/design_system.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';
import 'package:salt/widgets/post/big_post.dart';
import 'package:salt/widgets/post/inline_posts.dart';
import 'package:salt/widgets/product/covers.dart';
import 'package:salt/widgets/product/groceries_inline_tags.dart';
import 'package:salt/widgets/recipe/recipe_categories_section.dart';
import 'package:salt/widgets/tag/tags_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      bottomNavIdx: 0,
      children: [
        _buildTagsSection(),
        DesignSystem.spaceH40,
        const GroceriesSection(),
        DesignSystem.spaceH40,
        const RecipesSection(),
        DesignSystem.spaceH40,
        InlineTagPosts(tagId: '61bcb1529a229216955b03fe'),
        DesignSystem.spaceH40,
        const PostsSection(),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: CircluarTagsSection(),
    );
  }
}

/// Posts section
class PostsSection extends StatelessWidget {
  const PostsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeading(),
        DesignSystem.spaceH20,
        PostsFiniteListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          limit: 5,
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
class RecipesSection extends StatelessWidget {
  const RecipesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeading(),
        DesignSystem.spaceH20,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: RecipeCategoriesSection(),
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
class GroceriesSection extends StatelessWidget {
  const GroceriesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeading(),
        DesignSystem.spaceH20,
        const GroceriesCovers(),
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
    return Padding(
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
    );
  }
}
