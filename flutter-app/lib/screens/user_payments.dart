import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/user_payment.dart';
import 'package:salt/providers/user_provider.dart';
import 'package:salt/services/payment.dart';
import 'package:salt/utils/index.dart';
import 'package:salt/widgets/animations/reveal.dart';
import 'package:salt/widgets/common/alert.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/common/cool.dart';
import 'package:salt/widgets/common/divider.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';

class UserPaymentsScreen extends StatelessWidget {
  const UserPaymentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserProvider>(context);

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
                child: Text('My payment info', style: DesignSystem.heading1),
              ),
              DesignSystem.spaceH40,
              _user.token == null
                  ? Center(
                      child: Text(
                        'You are not logged in',
                        style: DesignSystem.bodyIntro,
                      ),
                    )
                  : const SizedBox(),
              _user.token != null
                  ? Column(
                      children: [
                        const _UserPaymentCardsInfo(),
                        DesignSystem.spaceH40,
                        ChangeNotifierProvider(
                          create: (context) => UserPaymentProvider(),
                          child: const _SavePaymentCard(),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}

/// Save payment card
class _SavePaymentCard extends StatelessWidget {
  const _SavePaymentCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserPaymentProvider>(context);

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Add payment card', style: DesignSystem.heading4),
        ),
        DesignSystem.spaceH20,
        const DashedSeparator(height: 1.6),
        DesignSystem.spaceH20,
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Save a card to use later for shopping and other payment related transactions.',
            style: DesignSystem.medium,
          ),
        ),
        DesignSystem.spaceH20,
        _provider.setupIntent == null
            ? const _AttachPaymentCard()
            : const _PaymentCardForm(),
        DesignSystem.spaceH40,
      ],
    );
  }
}

/// Attach payment card

class _AttachPaymentCard extends StatefulWidget {
  const _AttachPaymentCard({Key? key}) : super(key: key);

  @override
  State<_AttachPaymentCard> createState() => _AttachPaymentCardState();
}

class _AttachPaymentCardState extends State<_AttachPaymentCard> {
  var loading = false;
  final _service = PaymentService();

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserProvider>(context);
    final _provider = Provider.of<UserPaymentProvider>(context);

    return PrimaryButton(
      text: loading ? 'Attaching...' : 'Attach new credit card',
      horizontalPadding: loading ? 80 : 32,
      onPressed: () async {
        /// Setup intent
        setState(() => loading = true);
        var response = await _service.saveUserPaymentCard(
          _user.user?.id ?? '',
          _user.token ?? '',
        );
        setState(() => loading = false);

        if (response['error']) {
          failedSnackBar(context: context, msg: response['msg']);
        } else {
          final data = response['data'];

          /// Taking care of casing of field names
          /// like client_secret to clientSecret and more...
          /// Also there are type issues
          _provider.setSetupIntent(
            SetupIntent.fromJson({
              ...data,
              'clientSecret': data['client_secret'],
              'paymentMethodId': data['payment_method'] ??
                  '', // data['payment_method'] is null
              'paymentMethodTypes': data['payment_method_types']
                  .map((name) => filterPaymentMethodName(name))
                  .toList(),
              'lastSetupError': data['last_setup_error'],
              'created': data['created'].toString(),
            }),
          );
          successSnackBar(context: context, msg: response['msg']);
        }
      },
    );
  }
}

/// Save payment card form

class _PaymentCardForm extends StatefulWidget {
  const _PaymentCardForm({Key? key}) : super(key: key);

  @override
  __PaymentCardFormState createState() => __PaymentCardFormState();
}

