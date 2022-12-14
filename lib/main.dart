import 'package:flutter/material.dart';
import 'package:flutter_screen_to_pdf/pages/home_page.dart';
import 'package:flutter_screen_to_pdf/utils/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      scaffoldMessengerKey: Utils.messengerKey,
      home: HomePage(),
    );
  }
}
