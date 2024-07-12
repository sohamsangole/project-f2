import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_f2/api.dart';
import 'package:project_f2/components/largetext.dart';
import 'package:project_f2/components/mediumtext.dart';

class MyTopMusic extends StatefulWidget {
  final String sessionId;
  final String baseUrl;

  const MyTopMusic({Key? key, required this.sessionId, required this.baseUrl})
      : super(key: key);

  @override
  State<MyTopMusic> createState() => _MyTopMusicState();
}

class _MyTopMusicState extends State<MyTopMusic> {
  final ApiService apiService = ApiService(); // Instance of your ApiService
  List<Map<String, dynamic>> topSongsLong = [];
  List<Map<String, dynamic>> topSongsMedium = [];
  List<Map<String, dynamic>> topSongsShort = [];
  String selectedCategory = "Short";
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    fetchtopSongsLong();
    fetchtopSongsMedium();
    fetchtopSongsShort();
    setState(() {
      isLoading = false;
    });
  }

  void fetchtopSongsLong() async {
    try {
      List<Map<String, dynamic>> topSongsLongData =
          await apiService.getTop5SongsLong(widget.baseUrl, widget.sessionId);
      List<Map<String, dynamic>> songs = [];

      for (var songData in topSongsLongData) {
        Map<String, dynamic> song = {
          'name': songData['name'] ?? 'Unknown',
          'artists': songData['artists'] ?? 'Unknown artist',
          'album': songData['album'] ?? 'Unknown album',
          'album_cover': songData['album_cover'] ?? '',
        };
        songs.add(song);
      }

      setState(() {
        topSongsLong = songs;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
    }
  }

  void fetchtopSongsMedium() async {
    try {
      List<Map<String, dynamic>> topSongsMediumData =
          await apiService.getTop5SongsMedium(widget.baseUrl, widget.sessionId);
      List<Map<String, dynamic>> songs = [];

      for (var songData in topSongsMediumData) {
        Map<String, dynamic> song = {
          'name': songData['name'] ?? 'Unknown',
          'artists': songData['artists'] ?? 'Unknown artist',
          'album': songData['album'] ?? 'Unknown album',
          'album_cover': songData['album_cover'] ?? '',
        };
        songs.add(song);
      }

      setState(() {
        topSongsMedium = songs;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
    }
  }

  void fetchtopSongsShort() async {
    try {
      List<Map<String, dynamic>> topSongsShortData =
          await apiService.getTop5SongsShort(widget.baseUrl, widget.sessionId);
      List<Map<String, dynamic>> songs = [];

      for (var songData in topSongsShortData) {
        Map<String, dynamic> song = {
          'name': songData['name'] ?? 'Unknown',
          'artists': songData['artists'] ?? 'Unknown artist',
          'album': songData['album'] ?? 'Unknown album',
          'album_cover': songData['album_cover'] ?? '',
        };
        songs.add(song);
      }

      setState(() {
        topSongsShort = songs;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: const Color(0xff121212),
        title: const LargeText(
          data: "Top Songs",
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                selectedCategory = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: '1 Week',
                  child: Row(
                    children: [
                      Icon(Icons.timeline_sharp, color: Colors.white),
                      SizedBox(width: 10),
                      Text('1 Week'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: '1 Month',
                  child: Row(
                    children: [
                      Icon(Icons.timeline_sharp, color: Colors.white),
                      SizedBox(width: 10),
                      Text('1 Month'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: '1 Year',
                  child: Row(
                    children: [
                      Icon(Icons.timeline_sharp, color: Colors.white),
                      SizedBox(width: 10),
                      Text('1 Year'),
                    ],
                  ),
                ),
              ];
            },
            color: const Color(0xff333333),
            icon: const Icon(Icons.filter_list_alt, color: Colors.white),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Colors.transparent,
                minHeight: 7.0,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: topSongsDisplay(),
              ),
            ),
    );
  }

  Widget topSongsDisplay() {
    List<Map<String, dynamic>> selectedSongs;

    switch (selectedCategory) {
      case "1 Year":
        selectedSongs = topSongsLong;
        break;
      case "1 Month":
        selectedSongs = topSongsMedium;
        break;
      case "1 Week":
      default:
        selectedSongs = topSongsShort;
        break;
    }

    return topSongs(selectedSongs);
  }

  Widget topSongs(List<Map<String, dynamic>> songData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ...songData.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> song = entry.value;
          return Padding(
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
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                    child: MediumText(data: '${index + 1}'),
                  ),
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: song['album_cover'] != null
                              ? NetworkImage(song['album_cover'])
                              : const AssetImage('assets/temp/songcover.jpeg')
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          utf8.decode(song['name'].codeUnits),
                          maxLines: 2, // Limit to 2 lines
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          maxLines: 3,
                          overflow: TextOverflow.fade,
                          'Artists: ${utf8.decode(song['artists'].codeUnits)}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        })
      ],
    );
  }
}
