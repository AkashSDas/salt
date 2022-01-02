import 'package:flutter/material.dart';
import 'package:salt/screens/tag.dart';
import 'package:salt/utils/tags.dart';
import 'package:salt/widgets/animations/reveal.dart';
import 'package:salt/widgets/tag/btns.dart';

class CircluarTagsSection extends StatelessWidget {
  CircluarTagsSection({Key? key}) : super(key: key);

  final row1Data = [
    ['cake', TagMongoDBIds.cake],
    ['chocolate', TagMongoDBIds.chocolate],
    ['fast-food', TagMongoDBIds.fastFood],
    ['sweet', TagMongoDBIds.sweet],
  ];

  final row2Data = [
    ['diet', TagMongoDBIds.salad],
    ['non-veg', TagMongoDBIds.nonVeg],
    ['high-protein', TagMongoDBIds.highProtein],
    ['movie-snack', TagMongoDBIds.movieSnack],
    ['lunch', TagMongoDBIds.lunch],
  ];

  final row3Data = [
    ['sushi', TagMongoDBIds.sushi],
    ['dairy', TagMongoDBIds.dairy],
    ['sea-food', TagMongoDBIds.seaFood],
    ['ice-cream', TagMongoDBIds.iceCream],
    ['snack', TagMongoDBIds.snack],
  ];

  final row4Data = [
    ['fruit', TagMongoDBIds.fruits],
    ['caffeine', TagMongoDBIds.coffee],
    ['drink', TagMongoDBIds.drinks],
    ['kitchen', TagMongoDBIds.kitchen],
  ];

  @override
  Widget build(BuildContext context) {
    var baseDelay = 200;

    return Column(
      children: [
        _buildRevealAnimation(_buildShortRow(row1Data), baseDelay * 1),
        const SizedBox(height: 8),
        _buildRevealAnimation(_buildLongRow(row2Data), baseDelay * 2),
        const SizedBox(height: 8),
        _buildRevealAnimation(_buildShortRow(row4Data), baseDelay * 3),
      ],
    );
  }

  Widget _buildRevealAnimation(Widget child, int delay) {
    return RevealAnimation(
      child: child,
      startAngle: 30,
      delay: delay,
      startYOffset: 100,
      duration: 1000,
      curve: Curves.easeOut,
    );
  }

  /// Space between btns
  Widget _buildSpace() => const SizedBox(width: 16);

  Widget _buildBtn(List<String> data) {
    return Builder(
      builder: (context) {
        return CircularTagButton(
          tagId: data[1],
          filename: data[0],
          animation: 'blink',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TagScreen(tagId: data[1])),
          ),
        );
      },
    );
  }

  /// Row with 4 elements
  Widget _buildShortRow(List<List<String>> data) {
    List<Widget> children = [];
    for (int i = 0; i < data.length; i++) {
      children.add(_buildBtn(data[i]));
      if (i != data.length - 1) children.add(_buildSpace());
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  /// Row with 5 elements. The btn in these row is wrapped with [Flexible] to
  /// avoid [render overflow] issue on the [Row]
  Widget _buildLongRow(List<List<String>> data) {
    List<Widget> children = [];
    for (int i = 0; i < data.length; i++) {
      children.add(Flexible(child: _buildBtn(data[i])));
      if (i != data.length - 1) children.add(_buildSpace());
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
