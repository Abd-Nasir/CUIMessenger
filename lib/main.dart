import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/home/homepage.dart';
import 'package:cui_messenger/login/view/select_user_screen.dart';
import 'package:cui_messenger/login/view/login_screen.dart';
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
      home: const SelectUserScreen(),
      // initialRoute: splashRoute,
      navigatorKey: RouteGenerator.navigatorKey,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
