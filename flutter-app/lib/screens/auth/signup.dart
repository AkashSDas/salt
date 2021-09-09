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
        ],
      ),
    );
  }
}
