import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/product_feedback/product_feedback.dart';
import 'package:salt/screens/product_feedbacks.dart';
import 'package:salt/services/feedback.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/widgets/animations/reveal.dart';
import 'package:salt/widgets/common/divider.dart';
import 'package:salt/widgets/common/loader.dart';

/// This widget wil display only few [feedbacks] and then shows `see more`
/// which will navigate to [ProductFeedbacksScreen] which will display all
/// the [ProductFeedback]
///
/// This will fetch all the `feedbacks` for the product
class FeedbacksOnProduct extends StatelessWidget {
  final _service = FeedbackService();
  final String productId;

  FeedbacksOnProduct({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RevealAnimation(
          delay: 100,
          duration: 1000,
          startAngle: 10,
          startYOffset: 60,
          child: Text('Feedbacks', style: DesignSystem.heading3),
        ),
        DesignSystem.spaceH20,
        FutureBuilder(
          future: _service.getProductFeedbackOverview(productId),
          builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
            if (!snapshot.hasData) return const SizedBox();

            var data = snapshot.data!.data;
            final totalRatings = data['0'] +
                data['1'] +
                data['2'] +
                data['3'] +
                data['4'] +
                data['5'];

            return ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: 6,
              itemBuilder: (context, idx) {
                var widthFactor = totalRatings == 0
                    ? 0
                    : double.parse(((data['$idx'] / totalRatings) * 100)
                        .toStringAsFixed(1));

                return Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: Text(
                        '$idx',
                        style: const TextStyle(
                          color: DesignSystem.text1,
                          fontSize: 20,
                          fontFamily: DesignSystem.fontHighlight,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: DesignSystem.card,
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          LayoutBuilder(builder: (context, BoxConstraints box) {
                            return Container(
                              height: 20,
                              width: (widthFactor / 100) * box.maxWidth,
                              decoration: BoxDecoration(
                                color: const Color(0xffEFD810),
                                borderRadius: BorderRadius.circular(32),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 60,
                      child: Text(
                        "$widthFactor%",
                        style: DesignSystem.caption,
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, idx) => const SizedBox(height: 4),
            );
          },
        ),
        DesignSystem.spaceH20,
        FutureBuilder(
          future: _service.getProductFeedbacks(productId),
          builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
            if (!snapshot.hasData) return const SearchLoader();

            List<ProductFeedback> feedbacks = [];
            for (int i = 0; i < snapshot.data!.data['feedbacks'].length; i++) {
              feedbacks.add(
                ProductFeedback.fromJson(snapshot.data!.data['feedbacks'][i]),
              );
            }

            return Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: feedbacks.length > 3 ? 3 : feedbacks.length,
                  itemBuilder: (context, idx) {
                    return ProductUserFeedbackCard(feedback: feedbacks[idx]);
                  },
                  separatorBuilder: (context, idx) {
                    return const LineSeparator();
                  },
                ),
                const SizedBox(height: 10),
                feedbacks.length > 3
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductFeedbacksScreen(
                                feedbacks: feedbacks,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Read more',
                          style: TextStyle(
                            color: DesignSystem.secondary,
                            fontSize: 20,
                            fontFamily: DesignSystem.fontHighlight,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Product's user feedback card
class ProductUserFeedbackCard extends StatelessWidget {
  final ProductFeedback feedback;

  const ProductUserFeedbackCard({
    Key? key,
    required this.feedback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RatingBarIndicator(
          rating: feedback.rating.toDouble(),
          itemBuilder: (context, _) => const Icon(
            IconlyBold.star,
            color: Color(0xffEFD810),
          ),
          itemCount: 5,
          itemSize: 20,
          direction: Axis.horizontal,
        ),
        const SizedBox(height: 10),
        Text(feedback.comment, style: DesignSystem.caption),
      ],
    );
  }
}
