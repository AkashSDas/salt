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
          Text('My Work', style: DesignSystem.heading4),
          const SizedBox(height: 8),
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
            title: const Text('Blog posts', style: DesignSystem.bodyIntro),
            onTap: () => Navigator.pushNamed(context, '/blog-posts/user'),
          ),
        ],
      ),
    );
  }
}
