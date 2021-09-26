import 'package:flutter/material.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/services/product.dart';
import 'package:salt/widgets/blog-post/blog-post-list-item-loader.dart';
import 'package:salt/widgets/common/bottom-nav.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ScrollController _ctrl = ScrollController();

  List<dynamic> products = [];
  bool loading = false;
  bool firstLoading = false;
  bool reachedEnd = false;
  bool hasNext = false;
  String nextId = '';

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
        appBar: AppBar(),
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
          itemBuilder: (context, idx) => Container(
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