class __PaymentCardFormState extends State<_PaymentCardForm> {
  var loading = false;
  final _ctrl = CardEditController();
  final _service = PaymentService();

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserProvider>(context);
    final _provider = Provider.of<UserPaymentProvider>(context);
    return Column(
      children: [
        CardField(
          controller: _ctrl,
          cursorColor: DesignSystem.secondary,
          style: DesignSystem.bodyMain,
          decoration: InputDecoration(
            fillColor: DesignSystem.card,
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            hintStyle: DesignSystem.bodyMain.copyWith(
              color: const Color(0xff484848),
            ),
          ),
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          text: loading ? 'Saving...' : 'Saving card',
          horizontalPadding: 80,
          onPressed: () async {
            if (!_ctrl.complete) {
              failedSnackBar(
                context: context,
                msg: 'Fill card information',
              );
              return;
            }

            setState(() => loading = true);

            /// User info
            final details = BillingDetails(
              email: _user.user?.email ?? '',
            );

            /// Confirm Card Setup
            var result = await runAsync(
              Stripe.instance.confirmSetupIntent(
                _provider.setupIntent!.clientSecret,
                PaymentMethodParams.card(billingDetails: details),
              ),
            );

            if (result[1] != null) {
              failedSnackBar(
                context: context,
                msg: 'Failed to save card',
              );
            } else {
              if (result[0] == null) {
                failedSnackBar(
                  context: context,
                  msg: 'Something went wrong, Please try again',
                );
                return;
              }

              /// Update setup intent
              _provider.setSetupIntent(result[0]);

              /// Update user's payment cards
              var res = await _service.getUserPaymentCards(
                _user.user?.id ?? '',
                _user.token ?? '',
              );
              if (!res['error'] || res['cards'] != null) {
                _provider.updateCards(res['cards']);
              }

              successSnackBar(
                context: context,
                msg: 'Card saved successfully',
              );
            }

            setState(() => loading = false);
          },
        ),
      ],
    );
  }
}

/// User saved payment cards
class _UserPaymentCardsInfo extends StatelessWidget {
  const _UserPaymentCardsInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Saved cards', style: DesignSystem.heading4),
        DesignSystem.spaceH20,
        const DashedSeparator(height: 1.6),
        DesignSystem.spaceH20,
        ChangeNotifierProvider(
          create: (context) => UserPaymentProvider(),
          child: const _PaymentCardsSection(),
        ),
      ],
    );
  }
}

/// Payment cards section
class _PaymentCardsSection extends StatelessWidget {
  const _PaymentCardsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserProvider>(context);
    final _provider = Provider.of<UserPaymentProvider>(context);

    return FutureBuilder(
      future: _provider.getPaymentCards(
        _user.user?.id ?? '',
        _user.token ?? '',
      ),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) return const SearchLoader();
        if (_provider.error) {
          failedSnackBar(context: context, msg: _provider.msg);
          return const LogoTV();
        }

        if (_provider.cards.isEmpty) {
          return Center(
            child: Text(
              'No saved cards',
              style: DesignSystem.bodyIntro,
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: _provider.cards.length,
          itemBuilder: (context, idx) {
            return _PaymentCard(
              card: _provider.cards[idx],
              topLeftRadius: idx == 0 ? 14 : 0,
              topRightRadius: idx == 0 ? 14 : 0,
              bottomLeftRadius: idx == _provider.cards.length - 1 ? 14 : 0,
              bottomRightRadius: idx == _provider.cards.length - 1 ? 14 : 0,
            );
          },
        );
      },
    );
  }
}

/// This card will be user's saved payment card
class _PaymentCard extends StatelessWidget {
  final dynamic card;
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomRightRadius;
  final double bottomLeftRadius;

  const _PaymentCard({
    Key? key,
    required this.card,
    required this.topLeftRadius,
    required this.topRightRadius,
    required this.bottomLeftRadius,
    required this.bottomRightRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildCardBody();
  }

  Widget _buildCardBody() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      decoration: BoxDecoration(
        color: DesignSystem.card,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(bottomLeftRadius),
          bottomRight: Radius.circular(bottomRightRadius),
          topLeft: Radius.circular(topLeftRadius),
          topRight: Radius.circular(topRightRadius),
        ),
      ),
      child: _buildCardInfo(),
    );
  }

  Widget _buildCardInfo() {
    var data = card['card'];
    var text =
        "${data['brand']} **** **** **** ${data['last4']} expires ${data['exp_month']}/${data['exp_year']}";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(IconlyLight.wallet),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: DesignSystem.caption,
          ),
        ),
      ],
    );
  }
}
