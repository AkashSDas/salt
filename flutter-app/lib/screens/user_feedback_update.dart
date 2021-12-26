import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/product_order/product_order.dart';
import 'package:salt/models/user_feedback/user_feedback.dart';
import 'package:salt/providers/user_provider.dart';
import 'package:salt/services/feedback.dart';
import 'package:salt/utils/index.dart';
import 'package:salt/widgets/animations/reveal.dart';
import 'package:salt/widgets/common/alert.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/common/divider.dart';
import 'package:salt/widgets/common/form.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';

class UserFeedbackUpdateScreen extends StatelessWidget {
  final ProductOrder order;
  final UserFeedback feedback;

  const UserFeedbackUpdateScreen({
    Key? key,
    required this.order,
    required this.feedback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RevealAnimation(
                startAngle: 10,
                delay: 100,
                startYOffset: 60,
                duration: 1000,
                child: Text('Update feedback', style: DesignSystem.heading1),
              ),
              DesignSystem.spaceH20,
              const DashedSeparator(height: 1.6),
              DesignSystem.spaceH20,
              _buildCoverImg(),
              DesignSystem.spaceH20,
              Text(order.product.title, style: DesignSystem.heading4),
              DesignSystem.spaceH20,
              _buildPurchaseInfo(),
              DesignSystem.spaceH40,
              _FeedbackUpdateForm(feedback: feedback),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoverImg() {
    return Container(
      height: 200,
      width: 160,
      decoration: BoxDecoration(
        color: DesignSystem.card,
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(order.product.coverImgURLs[0]),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPurchaseInfo() {
    return RichText(
      text: TextSpan(
        text: 'Bought ',
        style: DesignSystem.bodyIntro.copyWith(color: DesignSystem.text1),
        children: [
          TextSpan(
            text: '${order.quantity} ',
            style: const TextStyle(
              color: DesignSystem.success,
              fontSize: 20,
              fontFamily: DesignSystem.fontHighlight,
              fontWeight: FontWeight.w400,
            ),
          ),
          const TextSpan(text: 'for '),
          TextSpan(
            text: '${order.quantity * order.price} ',
            style: const TextStyle(
              color: DesignSystem.success,
              fontSize: 20,
              fontFamily: DesignSystem.fontHighlight,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

/// Update feedback form

class _FeedbackUpdateForm extends StatefulWidget {
  final UserFeedback feedback;

  const _FeedbackUpdateForm({
    Key? key,
    required this.feedback,
  }) : super(key: key);

  @override
  State<_FeedbackUpdateForm> createState() => _FeedbackUpdateFormState();
}

class _FeedbackUpdateFormState extends State<_FeedbackUpdateForm> {
  var loading = false;
  late String feedback;
  late int rating;

  @override
  void initState() {
    super.initState();
    feedback = widget.feedback.comment;
    rating = widget.feedback.rating;
  }

  InputDecoration _inputDecoration(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(width: 0, style: BorderStyle.none),
    );

    var hintStyle = DesignSystem.bodyIntro.copyWith(
      color: DesignSystem.placeholder,
    );
    var errorStyle = DesignSystem.caption.copyWith(
      color: DesignSystem.error,
    );

    return InputDecoration(
      fillColor: Theme.of(context).cardColor,
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintText: 'Did you liked the product?',
      border: border,
      hintStyle: hintStyle,
      errorStyle: errorStyle,
      prefixIcon: const Padding(
        padding: EdgeInsets.only(top: 20),
        child: Align(
          alignment: Alignment.topCenter,
          widthFactor: 1,
          heightFactor: 8.5,
          child: Icon(IconlyLight.chat, color: DesignSystem.icon),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserProvider>(context);

    return Column(
      children: [
        const FormLabel(label: 'Feedback'),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextFormField(
            initialValue: feedback,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            onChanged: (value) => setState(() => feedback = value),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: MultiValidator([
              RequiredValidator(errorText: 'Feedback is required'),
              MinLengthValidator(
                10,
                errorText: 'Feedback should be at least 10 characters long',
              ),
            ]),
            decoration: _inputDecoration(context),
            cursorColor: Theme.of(context).colorScheme.secondary,
            style: DesignSystem.bodyIntro.copyWith(color: DesignSystem.text1),
          ),
        ),
        DesignSystem.spaceH20,
        _buildRating(),
        DesignSystem.spaceH40,
        PrimaryButton(
          text: loading ? 'Updating...' : 'Update',
          onPressed: () async {
            final service = FeedbackService();
            setState(() => loading = true);
            var result = await runAsync(
              service.updateFeedback(
                widget.feedback.id,
                rating,
                feedback,
                _user.user?.id ?? '',
                _user.token ?? '',
              ),
            );
            setState(() => loading = false);

            if (result[0] == null) {
              failedSnackBar(
                context: context,
                msg: 'Something went wrong, Please try again',
              );
            } else {
              if (result[0].error) {
                failedSnackBar(context: context, msg: result[0].msg);
              } else {
                successSnackBar(context: context, msg: result[0].msg);
              }
            }
          },
          horizontalPadding: 100,
        ),
        DesignSystem.spaceH40,
      ],
    );
  }

  Widget _buildRating() {
    return RatingBar.builder(
      initialRating: rating.toDouble(),
      minRating: 0,
      direction: Axis.horizontal,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4),
      itemBuilder: (context, _) => const Icon(
        IconlyBold.star,
        color: Color(0xffEFD810),
      ),
      onRatingUpdate: (r) => setState(() => rating = r.toInt()),
      glow: false,
      maxRating: 5,
    );
  }
}
