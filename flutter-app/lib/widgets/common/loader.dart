import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class SearchLoader extends StatelessWidget {
  const SearchLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: const SizedBox(
        height: 60,
        width: 60,
        child: FlareActor(
          'assets/flare/other-emojis/search.flr',
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: 'go',
        ),
      ),
    );
  }
}
