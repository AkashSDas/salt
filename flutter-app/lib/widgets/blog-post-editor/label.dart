import 'package:flutter/material.dart';

class FormInputLabel extends StatelessWidget {
  final String label;
  const FormInputLabel({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: Theme.of(context).textTheme.subtitle2?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: Colors.black,
            ),
      ),
    );
  }
}
