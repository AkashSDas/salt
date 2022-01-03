import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';
import 'package:salt/screens/tag_posts.dart';
import 'package:salt/utils/tags.dart';
import 'package:salt/widgets/common/cool.dart';

class RecipeCategoriesSection extends StatelessWidget {
  const RecipeCategoriesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // item width / item height, for desired grid items heigh
    var childAspectRatio = 168 / 118;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: childAspectRatio,
      children: [
        RecipeCategoryCard(
          label: 'Breakfast',
          filename: 'breakfast',
          labelBottom: 16,
          labelRight: 0,
          labelLeft: 0,
          headingTop: -50,
          headingRight: 0,
          headingLeft: 0,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TagPostsScreen(
                  tagId: TagMongoDBIds.breakfast,
                  tagName: 'breakfast',
                ),
              ),
            );
          },
        ),
        RecipeCategoryCard(
          label: 'High Protein',
          filename: 'high-protein-food',
          labelBottom: 16,
          labelRight: 0,
          labelLeft: 0,
          headingTop: -40,
          headingRight: 0,
          headingLeft: 0,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TagPostsScreen(
                  tagId: TagMongoDBIds.highProtein,
                  tagName: 'high-protein',
                ),
              ),
            );
          },
        ),
        RecipeCategoryCard(
            label: 'Drinks',
            filename: 'drink-items',
            labelBottom: 16,
            labelRight: 0,
            labelLeft: 0,
            headingTop: -40,
            headingRight: 0,
            headingLeft: 0,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TagPostsScreen(
                    tagId: TagMongoDBIds.drinks,
                    tagName: 'drinks',
                  ),
                ),
              );
            }),
        OthersShortCard(
          onTap: () => Navigator.pushNamed(context, '/recipes'),
        ),
      ],
    );
  }
}

class RecipeCategoryCard extends StatelessWidget {
  final String label;
  final String filename;
  final double? labelLeft;
  final double? labelTop;
  final double? labelRight;
  final double? labelBottom;
  final double? headingLeft;
  final double? headingTop;
  final double? headingRight;
  final double? headingBottom;
  final void Function()? onTap;

  const RecipeCategoryCard({
    Key? key,
    this.onTap,
    this.labelBottom,
    this.labelLeft,
    this.labelRight,
    this.labelTop,
    this.headingBottom,
    this.headingLeft,
    this.headingRight,
    this.headingTop,
    required this.label,
    required this.filename,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Stack(
          fit: StackFit.loose,
          children: [_buildHeading(), _buildText()],
        ),
      ),
    );
  }

  Widget _buildHeading() {
    return Positioned(
      bottom: headingBottom,
      top: headingTop,
      right: headingRight,
      left: headingLeft,
      child: AspectRatio(
        aspectRatio: 1,
        child: FlareActor(
          'assets/flare/group-emojis/$filename.flr',
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: 'idle',
        ),
      ),
    );
  }

  Widget _buildText() {
    return Positioned(
      bottom: labelBottom,
      top: labelTop,
      right: labelRight,
      left: labelLeft,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: DesignSystem.fontHighlight,
          fontSize: 17,
          color: DesignSystem.text1,
        ),
      ),
    );
  }
}
