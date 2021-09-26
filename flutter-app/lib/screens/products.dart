import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/services/product.dart';
import 'package:salt/widgets/blog-post/blog-post-list-item-loader.dart';
import 'package:salt/widgets/common/bottom-nav.dart';
import 'package:salt/widgets/common/snackbar.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ScrollController _ctrl = ScrollController();
  final PageController _pgCtrl = PageController(viewportFraction: 0.8);

  List<dynamic> products = [];
  bool loading = false;
  bool firstLoading = false;
  bool reachedEnd = false;
  bool hasNext = false;
  String nextId = '';

  /// Quantity user wants to buy
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    _fetch();
    _ctrl.addListener(() {
      if (_ctrl.position.pixels >= _ctrl.position.maxScrollExtent &&
          !loading &&
          !reachedEnd) {
        _fetchMore();
      }
    });
  }

  Future<void> _fetch() async {
    setState(() {
      firstLoading = true;
    });

    var data = await getAllProducts(limit: 5);
    List<dynamic> newProducts = data[0]['data']['products'];

    /// TODO: Resolve setting state after widget is disposed error
    setState(() {
      products = [...products, ...newProducts];
      firstLoading = false;
      hasNext = data[0]['data']['hasNext'];
      nextId = data[0]['data']['next'];
    });

    if (hasNext == false)
      setState(() {
        reachedEnd = true;
      });
  }

  Future<void> _fetchMore() async {
    setState(() {
      loading = true;
    });

    var data = await getAllProducts(
      limit: 10,
      hasNext: hasNext,
      nextId: nextId,
    );
    List<dynamic> newProducts = data[0]['data']['products'];
    setState(() {
      products = [...products, ...newProducts];
      loading = false;
      hasNext = data[0]['data']['hasNext'];
      nextId = data[0]['data']['next'];
    });

    if (hasNext == false)
      setState(() {
        reachedEnd = true;
      });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/cart');
              },
              child: FlareActor(
                'assets/flare/icons/static/cart.flr',
                sizeFromArtboard: true, // 24x24 (of icon)
              ),
            ),
            SizedBox(width: 24),
          ],
        ),
        bottomNavigationBar: AppBottomNav(currentIndex: 2),
        body: Container(
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.all(16),
          height: double.infinity,
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (firstLoading) return BlogPostListItemLoader();
    return ListView(
      controller: _ctrl,
      children: [
        GridView.builder(
          itemCount: products.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, idx) => InkWell(
            onTap: () {
              /// Quantity user wants to buy
              int quantity = 0;

              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isDismissible: true,
                enableDrag: true,
                builder: (ctx) => Scaffold(
                  body: StatefulBuilder(
                    builder: (context, StateSetter setModalState) => Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: DesignSystem.grey1,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        boxShadow: DesignSystem.subtleBoxShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            products[idx].title,
                            style: Theme.of(ctx).textTheme.bodyText1?.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff212541),
                                ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            products[idx].description,
                            style: Theme.of(ctx)
                                .textTheme
                                .bodyText1
                                ?.copyWith(fontSize: 18),
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            child: PageView.builder(
                              controller: _pgCtrl,
                              itemCount: products[idx].coverImgURLs.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return InteractiveViewer(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    height: 221,
                                    width: 316,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          products[idx].coverImgURLs[index],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quantities left: ${products[idx].quantity_left}',
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Quantities sold: ${products[idx].quantity_sold}',
                              )
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                      onPressed: () {
                                        /// TODO: add constraint on how much can be added
                                        setModalState(() {
                                          quantity = quantity + 1;
                                        });
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
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
                                      onPressed: () {
                                        /// TODO: add constraint on how much can be substracted
                                        setModalState(() {
                                          quantity = quantity - 1;
                                        });
                                      },
                                      icon: Icon(Icons.remove),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 16),
                              TextButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).accentColor,
                                  ),
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 32),
                                  ),
                                ),
                                onPressed: () async {
                                  /// add item to cart
                                  /// TODO: later on just save the product id and and then when
                                  /// looking in the cart get the data from api. This is because
                                  /// the data here will be stale while the data the backend might
                                  /// change
                                  /// TODO: Check for auth before adding things to cart
                                  Map data = products[idx].toJson();
                                  bool result = await saveProductsToCart({
                                    ...data,
                                    'quantity': quantity,
                                  });
                                  if (result) {
                                    displaySnackBar(
                                      context: context,
                                      success: true,
                                      msg: 'Added to cart',
                                    );

                                    /// TODO: Reset the quantities
                                    setModalState(() {
                                      quantity = 0;
                                    });
                                  } else {
                                    displaySnackBar(
                                      context: context,
                                      success: false,
                                      msg: 'Could not add, Please try again',
                                    );
                                  }
                                },
                                child: Text(
                                  'Add to cart',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Sofia Pro',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: DesignSystem.grey1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 169,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(products[idx].coverImgURLs[0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    products[idx].title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          fontSize: 15,
                          color: DesignSystem.grey3,
                        ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${products[idx].price}',
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff51578D),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        _buildTheEnd(),
      ],
    );
  }

  Widget _buildTheEnd() {
    if (reachedEnd) return Text("You've reached the end");
    if (loading)
      return Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    return SizedBox(height: 32);
  }
}
