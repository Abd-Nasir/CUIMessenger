import 'dart:io';

import 'package:cui_messenger/app_retain.dart';
import 'package:cui_messenger/authentication/bloc/auth_bloc.dart';
import 'package:cui_messenger/authentication/bloc/auth_event.dart';
import 'package:cui_messenger/authentication/bloc/auth_provider.dart';
import 'package:cui_messenger/feed/bloc/post_bloc.dart';
import 'package:cui_messenger/feed/bloc/post_provider.dart';

import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/helpers/routes/routenames.dart';
import 'package:cui_messenger/notification/bloc/notifications_bloc.dart';
import 'package:cui_messenger/notification/bloc/notifications_event.dart';
import 'package:cui_messenger/notification/bloc/notifications_provider.dart';
import 'package:cui_messenger/settings/bloc/settings_bloc.dart';
import 'package:cui_messenger/settings/bloc/settings_event.dart';
import 'package:cui_messenger/settings/bloc/settings_provider.dart';

import 'package:cui_messenger/splash.dart';
import './settings/model/setting.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Directory appPath = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appPath.path);
  Hive.registerAdapter(SettingAdapter());
  // Hive
  //   ..init(appPath.path.toString())
  //   ..registerAdapter(SettingsAdapter());

  await Hive.openBox('settingsBox');
  late Setting setting;
  try {
    Box myBox = await Hive.openBox("settings");
    // writing data if the app is new and just created the db
    var settingMap = myBox.get('settings');
    if (settingMap == null) {
      myBox.put(
        'settings',
        Setting(
          chatNotifications: false,
          noticeNotification: false,
        ),
      );
      setting = Setting(
        chatNotifications: false,
        noticeNotification: false,
      );
    } else {
      setting = settingMap;
    }
  } catch (error) {
    debugPrint("Error occured in offline database:\n$error");
  }
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
//Foreground message handler
  final messageStreamController = BehaviorSubject<RemoteMessage>();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }

    messageStreamController.sink.add(message);
  });
//Background message handler for Android/iOS
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
  final NotificationProvider notificationProvider = NotificationProvider();
  final SettingsProvider settingsProvider = SettingsProvider();

  @override
  void initState() {
    settingsProvider.loadFromDB();
    super.initState();
  }

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
          BlocProvider<NotificationBloc>(
            lazy: true,
            create: (context) => NotificationBloc(notificationProvider)
              ..add(const InitializeNotificationEvent()),
          ),
          BlocProvider<SettingsBloc>(
            lazy: true,
            create: (context) => SettingsBloc(settingsProvider)
              ..add(const InitialSettingsEvent()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CUI Messenger',
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
