import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:project_f2/components/largetext.dart';
import 'package:project_f2/components/mediumtext.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<LibraryItem> libraryItems = [
    LibraryItem(title: "Playlists"),
    LibraryItem(title: "Artists"),
    LibraryItem(title: "Friends"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: const Color(0xff121212),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const LargeText(data: "ryo.ham"),
            GestureDetector(
              onTap: () {
                print('Icon tapped');
              },
              child: const Icon(Icons.settings),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundImage: AssetImage('assets/temp/pfp.jpeg'),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Soham Sangole",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  buildStatsColumn("4", "Playlists"),
                  buildStatsColumn("12K", "Followers"),
                  buildStatsColumn("8", "Following"),
                ],
              ),
              const SizedBox(height: 18),
              const MediumText(data: "Currently Playing"),
              const SizedBox(height: 6),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage("assets/temp/songcover.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment.center,
                              radius: 0.5,
                              colors: [
                                const Color(0xff121212).withOpacity(1),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Shitsu Koi",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "TakaseToya",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const MediumText(data: "Library"),
              Column(
                children: [
                  makeCard(LibraryItem(title: "Playlists")),
                  makeCard(LibraryItem(title: "Artists")),
                  makeCard(LibraryItem(title: "Albums")),
                ],
              ),
              const SizedBox(height: 18),
              const MediumText(data: "Recently Played"),
            ],
          ),
        ),
      ),
    );
  }

  Column buildStatsColumn(String number, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Card makeCard(LibraryItem libraryItems) => Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          child: makeLibraryTile(libraryItems),
        ),
      );

  ListTile makeLibraryTile(LibraryItem libraryItems) => ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
        title: Text(
          libraryItems.title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_right),
      );
}

class LibraryItem {
  final String title;

  LibraryItem({required this.title});
}
