import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> saveRecordingToDownloads(
  String recordedFilePath,
  BuildContext context,
) async {
  try {
    final file = File(recordedFilePath);

    if (!await file.exists()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Recording file not found')));
      return;
    }

    var status = await Permission.manageExternalStorage.status;
    if (status.isDenied) {
      var result = await Permission.manageExternalStorage.request();
      if (!result.isGranted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Storage permission denied')));
        return;
      }
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      return;
    }

    final downloadsDir = Directory('/storage/emulated/0/Download');
    if (!await downloadsDir.exists()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Downloads folder not found')));
      return;
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newPath = '${downloadsDir.path}/recorded_$timestamp.aac';
    await file.copy(newPath);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Recording saved to Downloads'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Failed to save recording')));
  }
}
