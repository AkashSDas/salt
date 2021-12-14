import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:salt/widgets/common/buttons.dart';

import '../../design_system.dart';

class OthersRecipePostsInlineView extends StatelessWidget {
  const OthersRecipePostsInlineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Explore other's recipes",
          style: DesignSystem.small,
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 200,
          child: const _InlineView(),
        ),
      ],
    );
  }
}

class _InlineView extends StatelessWidget {
  const _InlineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        ...(List.generate(
          8,
          (idx) => Container(
            height: 200,
            width: 130,
            margin: const EdgeInsets.only(right: 16),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(children: const [_CoverImage(), _MaskWithTitle()]),
          ),
        ).toList()),
        Container(
          height: 200,
          width: 130,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: DesignSystem.purple,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                height: 40,
                width: 40,
                child: FlareActor(
                  'assets/flare/other-emojis/smiling-face-with-sunglasses.flr',
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: 'go',
                ),
              ),
              SizedBox(height: 4),
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
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1639189972760-566d9ae1d4d2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=463&q=80',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _MaskWithTitle extends StatelessWidget {
  const _MaskWithTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xff1F1F1F), Colors.transparent],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        alignment: Alignment.bottomLeft,
        child: Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit amet luctus',
          style: DesignSystem.caption.copyWith(
            color: DesignSystem.text1,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
