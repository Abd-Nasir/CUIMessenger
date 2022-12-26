import 'package:cui_messenger/app_retain.dart';
import 'package:cui_messenger/authentication/bloc/auth_bloc.dart';
import 'package:cui_messenger/authentication/bloc/auth_event.dart';
import 'package:cui_messenger/authentication/bloc/auth_provider.dart';
import 'package:cui_messenger/authentication/login/view/login_screen.dart';
import 'package:cui_messenger/authentication/verification/user_verification.dart';
import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/authentication/login/view/select_user_screen.dart';
import 'package:cui_messenger/helpers/routes/routenames.dart';
import 'package:cui_messenger/home/homepage.dart';
import 'package:cui_messenger/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final AuthProvider provider = AuthProvider();
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            lazy: false,
            create: (context) => AuthBloc(provider)
              ..add(
                const AuthEventInitialize(),
              ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const AppRetainWidget(child: SplashPage()),
          // const SelectUserScreen(),
          initialRoute: splashRoute,
          navigatorKey: RouteGenerator.navigatorKey,
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
  }
}
