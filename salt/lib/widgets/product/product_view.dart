import 'package:flutter/material.dart';
import 'package:salt/models/product/product.dart';
import 'package:salt/widgets/animated_drawer/animated_drawer.dart';

class ProductViewScreen extends StatelessWidget {
  final Product product;
  const ProductViewScreen({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      body: ListView(
        children: [],
      ),
    );
  }
}
