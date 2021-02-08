import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hisobot_dtm/pages/firstpage/firtspage1.dart';
import 'package:hisobot_dtm/pages/firstpage/smena.dart';
import 'package:hisobot_dtm/pages/login/login.dart';
import 'package:hisobot_dtm/pages/second/secondpage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  await Hive.initFlutter();
  await Hive.openBox("online");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LoginPage(),
      home: LoginPage(),
      routes: {
        LoginPage.id: (context) => LoginPage(),
        SmenaTanlash.id: (context) => SmenaTanlash(),
        FirstPage.id: (context) => FirstPage(),
        SecondPage.id: (context) => SecondPage(),

      },
    );
  }
}
