import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/services/auth.dart';
import 'package:salt/utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<bool> _logout(BuildContext context) async {
    var response = await logout();

    if (response[1] != null) {
      _invalidSnackBarMsg(context, 'Something went wrong, Please try again');
    } else {
      if (response[0]['error']) {
        _invalidSnackBarMsg(context, response[0]['message']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Successfully logged out',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ));
        return true;
      }
    }
    return false;
  }

  void _invalidSnackBarMsg(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    ));
  }

  bool logoutUser = false;

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = Provider.of<UserProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(text: 'My work'),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/blog-posts/user');
                    },
                    child: ListTile(
                      leading: FlareActor(
                        'assets/flare/icons/static/document.flr',
                        sizeFromArtboard: true, // 24x24 (of icon)
                      ),
                      title: Text('Blog posts'),
                    ),
                  ),

                  /// TODO: update icon
                  ListTile(
                    leading: FlareActor(
                      'assets/flare/icons/static/menu.flr',
                      sizeFromArtboard: true, // 24x24 (of icon)
                    ),
                    title: Text('Recipes'),
                  ),
                  Divider(),
                  Header(text: 'Authentication'),
                  SizedBox(height: 8),
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
                        EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      ),
                    ),
                    onPressed: () async {
                      bool loggedOut = await _logout(context);
                      if (loggedOut) {
                        _user.logout();
                        await Future.delayed(Duration(seconds: 1));
                        Navigator.popAndPushNamed(context, '/home');
                      }
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Sofia Pro',
                        fontWeight: FontWeight.w900,
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
    );
  }
}

class Header extends StatelessWidget {
  final String text;
  const Header({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyText2?.copyWith(
            color: Theme.of(context).textTheme.headline1?.color,
            fontWeight: FontWeight.w700,
          ),
    );
  }
}
