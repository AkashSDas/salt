import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          ListTile(
            leading: const SizedBox(
              height: 24,
              width: 24,
              child: FlareActor(
                'assets/flare-icons/document.flr',
                alignment: Alignment.center,
                animation: 'idle',
                sizeFromArtboard: true,
              ),
            ),
            title: Text('Blog posts', style: DesignSystem.heading4),
          ),
        ],
      ),
      // child: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //     ],
      //   ),
      // ),
    );
  }
}
