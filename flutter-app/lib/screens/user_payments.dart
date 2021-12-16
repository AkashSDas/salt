import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/user_payment.dart';
import 'package:salt/providers/user_provider.dart';
import 'package:salt/services/payment.dart';
import 'package:salt/widgets/common/alert.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';
import 'package:salt/widgets/drawer/drawer_body.dart';

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
              _user.token != null
                  ? const _UserPaymentCardsInfo()
                  : Center(
                      child: Text(
                        'You are not logged in',
                        style: DesignSystem.bodyIntro,
                      ),
                    ),
            ],
          ),
        ),
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
          child: _UserPaymentCards(),
        ),
      ],
    );
  }
}

class _UserPaymentCards extends StatelessWidget {
  final _service = PaymentService();
  _UserPaymentCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserPaymentProvider>(context);
    final _user = Provider.of<UserProvider>(context);

    return FutureBuilder(
        future: _service.getUserPaymentCards(
          _user.user?.id ?? '',
          _user.token ?? '',
        ),
        builder: (context, AsyncSnapshot<Map> snapshot) {
          if (!snapshot.hasData) return const SearchLoader();
          var data = snapshot.data!; // null check
          if (data['error'] || data['cards'] == null) {
            failedSnackBar(context: context, msg: data['msg']);
            return const LogoTV();
          }

          if (data['cards'] != null) {
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
              return _CreditCard(card: _provider.cards[idx]);
            },
          );
        });
  }
}

class _CreditCard extends StatelessWidget {
  final dynamic card;
  const _CreditCard({required this.card, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DesignSystem.card,
      child: Text('$card'),
    );
  }
}
