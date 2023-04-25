import 'package:cui_messenger/app_retain.dart';
import 'package:cui_messenger/authentication/bloc/auth_bloc.dart';
import 'package:cui_messenger/authentication/bloc/auth_event.dart';
import 'package:cui_messenger/authentication/bloc/auth_provider.dart';
import 'package:cui_messenger/feed/bloc/post_bloc.dart';
import 'package:cui_messenger/feed/bloc/post_provider.dart';

import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/helpers/routes/routenames.dart';
import 'package:cui_messenger/splash.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthProvider authProvider = AuthProvider();
  final PostProvider postProvider = PostProvider();
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            lazy: false,
            create: (context) => AuthBloc(authProvider)
              ..add(
                const AuthEventInitialize(),
              ),
          ),
          BlocProvider<PostBloc>(
            lazy: true,
            create: (context) => PostBloc(
              postProvider..loadData(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home:
              // VerifyMail(),
              const AppRetainWidget(child: SplashPage()),
          // const SelectUserScreen(),
          initialRoute: splashRoute,
          navigatorKey: RouteGenerator.navigatorKey,
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
  }
}
