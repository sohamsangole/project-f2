import 'package:flutter/material.dart';

class LargeText extends StatelessWidget {
  final String data;
  const LargeText({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
