import 'package:flutter/material.dart';
import 'recording_page.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> videos = [
    {
      'path': 'assets/videos/PAOK.mp4',
      'title': 'PAOK',
      'sections': [
        {
          'label': 'Pass 1',
          'start': Duration(seconds: 0),
          'end': Duration(seconds: 38, milliseconds: 700),
          'correctTimestamps': [], // No correct timestamps for Pass 1
        },
        {
          'label': 'Pass 2',
          'start': Duration(seconds: 44, milliseconds: 300),
          'end': Duration(seconds: 71, milliseconds: 700),
          'correctTimestamps': [
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
          ],
        },
        {
          'label': 'Pass 3',
          'start': Duration(seconds: 77),
          'end': Duration(seconds: 106, milliseconds: 700),
          'correctTimestamps': [
            // Duration(minutes: 1, seconds: 22, milliseconds: 700),
            // Duration(minutes: 1, seconds: 25, milliseconds: 900),
            // Duration(minutes: 1, seconds: 28, milliseconds: 200),
            // Duration(minutes: 1, seconds: 30, milliseconds: 000),
            // Duration(minutes: 1, seconds: 32, milliseconds: 300),
            // Duration(minutes: 1, seconds: 35, milliseconds: 700),
            // Duration(minutes: 1, seconds: 38, milliseconds: 800),
            // Duration(minutes: 1, seconds: 41, milliseconds: 100),
            // Duration(minutes: 1, seconds: 42, milliseconds: 900),
            // Duration(minutes: 1, seconds: 45, milliseconds: 300),
          ],
        },
      ],
    },
    {
      'path': 'assets/videos/PAO.mp4',
      'title': 'PAO',
      'sections': [
        {
          'label': 'Pass 1',
          'start': Duration(seconds: 0),
          'end': Duration(seconds: 61, milliseconds: 700),
          'correctTimestamps': [], // No correct timestamps for Pass 1
        },
        {
          'label': 'Pass 2',
          'start': Duration(seconds: 67, milliseconds: 300),
          'end': Duration(seconds: 118, milliseconds: 600),
          'correctTimestamps': [
            Duration(minutes: 1, seconds: 11, milliseconds: 300),
            Duration(minutes: 1, seconds: 18, milliseconds: 300),
            Duration(minutes: 1, seconds: 25, milliseconds: 800),
            Duration(minutes: 1, seconds: 33, milliseconds: 500),
            Duration(minutes: 1, seconds: 40, milliseconds: 500),
            Duration(minutes: 1, seconds: 47, milliseconds: 100),
            Duration(minutes: 1, seconds: 54, milliseconds: 500),
          ],
        },
        {
          'label': 'Pass 3',
          'start': Duration(seconds: 125, milliseconds: 100),
          'end': Duration(seconds: 175, milliseconds: 700),
          'correctTimestamps': [
            // Duration(minutes: 2, seconds: 9, milliseconds: 100),
            // Duration(minutes: 2, seconds: 14, milliseconds: 900),
            // Duration(minutes: 2, seconds: 22, milliseconds: 200),
            // Duration(minutes: 2, seconds: 28, milliseconds: 300),
            // Duration(minutes: 2, seconds: 37, milliseconds: 400),
            // Duration(minutes: 2, seconds: 44, milliseconds: 200),
            // Duration(minutes: 2, seconds: 51, milliseconds: 700),
          ],
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return ListTile(
            title: Text(video['title']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => RecordingPage(
                        videoPath: video['path'],
                        videoTitle: video['title'],
                        videoSections: video['sections'],
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
