import 'package:flutter/material.dart';
import 'package:salt/services/product.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';

import '../design_system.dart';

class CheckoutScreen extends StatelessWidget {
  final _service = ProductService();
  CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      children: [
        const SizedBox(height: 20),
        Text(
          'Checkout',
          style: DesignSystem.heading4,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        FutureBuilder(
          future: _service.getTotalCartPrice(),
          builder: (context, AsyncSnapshot<double> snapshot) {
            if (!snapshot.hasData) {
              return Text(
                'Total amount is 0',
                style: DesignSystem.bodyMain,
                textAlign: TextAlign.center,
              );
            }

            return Text(
              'Total amount is \$${snapshot.data ?? 0}',
              style: DesignSystem.bodyMain,
              textAlign: TextAlign.center,
            );
          },
        ),
      ],
    );
  }
}
