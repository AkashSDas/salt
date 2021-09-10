import 'package:flutter/material.dart';
import 'package:salt/widgets/auth-screen/promotion.dart';
import 'package:salt/widgets/auth-screen/signup.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    _tabCtrl = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Promotion(),
          SizedBox(height: 32),
          TabBar(
            controller: _tabCtrl,
            indicator: BoxDecoration(
              // color: DesignSystem.grey1,
              // borderRadius: BorderRadius.circular(8),
              border: Border(
                bottom: BorderSide(color: Colors.black, width: 2),
                // top: BorderSide(color: Colors.black, width: 2),
                // right: BorderSide(color: Colors.black, width: 2),
                // left: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Theme.of(context).textTheme.headline1?.color,
            tabs: [
              _buildTab('Login'),
              _buildTab('Signup'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                Center(child: Text('Login')),
                Center(child: Signup()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTab(String text) => Tab(
        child: Text(
          text,

          /// To have selected and unselected colors, instead of using
          /// Theme.of, provide TextStyle directly here
          style: TextStyle(
            fontSize: 17,
            fontFamily: 'Sofia Pro',
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
      );
}
