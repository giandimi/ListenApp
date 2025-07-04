import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

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

  String? get filePath => _filePath;
}
