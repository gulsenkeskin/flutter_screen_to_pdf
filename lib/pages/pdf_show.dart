import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screen_to_pdf/functions/pdf_functions.dart';
import 'package:flutter_screen_to_pdf/utils/utils.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';

class PdfShowScreen extends StatefulWidget {
  const PdfShowScreen({
    Key? key,
    this.route,
    this.requestObj,
    this.fileNameWithoutExtension,
    this.uint8List,
  }) : super(key: key);
  final String? route;
  final dynamic requestObj;
  final String? fileNameWithoutExtension;
  final Uint8List? uint8List;

  @override
  _PdfShowScreenState createState() => _PdfShowScreenState();
}

class _PdfShowScreenState extends State<PdfShowScreen> {
  late Uint8List fileData; //pdf.save den gelen değer
  PdfControllerPinch? pdfController;
  Future<void>? _future;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  Future<void> fetchData() async {
    if (widget.uint8List != null) {
      fileData = widget.uint8List!;
      setPdfControllerData();
      return;
    }

    //api isteğiyle dönen pdf i gösterebilmek için
    // var res = await RestConnector(
    //   widget.route ?? "",
    //   jwtToken!,
    //   data: widget.requestObj,
    //   requestType: "POST",
    // ).getData();
    //
    // fileData = await base64Decode(res.data[0]["base64"]);
    // setPdfControllerData();
  }

  setPdfControllerData() {
    pdfController = PdfControllerPinch(
      document: PdfDocument.openData(fileData),
    );
  }

  @override
  void dispose() {
    pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pdf"),
          actions: [
            IconButton(
                onPressed: () async {
                  try {
                    //var file =
                    await savePdfFile(
                        fileData,  "${widget.fileNameWithoutExtension}.pdf");
                    //File(file).deleteSync();
                  } catch (e) {
                    Utils.showSnackBar(
                        e is String ? e : "$e Dosya indirilemiyor",
                        color: Colors.red);
                  }
                },
                icon: const Icon(Icons.download)),
            IconButton(
                onPressed: () async {
                  try {
                    var file = await writeFile(
                        fileData, "${widget.fileNameWithoutExtension}.pdf");
                    await Share.shareXFiles([XFile(file)]);
                    File(file).deleteSync();
                  } catch (e) {
                    Utils.showSnackBar(e is String ? e : "Dosya paylaşılamıyor",
                        color: Colors.amber);
                  }
                },
                icon: const Icon(Icons.share)),
          ],
        ),
        body: FutureBuilder(
          future: _future,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (pdfController != null) {
                return PdfViewPinch(controller: pdfController!);
              } else {
                return const Center(
                  child: Text(
                    "Pdf görüntülenemedi.",
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
