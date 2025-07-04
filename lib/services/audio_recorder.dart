import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AudioRecorderService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String? _filePath;

  Future<void> initRecorder() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
    final dir = await getTemporaryDirectory();
    _filePath = '${dir.path}/voice_record.aac';
  }

  Future<void> startRecording() async {
    await _recorder.startRecorder(toFile: _filePath);
  }

  Future<void> stopRecording() async {
    await _recorder.stopRecorder();
  }

  Future<void> dispose() async {
    await _recorder.closeRecorder();
  }

  Future<String?> saveToDownloads() async {
    if (_filePath == null) return null;

    final file = File(_filePath!);

    if (!await file.exists()) return null;

    final status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) return null;

    final downloadsDir = Directory('/storage/emulated/0/Download');
    if (!await downloadsDir.exists()) return null;

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newPath = '${downloadsDir.path}/recorded_$timestamp.aac';

    final newFile = await file.copy(newPath);
    return newFile.path;
  }

  String? get filePath => _filePath;
}
