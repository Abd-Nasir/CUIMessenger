import 'package:cui_messenger/home/homepage.dart';
import 'package:cui_messenger/login/view/home_screen1.dart';
import 'package:cui_messenger/login/view/login_screen2.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
