import 'package:flutter/material.dart';
import 'package:salt/screens/tag.dart';
import 'package:salt/widgets/tag/btns.dart';

class CircluarTagsSection extends StatelessWidget {
  CircluarTagsSection({Key? key}) : super(key: key);

  final row1Data = [
    ['cake', '61b445bc2bec119f102b10a9'],
    ['chocolate', '61b447922bec119f102b10d6'],
    ['fast-food', '61b446402bec119f102b10b1'],
    ['sweet', '61b4477a2bec119f102b10d2'],
  ];

  final row2Data = [
    ['diet', "61b4468e2bec119f102b10b9"],
    ['non-veg', "61b4469f2bec119f102b10bf"],
    ['high-protein', "61b446c02bec119f102b10c3"],
    ['movie-snack', "61b447602bec119f102b10ce"],
    ['lunch', "61b447a62bec119f102b10da"],
  ];

  final row3Data = [
    ['sushi', "61b447b72bec119f102b10de"],
    ['dairy', "61b447f52bec119f102b10e2"],
    ['sea-food', "61b448802bec119f102b10e6"],
    ['ice-cream', "61b449352bec119f102b10ee"],
    ['snack', "61b44a642bec119f102b10fe"],
  ];

  final row4Data = [
    ['fruit', "61b44a3d2bec119f102b10fa"],
    ['caffeine', "61b449832bec119f102b10f6"],
    ['drink', "61b449672bec119f102b10f2"],
    ['kitchen', "61b449192bec119f102b10ea"],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildShortRow(row1Data),
        const SizedBox(height: 8),
        _buildLongRow(row2Data),
        const SizedBox(height: 8),
        _buildLongRow(row3Data),
        const SizedBox(height: 8),
        _buildShortRow(row4Data),
      ],
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
