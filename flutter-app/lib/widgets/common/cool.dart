import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

/// Logo TV

class LogoTV extends StatefulWidget {
  const LogoTV({Key? key}) : super(key: key);

  @override
  State<LogoTV> createState() => _LogoTVState();
}

class _LogoTVState extends State<LogoTV> {
  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => toggle = !toggle),
      child: SizedBox(
        height: 120,
        width: 120,
        child: FlareActor(
          'assets/flare/other-emojis/tv.flr',
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: !toggle ? 'logo rotate' : 'color change',
        ),
      ),
    );
  }
}
