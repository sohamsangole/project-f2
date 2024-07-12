import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:project_f2/api.dart';
import 'package:project_f2/components/largetext.dart';
import 'package:project_f2/components/mediumtext.dart';

class ProfilePage extends StatefulWidget {
  final String sessionId;
  final String baseUrl;
  const ProfilePage(
      {super.key, required this.sessionId, required this.baseUrl});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ApiService apiService = ApiService();
  Map<String, dynamic> currentSong = {};
  final List<LibraryItem> libraryItems = [
    LibraryItem(title: "Playlists"),
    LibraryItem(title: "Artists"),
    LibraryItem(title: "Friends"),
  ];
  @override
  void initState() {
    super.initState();
    fetchCurrentSong(); // Fetch current song data when the page initializes
  }

  // Function to fetch current song
  void fetchCurrentSong() async {
    try {
      // Make API call to fetch current song
      Map<String, dynamic> songData =
          await apiService.getCurrentSong(widget.baseUrl, widget.sessionId);
      songData['title'] = utf8.decode(songData['title'].codeUnits);
      setState(() {
        currentSong = songData;
      });
      print(currentSong);
    } catch (e) {
      // Handle error gracefully
    }
  }

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
              onTap: () {},
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
                height: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: currentSong['album_cover'] != null
                        ? NetworkImage(currentSong['album_cover'])
                        : const AssetImage('assets/temp/songcover.jpeg')
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment.center,
                              focalRadius: 100,
                              radius: 1,
                              colors: [
                                const Color(0xff121212).withOpacity(1),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentSong.containsKey('title')
                                ? currentSong['title']
                                : "No song playing",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            currentSong.containsKey('artist')
                                ? currentSong['artist']
                                : "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
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
