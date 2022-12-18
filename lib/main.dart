import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/authentication/login/view/select_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SelectUserScreen(),
        // initialRoute: splashRoute,
        navigatorKey: RouteGenerator.navigatorKey,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
