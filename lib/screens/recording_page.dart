import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart';
import 'score_page.dart';
import '../services/audio_recorder.dart';

class RecordingPage extends StatefulWidget {
  final String videoPath;
  final String videoTitle;
  final List<Map<String, dynamic>> videoSections;

  RecordingPage({
    required this.videoPath,
    required this.videoTitle,
    required this.videoSections,
  });

  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  String? recordedFilePath;
  late VideoPlayerController _videoController;
  late AudioRecorderService audioRecorder;
  late final AudioPlayer _audioPlayer;

  int currentSectionIndex = 0;
  Map<int, List<Duration>> sectionUserTimestamps = {};

  bool isRecording = false;
  bool showStartButton = true;
  bool showNextPassButton = false;
  bool showCalculateScoreButton = false;
  bool showPreview = false;
  bool showSaveButton = false;

  Duration get currentStart =>
      widget.videoSections[currentSectionIndex]['start'];
  Duration get currentEnd => widget.videoSections[currentSectionIndex]['end'];
  List<Duration> get currentCorrectTimestamps =>
      widget.videoSections[currentSectionIndex]['correctTimestamps'];
  String get currentLabel => widget.videoSections[currentSectionIndex]['label'];

  @override
  void initState() {
    super.initState();
    audioRecorder = AudioRecorderService();
    audioRecorder.initRecorder();

    _audioPlayer = AudioPlayer();

    _videoController = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
      });

    _videoController.addListener(() async {
      final pos = _videoController.value.position;

      // Auto start recording at the beginning of Pass 3
      if (currentSectionIndex == 2 &&
          pos >= currentStart &&
          !isRecording &&
          _videoController.value.isPlaying) {
        await audioRecorder.startRecording();
        setState(() => isRecording = true);
      }

      // Auto stop at end of Pass 3
      if (currentSectionIndex == 2 &&
          pos >= currentEnd &&
          isRecording &&
          _videoController.value.isPlaying) {
        _videoController.pause();
        await stopRecordingIfActive();
        setState(() {
          showNextPassButton =
              currentSectionIndex < widget.videoSections.length - 1;
          showCalculateScoreButton = false;
        });
      }

      // Stop playing and allow "Next Pass" or "Score" if not Pass 3
      if (currentSectionIndex != 2 &&
          pos >= currentEnd &&
          _videoController.value.isPlaying) {
        _videoController.pause();
        await stopRecordingIfActive();
        setState(() {
          showNextPassButton =
              currentSectionIndex < widget.videoSections.length - 1;
          showCalculateScoreButton = currentSectionIndex == 1;
        });
      }
    });
  }

  @override
  void dispose() {
    audioRecorder.dispose();
    _audioPlayer.dispose();
    _videoController.dispose();
    super.dispose();
  }

  Future<void> stopRecordingIfActive() async {
    if (isRecording) {
      await audioRecorder.stopRecording();
      recordedFilePath = audioRecorder.filePath;
      setState(() {
        isRecording = false;
        showPreview = true;
        showSaveButton = true;
      });
    }
  }

  void startPass() async {
    setState(() {
      showStartButton = false;
      isRecording = false;
      showNextPassButton = false;
      showCalculateScoreButton = false;
    });

    _videoController.seekTo(currentStart);
    _videoController.play();
  }

  void nextPass() {
    stopRecordingIfActive(); // Stop audio if needed
    if (currentSectionIndex < widget.videoSections.length - 1) {
      setState(() {
        currentSectionIndex++;
        showStartButton = true;
        isRecording = false;
        showNextPassButton = false;
        showCalculateScoreButton = false;
        showSaveButton = false;
        showPreview = false;
      });
    }
    _videoController.seekTo(currentStart);
  }

  void goToScorePage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => ScorePage(
              videoSections: widget.videoSections,
              sectionUserTimestamps: sectionUserTimestamps,
            ),
      ),
    );
  }

  void addTimestamp() {
    final position = _videoController.value.position;
    setState(() {
      sectionUserTimestamps.putIfAbsent(currentSectionIndex, () => []);
      sectionUserTimestamps[currentSectionIndex]!.add(position);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.videoTitle} - $currentLabel')),
      body: Column(
        children: [
          if (_videoController.value.isInitialized)
            AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: VideoPlayer(_videoController),
            )
          else
            CircularProgressIndicator(),

          if (showStartButton)
            ElevatedButton(
              onPressed: startPass,
              child: Text('Start $currentLabel'),
            ),

          if (isRecording) Column(children: [Text('Recording...')]),

          if (showNextPassButton)
            ElevatedButton(onPressed: nextPass, child: Text('Next Pass')),

          if (showCalculateScoreButton)
            ElevatedButton(
              onPressed: goToScorePage,
              child: Text('Calculate Score'),
            ),

          if (showSaveButton && recordedFilePath != null)
            ElevatedButton(
              onPressed: () async {
                final savedPath = await audioRecorder.saveToDownloads();
                if (savedPath != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Recording saved to Downloads'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  setState(() => showSaveButton = false);
                }
              },
              child: Text('Save Recording'),
            ),

          if (currentSectionIndex == 1 && _videoController.value.isPlaying)
            ElevatedButton(
              onPressed: addTimestamp,
              child: Text('Add Timestamp'),
            ),
        ],
      ),
    );
  }
}
