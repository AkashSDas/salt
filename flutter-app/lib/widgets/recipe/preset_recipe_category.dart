import 'package:flutter/material.dart';

import '../../design_system.dart';

class PresetRecipeCategories extends StatelessWidget {
  const PresetRecipeCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,

      // item width / item height, for desired grid items heigh
      childAspectRatio: 168 / 118,

      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Stack(
            fit: StackFit.loose,
            children: const [
              Positioned(
                bottom: 16,
                right: 0,
                left: 0,
                child: Text(
                  'Breakfast',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: DesignSystem.fontHighlight,
                    fontSize: 17,
                    color: DesignSystem.text1,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Stack(
            fit: StackFit.loose,
            children: const [
              Positioned(
                bottom: 16,
                right: 0,
                left: 0,
                child: Text(
                  'High Protein',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: DesignSystem.fontHighlight,
                    fontSize: 17,
                    color: DesignSystem.text1,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Stack(
            fit: StackFit.loose,
            children: const [
              Positioned(
                bottom: 16,
                right: 0,
                left: 0,
                child: Text(
                  'Drinks',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: DesignSystem.fontHighlight,
                    fontSize: 17,
                    color: DesignSystem.text1,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: DesignSystem.purple,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Stack(
            fit: StackFit.loose,
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Others',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: DesignSystem.fontHighlight,
                        fontSize: 17,
                        color: DesignSystem.text1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
