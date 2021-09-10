import 'package:flutter/material.dart';
import 'package:salt/designs/designs.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          width: double.infinity,
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(32),
            boxShadow: DesignSystem.subtleBoxShadow,
          ),
          child: Column(
            children: [
              Header(),
            ],
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 32),
      child: Column(
        children: [
          Text(
            'salt',
            style: Theme.of(context).textTheme.headline1?.copyWith(
              fontSize: 60,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  offset: Offset(0, 16),
                  blurRadius: 32,
                  color: Color(0xffFFC21E).withOpacity(0.3),
                ),
                Shadow(
                  offset: Offset(0, -8),
                  blurRadius: 32,
                  color: Color(0xffFFC21E).withOpacity(0.3),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'All you need for your greedy stomach',
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          Container(
            child: AuthSection(),
          ),
        ],
      ),
    );
  }
}

class AuthSection extends StatefulWidget {
  const AuthSection({Key? key}) : super(key: key);

  @override
  _AuthSectionState createState() => _AuthSectionState();
}

class _AuthSectionState extends State<AuthSection>
    with SingleTickerProviderStateMixin {
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
    return Column(
      children: [
        TabBar(
          controller: _tabCtrl,
          indicator: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black)),
            color: DesignSystem.grey1,
          ),
          labelColor: Theme.of(context).textTheme.headline1?.color,
          // unselectedLabelColor: Theme.of(context).textTheme.headline1?.color,
          tabs: [
            Tab(
              child: Text(
                'Login',

                /// To have selected and unselected colors, instead of using
                /// Theme.of, provide TextStyle directly here
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Sofia Pro',
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Signup',
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Sofia Pro',
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            )
          ],
        ),
        Container(
          height: 80,
          child: TabBarView(
            controller: _tabCtrl,
            children: [
              Center(child: Text('Login')),
              Center(child: Text('Signup')),
            ],
          ),
        ),
      ],
    );
  }
}
