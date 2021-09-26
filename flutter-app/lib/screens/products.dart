import 'package:flutter/material.dart';
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

    var data = await getAllProducts(limit: 10);
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
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (firstLoading) return BlogPostListItemLoader();
    return Container(
      child: Text('${products}'),
    );
  }
}
