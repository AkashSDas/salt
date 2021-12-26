import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/product_feedback/product_feedback.dart';
import 'package:salt/widgets/animations/reveal.dart';
import 'package:salt/widgets/common/divider.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';
import 'package:salt/widgets/product/feedbacks_on_product.dart';

class ProductFeedbacksScreen extends StatelessWidget {
  final List<ProductFeedback> feedbacks;

  const ProductFeedbacksScreen({
    Key? key,
    required this.feedbacks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      children: [
        RevealAnimation(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${feedbacks.length} feedback',
              style: DesignSystem.heading1,
            ),
          ),
          startAngle: 10,
          startYOffset: 100,
          delay: 100,
          duration: 1000,
          curve: Curves.easeOut,
        ),
        DesignSystem.spaceH20,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: DashedSeparator(height: 1.6),
        ),
        DesignSystem.spaceH20,
        AnimationLimiter(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: feedbacks.length,
            itemBuilder: (context, idx) {
              return AnimationConfiguration.staggeredList(
                position: idx,
                duration: const Duration(milliseconds: 375),
                delay: const Duration(milliseconds: 130),
                child: SlideAnimation(
                  horizontalOffset: -100,
                  child: FadeInAnimation(
                    child: ProductUserFeedbackCard(feedback: feedbacks[idx]),
                  ),
                ),
              );
            },
            separatorBuilder: (context, idx) {
              return const SizedBox(height: 30, child: LineSeparator());
            },
          ),
        ),
      ],
    );
  }
}
