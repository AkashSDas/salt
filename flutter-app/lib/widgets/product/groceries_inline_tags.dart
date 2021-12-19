import 'package:flutter/material.dart';
import 'package:salt/widgets/tag/btns.dart';

class GroceriesInlineTags extends StatelessWidget {
  GroceriesInlineTags({Key? key}) : super(key: key);

  /// Inside the sublist [0] element has `tag id`, [1] element has `filename`, [2]
  /// element has `label`
  final data = [
    ['61b447922bec119f102b10d6', 'chocolate', 'Chocolates'],
    ['61b449672bec119f102b10f2', 'drink', 'Drinks'],
    ['61b446402bec119f102b10b1', 'fast-food', 'Fast food'],
    ['61b449352bec119f102b10ee', 'ice-cream', 'Ice cream'],
    ['61b4469f2bec119f102b10bf', 'non-veg', 'Non veg'],
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _buildTags(),
    );
  }

  Widget _buildTags() {
    List<Widget> children = [];
    for (int i = 0; i < data.length; i++) {
      children.add(SquareTagButton(
        tagId: data[i][0],
        filename: data[i][1],
        animation: 'idle',
        label: data[i][2],
        onTap: () {},
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
