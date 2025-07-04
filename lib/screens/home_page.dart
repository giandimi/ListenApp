import 'package:flutter/material.dart';
import 'recording_page.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, String>> videoList = [
    {'title': 'PAO', 'path': 'assets/videos/PAO.mp4'},
    {'title': 'PAOK', 'path': 'assets/videos/PAOK.mp4'},
  ];

  final Map<String, List<Duration>> correctTimestampsMap = {
    'assets/videos/PAO.mp4': [
      //# PASS 2
      Duration(minutes: 1, seconds: 11, milliseconds: 300),
      Duration(minutes: 1, seconds: 18, milliseconds: 300),
      Duration(minutes: 1, seconds: 25, milliseconds: 800),
      Duration(minutes: 1, seconds: 33, milliseconds: 500),
      Duration(minutes: 1, seconds: 40, milliseconds: 500),
      Duration(minutes: 1, seconds: 47, milliseconds: 100),
      Duration(minutes: 1, seconds: 54, milliseconds: 500),
      //# PASS 3
      Duration(minutes: 2, seconds: 9, milliseconds: 100),
      Duration(minutes: 2, seconds: 14, milliseconds: 900),
      Duration(minutes: 2, seconds: 22, milliseconds: 200),
      Duration(minutes: 2, seconds: 28, milliseconds: 300),
      Duration(minutes: 2, seconds: 37, milliseconds: 400),
      Duration(minutes: 2, seconds: 44, milliseconds: 200),
      Duration(minutes: 2, seconds: 51, milliseconds: 700),
    ],
    'assets/videos/PAOK.mp4': [
      //# PASS 2
      Duration(seconds: 47, milliseconds: 900),
      Duration(seconds: 51, milliseconds: 100),
      Duration(seconds: 53, milliseconds: 400),
      Duration(seconds: 55, milliseconds: 000),
      Duration(seconds: 57, milliseconds: 400),
      Duration(minutes: 1, seconds: 00, milliseconds: 900),
      Duration(minutes: 1, seconds: 04, milliseconds: 100),
      Duration(minutes: 1, seconds: 06, milliseconds: 400),
      Duration(minutes: 1, seconds: 08, milliseconds: 100),
      Duration(minutes: 1, seconds: 10, milliseconds: 700),
      //# PASS 3
      Duration(minutes: 1, seconds: 22, milliseconds: 700),
      Duration(minutes: 1, seconds: 25, milliseconds: 900),
      Duration(minutes: 1, seconds: 28, milliseconds: 200),
      Duration(minutes: 1, seconds: 30, milliseconds: 000),
      Duration(minutes: 1, seconds: 32, milliseconds: 300),
      Duration(minutes: 1, seconds: 35, milliseconds: 700),
      Duration(minutes: 1, seconds: 38, milliseconds: 800),
      Duration(minutes: 1, seconds: 41, milliseconds: 100),
      Duration(minutes: 1, seconds: 42, milliseconds: 900),
      Duration(minutes: 1, seconds: 45, milliseconds: 300),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select a Video')),
      body: ListView.builder(
        itemCount: videoList.length,
        itemBuilder: (context, index) {
          final video = videoList[index];
          return ListTile(
            title: Text(video['title']!),
            trailing: Icon(Icons.play_circle_fill),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
<<<<<<< HEAD
                  builder:
                      (_) => RecordingPage(
                        videoPath: video['path']!,
                        videoTitle: video['title']!,
                        correctTimestamps:
                            correctTimestampsMap[video['path']!] ?? [],
                      ),
=======
                  builder: (_) => RecordingPage(
                    videoPath: video['path']!,
                    videoTitle: video['title']!,
                    correctTimestamps:
                        correctTimestampsMap[video['path']!] ?? [],
                  ),
>>>>>>> 1f9803a (Initial commit of ListenUp Flutter app)
                ),
              );
            },
          );
        },
      ),
    );
  }
}
