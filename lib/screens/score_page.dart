import 'package:flutter/material.dart';
import '../utils/scoring.dart';
import '../services/score_saver.dart';

class ScorePage extends StatelessWidget {
  final List<Map<String, dynamic>> videoSections;
  final Map<int, List<Duration>> sectionUserTimestamps;

  const ScorePage({
    required this.videoSections,
    required this.sectionUserTimestamps,
  });

  String _formatDuration(Duration duration) {
    final seconds = duration.inSeconds;
    final hundredths = ((duration.inMilliseconds % 1000) / 10).round();
    return '${seconds}.${hundredths.toString().padLeft(2, '0')}s';
  }

  String buildExportContent() {
    final buffer = StringBuffer();
    for (int index = 0; index < videoSections.length; index++) {
      final section = videoSections[index];
      final label = section['label'];
      final correct =
          (section['correctTimestamps'] as List<dynamic>? ?? [])
              .cast<Duration>();
      final user = sectionUserTimestamps[index] ?? [];

      final result = calculateSectionScore(user, correct);

      buffer.writeln('== $label ==');
      buffer.writeln('Score: ${result['score']}');
      buffer.writeln('Matched:');
      for (var m in result['matches']) {
        buffer.writeln(
          '- ${_formatDuration(m['correct'])} ↔ ${_formatDuration(m['user'])} (diff: ${(m['diff'] / 10).toStringAsFixed(2)}s, +${m['diff'] < 300 ? 10 : 5} pts)',
        );
      }
      buffer.writeln('Missed Correct:');
      for (var miss in result['missedCorrect']) {
        buffer.writeln('- ${_formatDuration(miss)} (-5 pts)');
      }
      buffer.writeln('Extra User Timestamps:');
      for (var extra in result['missedUser']) {
        buffer.writeln('- ${_formatDuration(extra)} (-5 pts)');
      }
      buffer.writeln('\n');
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Score Breakdown')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                final content = buildExportContent();
                await exportScoreToDownloads('listenup_score.txt', content);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Score saved to Downloads'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text('Export Results'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: videoSections.length,
              itemBuilder: (context, index) {
                final section = videoSections[index];
                final label = section['label'];
                final correctTimestamps =
                    (section['correctTimestamps'] as List<dynamic>? ?? [])
                        .cast<Duration>();
                final userTimestamps = sectionUserTimestamps[index] ?? [];

                final result = calculateSectionScore(
                  userTimestamps,
                  correctTimestamps,
                );

                return Card(
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$label',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Score: ${result['score']}'),
                        SizedBox(height: 8),
                        Text('Matched:'),
                        for (var match in result['matches'])
                          Text(
                            '- ${_formatDuration(match['correct'])} ↔ ${_formatDuration(match['user'])} '
                            '(diff: ${(match['diff'] / 10).toStringAsFixed(2)}s, '
                            '+${match['diff'] < 300 ? 10 : 5} pts)',
                            style: TextStyle(
                              color:
                                  match['diff'] < 300
                                      ? Colors.green
                                      : Colors
                                          .orange, // 10 pts = green, 5 pts = yellow/orange
                            ),
                          ),
                        SizedBox(height: 6),
                        Text('Missed Correct:'),
                        for (var miss in result['missedCorrect'])
                          Text(
                            '- ${_formatDuration(miss)} (-5 pts)',
                            style: TextStyle(color: Colors.red),
                          ),
                        SizedBox(height: 6),
                        Text('Extra User Timestamps:'),
                        for (var extra in result['missedUser'])
                          Text(
                            '- ${_formatDuration(extra)} (-5 pts)',
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
