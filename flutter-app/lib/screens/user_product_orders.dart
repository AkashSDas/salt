import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/product_order/product_order.dart';
import 'package:salt/models/user_feedback/user_feedback.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/providers/product_order_infinite_scroll.dart';
import 'package:salt/providers/user_provider.dart';
import 'package:salt/screens/user_feedback.dart';
import 'package:salt/screens/user_feedback_update.dart';
import 'package:salt/services/feedback.dart';
import 'package:salt/services/product.dart';
import 'package:salt/widgets/animations/reveal.dart';
import 'package:salt/widgets/common/alert.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/common/divider.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animated_drawer.dart';
import 'package:salt/widgets/others/scroll_behavior.dart';

/// NOTE:
/// This doesn't handles the condition where the user bought product is no longer
/// available, it not even handled by the back-end

class UserProductOrdersScreen extends StatelessWidget {
  const UserProductOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      child: ChangeNotifierProvider(
        create: (context) => ProductOrderInfiniteScrollProvider(),
        child: const _OrdersListView(),
      ),
    );
  }
}

/// User product orders infinite listview

class _OrdersListView extends StatefulWidget {
  const _OrdersListView({Key? key}) : super(key: key);

  @override
  __OrdersListViewState createState() => __OrdersListViewState();
}

class __OrdersListViewState extends State<_OrdersListView> {
  final ScrollController _ctrl = ScrollController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<ProductOrderInfiniteScrollProvider>(
        context,
        listen: false,
      ).initialFetchUserProductOrders(
        Provider.of<UserProvider>(context, listen: false).user?.id ?? '',
        Provider.of<UserProvider>(context, listen: false).token ?? '',
        null,
        null,
      );

