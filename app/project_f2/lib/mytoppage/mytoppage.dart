import 'package:flutter/material.dart';
import 'package:project_f2/components/largetext.dart';

class MyTopMusic extends StatefulWidget {
  const MyTopMusic({super.key});

  @override
  State<MyTopMusic> createState() => _MyTopMusicState();
}

class _MyTopMusicState extends State<MyTopMusic> {
  final List<String> topItems = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const LargeText(
                data: "My Top 5",
              ),
              const SizedBox(height: 20),
              ...List.generate(
                topItems.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.transparent.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset:
                              const Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      topItems[index],
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
