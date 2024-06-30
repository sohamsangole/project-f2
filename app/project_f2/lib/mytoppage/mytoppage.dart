import 'package:flutter/material.dart';

class MyTopMusic extends StatefulWidget {
  const MyTopMusic({super.key});

  @override
  State<MyTopMusic> createState() => _MyTopMusicState();
}

class _MyTopMusicState extends State<MyTopMusic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("My Top Page")),
    );
  }
}
