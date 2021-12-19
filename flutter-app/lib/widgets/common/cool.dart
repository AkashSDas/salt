import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:salt/design_system.dart';

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

/// Others long card
class OthersLongCard extends StatelessWidget {
  final void Function()? onTap;
  const OthersLongCard({required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 200,
        width: 130,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: DesignSystem.purple,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              height: 40,
              width: 40,
              child: FlareActor(
                'assets/flare/other-emojis/smiling-face-with-sunglasses.flr',
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: 'go',
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Others',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: DesignSystem.fontHighlight,
                fontSize: 17,
                color: DesignSystem.text1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Others short card
class OthersShortCard extends StatelessWidget {
  final void Function()? onTap;
  const OthersShortCard({required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: DesignSystem.purple,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Stack(
          fit: StackFit.loose,
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeading(),
                  const SizedBox(height: 4),
                  _buildLabel(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel() {
    return const Text(
      'Others',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: DesignSystem.fontHighlight,
        fontSize: 17,
        color: DesignSystem.text1,
      ),
    );
  }

  Widget _buildHeading() {
    return const SizedBox(
      height: 40,
      width: 40,
      child: FlareActor(
        'assets/flare/other-emojis/smiling-face-with-sunglasses.flr',
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: 'go',
      ),
    );
  }
}
