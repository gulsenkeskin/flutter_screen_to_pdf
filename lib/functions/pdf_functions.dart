// Dart imports:
import 'dart:io';
import 'dart:typed_data';

// Package imports:
import 'package:flutter_screen_to_pdf/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart ' as pw;
import 'package:pdf/pdf.dart';

Future<String> writeFile(Uint8List data, String name) async {
  String path = (await getTemporaryDirectory()).path;
  File pdfFile = await File('$path/$name').create();

  pdfFile.writeAsBytesSync(data);
  return pdfFile.path;
}

savePdfFile(Uint8List data, String name) async {
  String? path;
  if (Platform.isIOS) {
    path = (await getApplicationDocumentsDirectory()).path;
  } else if (Platform.isAndroid) {
    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.storage.request();
    }
    if (status.isGranted) {
      path = Directory('/storage/emulated/0/Download').path;
    }
  }
  File pdfFile = await File('$path/$name').create();
  pdfFile.writeAsBytesSync(data);

  Utils.showSnackBar("Dosya indirme işlemi başarılı");
}

Future screenToPdf(Uint8List screenShot) async {
  pw.Document pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Expanded(
          child: pw.Image(pw.MemoryImage(screenShot), fit: pw.BoxFit.contain),
        );
      },
    ),
  );
  return await pdf.save();
}
