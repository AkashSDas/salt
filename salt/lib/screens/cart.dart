import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/cart.dart';
import 'package:salt/widgets/alerts/index.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<UserCartProvider>(
        context,
        listen: false,
      ).getAll(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<UserCartProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('My Cart', style: DesignSystem.heading4),
          const SizedBox(height: 16),
          _p.loading
              ? const CircularProgressIndicator()
              : ListView.separated(
                  separatorBuilder: (context, idx) {
                    return const SizedBox(height: 24);
                  },
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: _p.products.length,
                  itemBuilder: (context, idx) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 110,
                          height: 130,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: DesignSystem.gallery,
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: NetworkImage(
                                _p.products[idx].coverImgURLs[0],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _p.products[idx].title,
                                style: DesignSystem.heading4.copyWith(
                                  fontSize: 17,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _p.products[idx].price.toString(),
                                style: DesignSystem.bodyIntro.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        // color: DesignSystem.gallery,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: DesignSystem.tundora),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              _p.updateProductQuantity(context,
                                                  _p.products[idx].id, -1);
                                            },
                                            icon: const Icon(Icons.remove),
                                          ),
                                          const SizedBox(width: 16),
                                          Text(
                                            _p.products[idx].quantity
                                                .toString(),
                                            style:
                                                DesignSystem.bodyIntro.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          IconButton(
                                            onPressed: () {
                                              _p.updateProductQuantity(context,
                                                  _p.products[idx].id, 1);
                                            },
                                            icon: const Icon(Icons.add),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                        // color: DesignSystem.gallery,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: DesignSystem.tundora)),
                                    child: IconButton(
                                      onPressed: () {
                                        _p.removeProduct(_p.products[idx].id);

                                        successSnackBar(
                                          context: context,
                                          msg: 'Successfully removed item',
                                        );
                                      },
                                      icon: const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: FlareActor(
                                            'assets/flare-icons/delete.flr',
                                            animation: 'idle',
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ],
      ),
    );
  }
}
