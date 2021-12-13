import 'package:flutter/material.dart';
import 'package:salt/widgets/common/buttons.dart';

import '../../design_system.dart';

class LimitedPostsView extends StatelessWidget {
  const LimitedPostsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Human, ',
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
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _Posts(),
        ),
      ],
    );
  }
}

class _Posts extends StatelessWidget {
  const _Posts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...(List.generate(3, (idx) => _Post(idx: idx))),
        const SizedBox(height: 20),
        SecondaryButton(
          text: 'See more...',
          onPressed: () {},
          horizontalPadding: 64,
        ),
      ],
    );
  }
}

class _Post extends StatelessWidget {
  final int idx;
  const _Post({required this.idx, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            border: Border.all(color: DesignSystem.border, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [_CoverImg(), _PostInfo()],
          ),
        ),
        SizedBox(height: idx == 2 ? 0 : 20),
      ],
    );
  }
}

class _CoverImg extends StatelessWidget {
  const _CoverImg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1639189972760-566d9ae1d4d2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=463&q=80',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PostInfo extends StatelessWidget {
  const _PostInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 92 + 10, // the first SizedBox of height 10 as spacing
      child: ListView(
        children: [
          const SizedBox(height: 10),
          const _PostMetadata(),
          const SizedBox(height: 10),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit amet luctus Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit amet luctus',
            style: DesignSystem.bodyMain,
          ),
        ],
      ),
    );
  }
}

class _PostMetadata extends StatelessWidget {
  const _PostMetadata({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const _AuthorProfilePic(),
        const SizedBox(width: 16),
        const Text(
          'salt girl',
          style: TextStyle(
            color: DesignSystem.text1,
            fontFamily: DesignSystem.fontBody,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        const SizedBox(width: 16),
        Text('21 Jul 2021', style: DesignSystem.small),
      ],
    );
  }
}

class _AuthorProfilePic extends StatelessWidget {
  const _AuthorProfilePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xffCEA209), width: 1.6),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1639189972760-566d9ae1d4d2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=463&q=80',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
