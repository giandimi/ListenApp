import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> exportScoreToDownloads(String fileName, String content) async {
  final status = await Permission.storage.request();
  if (!status.isGranted) {
    throw Exception('Storage permission not granted');
  }

  Directory? downloadsDir;
  if (Platform.isAndroid) {
    downloadsDir = Directory('/storage/emulated/0/Download');
  } else if (Platform.isIOS) {
    downloadsDir = await getApplicationDocumentsDirectory();
  }

  final file = File('${downloadsDir!.path}/$fileName');
  await file.writeAsString(content);
}