      /// Scroll event for fetching more posts
      _ctrl.addListener(() {
        var loading = Provider.of<ProductOrderInfiniteScrollProvider>(
          context,
          listen: false,
        ).loading;

        var reachedEnd = Provider.of<ProductOrderInfiniteScrollProvider>(
          context,
          listen: false,
        ).reachedEnd;

        var pixels = _ctrl.position.pixels;
        var maxScrollExtent = _ctrl.position.maxScrollExtent;

        if (pixels >= maxScrollExtent && !loading && !reachedEnd) {
          /// fetch more
          Provider.of<ProductOrderInfiniteScrollProvider>(
            context,
            listen: false,
          ).fetchMoreUserProductOrders(
            Provider.of<UserProvider>(context, listen: false).user?.id ?? '',
            Provider.of<UserProvider>(context, listen: false).token ?? '',
          );
        }

        if (pixels >= 0) {
          /// Listview has be scrolled (when == 0 you're at top)
          Provider.of<AnimatedDrawerProvider>(
            context,
            listen: false,
          ).animateAppBar(pixels);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductOrderInfiniteScrollProvider>(context);

    return ScrollConfiguration(
      behavior: NoHighlightBehavior(),
      child: ListView(
        controller: _ctrl,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          RevealAnimation(
            startAngle: 10,
            delay: 100,
            startYOffset: 60,
            duration: 1000,
            child: Text('My orders', style: DesignSystem.heading1),
          ),
          DesignSystem.spaceH20,
          const DashedSeparator(height: 1.6),
          DesignSystem.spaceH20,
          _provider.firstLoading
              ? const SearchLoader()
              : AnimationLimiter(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: _provider.orders.length,
                    itemBuilder: (context, idx) {
                      return AnimationConfiguration.staggeredList(
                        position: idx,
                        duration: const Duration(milliseconds: 375),
                        delay: const Duration(milliseconds: 300),
                        child: SlideAnimation(
                          horizontalOffset: -100,
                          child: FadeInAnimation(
                            child: _UserOrderCard(
                              order: _provider.orders[idx],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, idx) => DesignSystem.spaceH20,
                  ),
                ),
          DesignSystem.spaceH40,
          _provider.reachedEnd
              ? Text(
                  "You've reached the end",
                  style: DesignSystem.bodyMain,
                  textAlign: TextAlign.center,
                )
              : !_provider.firstLoading
                  ? const SearchLoader()
                  : const SizedBox(),
          DesignSystem.spaceH40,
        ],
      ),
    );
  }
}

/// User order card
class _UserOrderCard extends StatelessWidget {
  final ProductOrder order;
  const _UserOrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: DesignSystem.border, width: 1.5),
        borderRadius: BorderRadius.circular(20),
        color: DesignSystem.primary,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImg(),
              const SizedBox(width: 8),
              _OrderActions(order: order),
            ],
          ),
          order.feedback != null
              ? const SizedBox(height: 16)
              : const SizedBox(),
          order.feedback != null ? _buildFeedback() : const SizedBox(),
          order.feedback != null
              ? const SizedBox(height: 16)
              : const SizedBox(),
          order.feedback != null
              ? Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserFeedbackUpdateScreen(
                                order: order,
                                feedback: order.feedback as UserFeedback,
                              ),
                            ),
                          );
                        },
                        text: 'Update',
                      ),
                    ),
                    const SizedBox(width: 8),
                    _DeleteFeedbackButton(feedbackId: order.feedback?.id ?? ''),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildFeedback() {
    return Column(
      children: [
        RatingBarIndicator(
          rating: order.feedback!.rating.toDouble(),
          itemBuilder: (context, _) => const Icon(
            IconlyBold.star,
            color: Color(0xffEFD810),
          ),
          itemCount: 5,
          itemSize: 24,
          direction: Axis.horizontal,
        ),
        const SizedBox(height: 16),
        Text(
          order.feedback!.comment,
          style: DesignSystem.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildImg() {
    return Container(
      height: 150,
      width: 126,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: DesignSystem.primary,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(order.product.coverImgURLs[0]),
        ),
      ),
    );
  }
}

/// Order actions
class _OrderActions extends StatelessWidget {
  final ProductOrder order;
  const _OrderActions({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.product.title,
            style: DesignSystem.bodyMain.copyWith(
              color: DesignSystem.text1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          _buildPrice(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              order.feedback == null
                  ? _buildGiveFeedback(context)
                  : const SizedBox(),
              const SizedBox(width: 8),
              _buildIconBtn(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGiveFeedback(BuildContext context) {
    return Expanded(
      child: SecondaryButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserFeedbackScreen(order: order),
          ),
        ),
        text: 'Give feedback',
      ),
    );
  }

  Widget _buildIconBtn(BuildContext context) {
    final _user = Provider.of<UserProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: DesignSystem.card,
        borderRadius: BorderRadius.circular(32),
      ),
      child: IconButton(
        icon: const Icon(IconlyLight.buy),
        onPressed: () async {
          if (_user.token == null) {
            failedSnackBar(context: context, msg: 'You are not logged in');
            Navigator.pushNamed(context, '/auth/login');
          } else {
            final service = ProductService();
            var res = await service.saveProductToCart({
              ...order.product.toJson(),
              'quantitySelected': 1,
            });
            if (res['error']) {
              failedSnackBar(context: context, msg: res['msg']);
            } else {
              successSnackBar(context: context, msg: res['msg']);
            }
          }
        },
      ),
    );
  }

  /// Display price info
  Widget _buildPrice() {
    if (order.price == order.product.price) {
      return Text(
        '${order.price}',
        style: const TextStyle(
          color: DesignSystem.success,
          fontFamily: DesignSystem.fontHighlight,
          fontWeight: FontWeight.w400,
          fontSize: 24,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            text: 'Bought at ',
            style: DesignSystem.bodyMain,
            children: [
              TextSpan(
                text: '${order.price}',
                style: const TextStyle(
                  color: DesignSystem.text1,
                  fontFamily: DesignSystem.fontHighlight,
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            text: 'Current price is ',
            style: DesignSystem.bodyMain,
            children: [
              TextSpan(
                text: '${order.product.price}',
                style: TextStyle(
                  color: order.price > order.product.price
                      ? DesignSystem.success
                      : DesignSystem.error,
                  fontFamily: DesignSystem.fontHighlight,
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Delete feedback btn

class _DeleteFeedbackButton extends StatefulWidget {
  final String feedbackId;

  const _DeleteFeedbackButton({
    Key? key,
    required this.feedbackId,
  }) : super(key: key);

  @override
  __DeleteFeedbackButtonState createState() => __DeleteFeedbackButtonState();
}

class __DeleteFeedbackButtonState extends State<_DeleteFeedbackButton> {
  var loading = false;

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserProvider>(context);

    return Expanded(
      child: SecondaryButton(
        onPressed: () async {
          if (loading) return;
          if (_user.token == null) {
            failedSnackBar(
              context: context,
              msg: 'You must be logged in to do that',
            );
            return;
          }

          var service = FeedbackService();
          setState(() => loading = true);
          var response = await service.deleteFeedback(
            widget.feedbackId,
            _user.user?.id ?? '',
            _user.token ?? '',
          );
          setState(() => loading = false);

          if (response.error) {
            failedSnackBar(context: context, msg: response.msg);
          } else {
            /// TODO: Update UI for not displaying feedback and displaying
            /// give feedback btn
            successSnackBar(context: context, msg: response.msg);
          }
        },
        text: loading ? 'Deleting...' : 'Delete',
      ),
    );
  }
}
