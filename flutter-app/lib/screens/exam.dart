import 'package:flutter/material.dart';
import 'package:salt/services/exam.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';

import '../design_system.dart';

class ExamScreen extends StatelessWidget {
  const ExamScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      bottomNavIdx: 0,
      children: [DesignSystem.spaceH20, OrdersResult()],
    );
  }
}

class OrdersResult extends StatelessWidget {
  final service = ExamService();
  OrdersResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: service.getOrders(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        var orders = snapshot.data.data['orders'];

        return Container(
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (context, idx) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                orders[idx].toString(),
                style: DesignSystem.bodyMain,
              ),
            ),
          ),
        );
      },
    );
  }
}
