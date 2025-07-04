import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../services/audio_recorder.dart';
import '../services/file_saver.dart';
import '../utils/scoring.dart';

class RecordingPage extends StatefulWidget {
  final String videoPath;
  final String videoTitle;
  final List<Duration> correctTimestamps;

  RecordingPage({
    required this.videoPath,
    required this.videoTitle,
    required this.correctTimestamps,
  });

  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  late VideoPlayerController _videoController;
  final AudioRecorderService _audioService = AudioRecorderService();
  Duration _currentPosition = Duration.zero;
  bool _isRecording = false;
  bool _recordingFinished = false;
  List<Duration> _timestamps = [];
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _initVideo();
    _audioService.initRecorder().then((_) {
      setState(() {
        _audioPath = _audioService.filePath;
      });
    });
  }

  Future<void> _initVideo() async {
    _videoController = VideoPlayerController.asset(widget.videoPath);
    await _videoController.initialize();

    _videoController.addListener(() {
      if (_videoController.value.isInitialized) {
        setState(() {
          _currentPosition = _videoController.value.position;
        });
      } // Triggers UI updates on play/pause/etc.
    });

    setState(() {});
  }

  Future<void> _startRecording() async {
    await _audioService.startRecording();
    setState(() {
      _isRecording = true;
      _recordingFinished = false;
    });
  }

  Future<void> _stopRecording() async {
    await _audioService.stopRecording();
    setState(() {
      _isRecording = false;
      _recordingFinished = true;
    });
  }

  Future<void> _saveRecording() async {
    if (_audioPath != null) {
      await saveRecordingToDownloads(_audioPath!, context);
      setState(() {
        _recordingFinished = false;
      });
    }
  }

  void _addTimestamp() {
    if (_videoController.value.isInitialized) {
      setState(() {
        _timestamps.add(_videoController.value.position);
      });
    }
  }

  String _formatDuration(Duration d) {
    return "${d.inSeconds}.${(d.inMilliseconds % 1000 ~/ 100)}s";
  }

  String _formatPlaybackTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _videoController.dispose();
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.videoTitle)),
      body: Column(
        children: [
          if (_videoController.value.isInitialized)
            AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: VideoPlayer(_videoController),
            ),
          Text(
            "${_formatPlaybackTime(_currentPosition)} / ${_formatPlaybackTime(_videoController.value.duration)}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
<<<<<<< HEAD
                onPressed:
                    _videoController.value.isPlaying
                        ? _videoController.pause
                        : _videoController.play,
=======
                onPressed: _videoController.value.isPlaying
                    ? _videoController.pause
                    : _videoController.play,
>>>>>>> 1f9803a (Initial commit of ListenUp Flutter app)
                child: Icon(
                  _videoController.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: _isRecording ? _stopRecording : _startRecording,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRecording ? Colors.red : null,
                  foregroundColor: _isRecording ? Colors.white : null,
                ),
                child: Text(
                  _isRecording ? "Stop Recording" : "Start Recording",
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: _addTimestamp,
                child: Text("Add Timestamp"),
              ),
            ],
          ),
          if (_recordingFinished)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _saveRecording,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text("Save Recording"),
              ),
            ),
          SizedBox(height: 20),
          Text("Timestamps:", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: _timestamps.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    "Timestamp ${index + 1}: ${_formatDuration(_timestamps[index])}",
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              int score = calculateScore(_timestamps, widget.correctTimestamps);
              showDialog(
                context: context,
<<<<<<< HEAD
                builder:
                    (_) => AlertDialog(
                      title: Text("Your Score"),
                      content: Text(
                        "$score / ${widget.correctTimestamps.length * 10}",
                      ),
                    ),
=======
                builder: (_) => AlertDialog(
                  title: Text("Your Score"),
                  content: Text(
                    "$score / ${widget.correctTimestamps.length * 10}",
                  ),
                ),
>>>>>>> 1f9803a (Initial commit of ListenUp Flutter app)
              );
            },
            child: Text("Calculate Score"),
          ),
        ],
      ),
    );
  }
}
