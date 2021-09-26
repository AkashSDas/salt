import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:salt/services/product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<dynamic> _getAllProductsInCart;

  @override
  void initState() {
    super.initState();
    _getAllProductsInCart = getAllProductsInCart();
  }

  /// TODO: add feature for updating product quantity
  /// here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: FutureBuilder(
          future: _getAllProductsInCart,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();

            /// Here things can in _data cannot be null since they were
            /// created by object that have no null values exists
            final _data = jsonDecode(snapshot.data.toString()) as List;
            return ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, idx) => Container(
                child: Column(
                  children: [],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
