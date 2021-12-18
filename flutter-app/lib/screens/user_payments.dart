import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/user_payment.dart';
import 'package:salt/providers/user_provider.dart';
import 'package:salt/services/payment.dart';
import 'package:salt/utils/index.dart';
import 'package:salt/widgets/common/alert.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/common/cool.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';

import '../design_system.dart';

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
              const SizedBox(height: 40),
              Text('My payment info', style: DesignSystem.heading1),
              const SizedBox(height: 20),
              const Divider(color: DesignSystem.border),
              const SizedBox(height: 20),
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
                        const SizedBox(height: 20),
                        const Divider(color: DesignSystem.border),
                        const SizedBox(height: 20),
                        ChangeNotifierProvider(
                          create: (context) => UserPaymentProvider(),
                          child: const SaveCreditCard(),
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

class SaveCreditCard extends StatefulWidget {
  const SaveCreditCard({Key? key}) : super(key: key);

  @override
  State<SaveCreditCard> createState() => _SaveCreditCardState();
}

class _SaveCreditCardState extends State<SaveCreditCard> {
  final _ctrl = CardEditController();
  var loading = false;
  final _service = PaymentService();

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserPaymentProvider>(context);
    final _user = Provider.of<UserProvider>(context);

    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Saved payment card', style: DesignSystem.heading4),
        ),
        const SizedBox(height: 20),
        _provider.setupIntent == null
            ? PrimaryButton(
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
              )
            : const SizedBox(),
        _provider.setupIntent != null
            ? Column(
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
              )
            : const SizedBox(),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _UserPaymentCardsInfo extends StatelessWidget {
  const _UserPaymentCardsInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Saved cards', style: DesignSystem.heading4),
        const SizedBox(height: 20),
        ChangeNotifierProvider(
          create: (context) => UserPaymentProvider(),
          child: const _UserPaymentCards(),
        ),
      ],
    );
  }
}

class _UserPaymentCards extends StatelessWidget {
  const _UserPaymentCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserPaymentProvider>(context);
    final _user = Provider.of<UserProvider>(context);

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
              return _CreditCard(
                card: _provider.cards[idx],
                topLeftRadius: idx == 0 ? 14 : 0,
                topRightRadius: idx == 0 ? 14 : 0,
                bottomLeftRadius: idx == _provider.cards.length - 1 ? 14 : 0,
                bottomRightRadius: idx == _provider.cards.length - 1 ? 14 : 0,
              );
            },
          );
        });
  }
}

class _CreditCard extends StatelessWidget {
  final dynamic card;
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomRightRadius;
  final double bottomLeftRadius;

  const _CreditCard({
    required this.card,
    required this.topLeftRadius,
    required this.topRightRadius,
    required this.bottomLeftRadius,
    required this.bottomRightRadius,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = card['card'];
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(IconlyLight.wallet),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "${data['brand']} **** **** **** ${data['last4']} expires ${data['exp_month']}/${data['exp_year']}",
              style: DesignSystem.caption,
            ),
          ),
        ],
      ),
    );
  }
}
