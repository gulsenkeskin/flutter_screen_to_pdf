import 'package:flutter/material.dart';
import 'package:flutter_screen_to_pdf/functions/pdf_functions.dart';
import 'package:flutter_screen_to_pdf/pages/pdf_show.dart';
import 'package:screenshot/screenshot.dart';

class AppBarButton extends StatelessWidget {
  final ScreenshotController screenshotController;

  const AppBarButton({
    Key? key,
    required this.screenshotController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Wrap(
                children: [
                  ListTile(
                      onTap: () async {
                        //Navigator.of(context).pop();
                        final screenShot = await screenshotController.capture();
                        if (screenShot != null) {
                          await screenToPdf(screenShot)
                              .then((value) => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PdfShowScreen(
                                        fileNameWithoutExtension: "pdf-file",
                                        uint8List: value,
                                      ),
                                    ),
                                  ));
                        }
                      },
                      title: const Text("Pdf Görüntüle")),
                ],
              );
            });
      },
      icon: const Icon(
        Icons.more_vert,
      ),
    );
  }
}
