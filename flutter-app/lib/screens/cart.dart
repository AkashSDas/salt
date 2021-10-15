import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/services/product.dart';
import 'package:salt/utils.dart';
import 'package:salt/widgets/common/btns.dart';
import 'package:salt/widgets/common/snackbar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<dynamic> _getAllProductsInCart;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _getAllProductsInCart = getAllProductsInCart();
  }

  /// TODO: add feature for updating product quantity
  /// here

  @override
  Widget build(BuildContext context) {
    UserProvider _user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        padding: EdgeInsets.all(16),
        child: FutureBuilder(
          future: _getAllProductsInCart,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();

            /// Here things can in _data cannot be null since they were
            /// created by object that have no null values exists
            final _data = jsonDecode(snapshot.data.toString()) as List;
            return ListView(
              clipBehavior: Clip.none,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _data.length,
                  itemBuilder: (context, idx) => CartProductCard(
                    product: _data[idx],
                  ),
                ),
                SizedBox(height: 32),
                CardField(
                  // onCardChanged: (card) {},
                  cursorColor: DesignSystem.grey3,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                    fillColor: DesignSystem.grey1,
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    // border: InputBorder.none,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    hintStyle: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: DesignSystem.grey3.withOpacity(0.5),
                        ),
                  ),
                ),
                SizedBox(height: 32),
                ExpandedButton(
                  text: loading ? 'Loading...' : 'Checkout',
                  onPressed: () async {
                    /// User data
                    final details = BillingDetails(
                      email: _user.user?.email ?? '',

                      /// TODO: Add address and other infos here
                    );

                    /// create payment method
                    final paymentMethod =
                        await Stripe.instance.createPaymentMethod(
                      PaymentMethodParams.card(billingDetails: details),
                    );

                    setState(() {
                      loading = true;
                    });

                    /// API call
                    final data = await runAsync(
                      Dio().post(
                        "${dotenv.env['BACKEND_API_BASE_URL']}payment/stripe/payment/${_user.user?.id}",
                        data: {
                          'amount': 5 * 100,
                          'payment_method': paymentMethod.id,
                        },
                        options: Options(
                          validateStatus: (int? status) => status! < 500,
                          headers: {
                            'Authorization': 'Bearer ${_user.token}',
                          },
                        ),
                      ),
                    );

                    setState(() {
                      loading = false;
                    });

                    if (data[1] != null) {
                      failedSnackBar(context: context, msg: 'Checkout failed');
                    } else {
                      final response = data[0];

                      if (response.data['error'])
                        failedSnackBar(
                          context: context,
                          msg: 'Checkout failed',
                        );
                      else
                        successSnackBar(
                          context: context,
                          msg: 'Successfully paid',
                        );
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CartProductCard extends StatefulWidget {
  final product;
  const CartProductCard({required this.product, Key? key}) : super(key: key);

  @override
  _CartProductCardState createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    quantity = widget.product['quantity'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: DesignSystem.subtleBoxShadow,
      ),
      child: Container(
        margin: EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCoverImg(),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product['title'],
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(height: 8),
                  Text('Price: ${widget.product["price"]}'),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: DesignSystem.grey4,
                              width: 0.5,
                            )),
                        child: IconButton(
                          onPressed: () async {
                            /// TODO: add constraint on how much can be added
                            var res = await updateProductQuantityInCart(
                              widget.product['id'],
                              1,
                            );
                            if (res) {
                              setState(() {
                                quantity = quantity + 1;
                              });
                            }
                          },
                          icon: Icon(Icons.add),
                        ),
                      ),
                      SizedBox(width: 4),
                      Container(
                        padding: EdgeInsets.all(16),
                        // decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(12),
                        //     border: Border.all(
                        //       color: DesignSystem.grey4,
                        //       width: 0.5,
                        //     )),
                        child: Center(
                          child: Text(
                            '$quantity',
                            style:
                                Theme.of(context).textTheme.bodyText1?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                        ),
                      ),
                      SizedBox(width: 4),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: DesignSystem.grey4,
                              width: 0.5,
                            )),
                        child: IconButton(
                          onPressed: () async {
                            /// TODO: add constraint on how much can be substracted
                            var res = await updateProductQuantityInCart(
                              widget.product['id'],
                              -1,
                            );
                            if (res) {
                              setState(() {
                                quantity = quantity - 1;
                              });
                            }
                          },
                          icon: Icon(Icons.remove),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    child: ExpandedButton(
                      text: 'Remove',
                      onPressed: () async {
                        /// TODO: Check for auth before adding things to cart
                        String productId = widget.product['id'];
                        var response = await removeProductFromCart(productId);
                        if (response)
                          successSnackBar(
                            context: context,
                            msg: 'Successfully removed item from cart',
                          );
                        else
                          failedSnackBar(
                            context: context,
                            msg: 'Failed to removed item from cart',
                          );
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImg() {
    return Container(
      height: 200,
      width: 150,
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: DesignSystem.grey1,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(widget.product['coverImgURLs'][0]),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
