import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  Uint8List? _imageFile;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Screen To Pdf"),
      ),
      body: Screenshot(
        controller: screenshotController,
        child: const Center(
          child: Text("Pdf Ekranı"),
        ),
      ),
    );
  }
}
