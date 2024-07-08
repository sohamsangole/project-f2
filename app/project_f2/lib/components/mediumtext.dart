import 'package:flutter/material.dart';

class MediumText extends StatelessWidget {
  final String data;
  const MediumText({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
