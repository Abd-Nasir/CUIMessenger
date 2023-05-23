import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_cache_manager_dio/flutter_cache_manager_dio.dart';
import 'package:folder_file_saver/folder_file_saver.dart';

// import 'package:cui_messenger/authentication/bloc/auth_bloc.dart';
// import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:cui_messenger/notification/bloc/notifications_bloc.dart';
import 'package:cui_messenger/notification/bloc/notifications_event.dart';
import 'package:cui_messenger/notification/bloc/notifications_state.dart';
// import 'package:flowder/flowder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
// import 'package:open_file/open_file.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String langCode = "en";
  BuildContext? myContext;
  bool isLoading = true;
  String? path;
  int selectedIndex = 0;
  // var dio = Dio();

  @override
  void initState() {
    // dio.interceptors.add(LogInterceptor(responseBody: false));
    // DioCacheManager.initialize(dio);
    Future.delayed(const Duration(seconds: 1)).then((_) {
      setState(() {
        isLoading = false;
      });
    });
    // initPlatformState();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Scaffold(
        body: SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Container(
            color: Palette.white,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildHeader(mediaQuery, context),
                const SizedBox(height: 15),
                selectedIndex == 0
                    ? notification(mediaQuery, context)
                    : noticeboard(mediaQuery, context),
              ],
            )),
      ),
    ));
  }

  Widget noticeboard(MediaQueryData mediaQuery, BuildContext context) {
    return Container(
      // height: mediaQuery.size.height * 0.75,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Palette.cuiPurple.withOpacity(0.35),
            spreadRadius: 2,
            blurRadius: 7)
      ], borderRadius: BorderRadius.circular(10), color: Palette.white),
      child: Container(
          margin: const EdgeInsets.all(7),
          width: double.infinity,
          // height: mediaQuery.size.height * 0.4,
          // padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/noticeboard.jpg"),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              const Text(
                "NOTICEBOARD",
                style: TextStyle(
                    color: Palette.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const Divider(
                color: Palette.white,
              ),
              Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.size.width * 0.03),
                  height: mediaQuery.size.height * 0.62,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: mediaQuery.size.height * 0.01,
                    ),
                    width: mediaQuery.size.width,
                    // height: mediaQuery.size.height * 0.82,
                    child: BlocBuilder<NotificationBloc, NotificationState>(
                        builder: (context, state) {
                      if (NotificationState is NotificationStateLoadSuccess) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Palette.yellow,
                          ),
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () async {
                          BlocProvider.of<NotificationBloc>(context)
                              .add(const InitializeNotificationEvent());
                        },
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Palette.yellow,
                                ),
                              )
                            : ListView.builder(
                                itemCount:
                                    state.notificationProvider.notices.length,
                                itemBuilder: ((context, index) {
                                  return Column(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.notificationProvider
                                            .notices[index].noticeTitle,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Palette.yellow,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        state.notificationProvider
                                            .notices[index].noticeText,
                                        style: const TextStyle(
                                            color: Palette.white),
                                      ),
                                      const SizedBox(height: 5),
                                      if (state.notificationProvider
                                              .notices[index].fileName !=
                                          "")
                                        GestureDetector(
                                          onTap: () async {
                                            print("ontap");
                                            File checkFile = File(
                                                "/storage/emulated/0/Documents/CUI Messenger /Documents/${state.notificationProvider.notices[index].fileName}");

                                            if (await checkFile.exists()) {
                                              print("exists");
                                              showSimpleNotification(
                                                const Text(
                                                  "document-already-saved",
                                                  style: TextStyle(
                                                    color: Palette.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                background: Palette.orange
                                                    .withOpacity(0.9),
                                                slideDismissDirection:
                                                    DismissDirection.startToEnd,
                                              );
                                            } else {
                                              var response = await Dio().get(
                                                  state.notificationProvider
                                                      .notices[index].fileUrl!,
                                                  options: Options(
                                                      responseType:
                                                          ResponseType.bytes));
                                              print("Response: $response");
                                              // final iosDirectory =
                                              //     await getApplicationSupportDirectory();
                                              final dir = Platform.isIOS
                                                  ? await getApplicationSupportDirectory()
                                                  : await getApplicationDocumentsDirectory();
                                              print(dir.path);
                                              File savedFile = await File(
                                                      "${dir.path}/${state.notificationProvider.notices[index].fileName}")
                                                  .writeAsBytes(response.data);

                                              if (Platform.isAndroid) {
                                                final result1 =
                                                    await FolderFileSaver
                                                        .saveFileIntoCustomDir(
                                                            dirNamed:
                                                                "/Documents",
                                                            filePath:
                                                                savedFile.path,
                                                            removeOriginFile:
                                                                true);
                                                print(result1);
                                                if (result1 != null) {
                                                  showSimpleNotification(
                                                    const Text(
                                                      "Document already saved in app directory!",
                                                      style: TextStyle(
                                                        color: Palette.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    background: Palette.green
                                                        .withOpacity(0.9),
                                                    slideDismissDirection:
                                                        DismissDirection
                                                            .startToEnd,
                                                  );
                                                }
                                              }
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.download_outlined,
                                                color: Palette.yellow,
                                                size: 18,
                                              ),
                                              Text(
                                                state.notificationProvider
                                                    .notices[index].fileName!,
                                                style: const TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Palette.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      const SizedBox(height: 20),
                                    ],
                                  );
                                }),
                              ),
                      );
                    }),
                  ))
            ],
          )),
    );
  }

  Widget notification(MediaQueryData mediaQuery, BuildContext context) {
    return Column(
      children: [
        const Text(
          "Notifications",
          style: TextStyle(
              fontSize: 30,
              color: Palette.cuiPurple,
              fontFamily: "assets/fonts/SulphurPoint-Regular.ttf"),
        ),
        Container(
          color: Palette.white,
          margin: EdgeInsets.only(
            top: mediaQuery.size.height * 0.01,
          ),
          width: mediaQuery.size.width,
          // height: mediaQuery.size.height * 0.82,
          child: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
            if (NotificationState is NotificationStateLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Palette.cuiPurple,
                ),
              );
            }
            return isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Palette.cuiPurple,
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                      left: mediaQuery.size.width * 0.06,
                      right: mediaQuery.size.width * 0.06,
                    ),
                    itemCount: state.notificationProvider.notifications.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(
                            top: mediaQuery.size.height * 0.02,
                            bottom: mediaQuery.size.height * 0.02),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Palette.white,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0.0, 2.0),
                              blurRadius: 16.0,
                              color: Palette.cuiPurple.withOpacity(0.15),
                            )
                          ],
                        ),
                        child: ListTile(
                          //Display the user image
                          tileColor: Palette.white,
                          minVerticalPadding: 12.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),

                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              state.notificationProvider.notifications[index]
                                  .title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Palette.cuiPurple,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          // Display the last message presented
                          subtitle: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: state.notificationProvider
                                      .notifications[index].message,
                                  style: const TextStyle(
                                    color: Palette.textColor,
                                    fontSize: 12.0,
                                  ),
                                ),
                                const TextSpan(text: "\n"),
                                if (state.notificationProvider
                                        .notifications[index].fileName !=
                                    "")
                                  const TextSpan(
                                      text: "Tap to save document",
                                      style: TextStyle(
                                          height: 1.5,
                                          color: Palette.cuiPurple,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500)),
                                const TextSpan(
                                  text: " - ",
                                  style: TextStyle(
                                    color: Palette.hintGrey,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            // var file = await DioCacheManager.instance
                            //     .getSingleFile(state.notificationProvider
                            //         .notifications[index].fileUrl!);
                            // // file = changeFileNameOnly(file,fileName)
                            // OpenFilex.open(file.path);
                            print("ontap");
                            File checkFile = File(
                                "/storage/emulated/0/Documents/CUI Messenger /Documents/${state.notificationProvider.notifications[index].fileName}");

                            if (await checkFile.exists()) {
                              print("exists");
                              showSimpleNotification(
                                const Text(
                                  "document-already-saved",
                                  style: TextStyle(
                                    color: Palette.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                background: Palette.orange.withOpacity(0.9),
                                slideDismissDirection:
                                    DismissDirection.startToEnd,
                              );
                            } else {
                              var response = await Dio().get(
                                  state.notificationProvider
                                      .notifications[index].fileUrl!,
                                  options: Options(
                                      responseType: ResponseType.bytes));
                              print("Response: $response");
                              // final iosDirectory =
                              //     await getApplicationSupportDirectory();
                              final dir = Platform.isIOS
                                  ? await getApplicationSupportDirectory()
                                  : await getApplicationDocumentsDirectory();
                              print(dir.path);
                              File savedFile = await File(
                                      "${dir.path}/${state.notificationProvider.notifications[index].fileName}")
                                  .writeAsBytes(response.data);

                              if (Platform.isAndroid) {
                                final result1 =
                                    await FolderFileSaver.saveFileIntoCustomDir(
                                        dirNamed: "/Documents",
                                        filePath: savedFile.path,
                                        removeOriginFile: true);
                                print(result1);
                                if (result1 != null) {
                                  showSimpleNotification(
                                    const Text(
                                      "Document already saved in app directory!",
                                      style: TextStyle(
                                        color: Palette.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    background: Palette.green.withOpacity(0.9),
                                    slideDismissDirection:
                                        DismissDirection.startToEnd,
                                  );
                                }
                                OpenFilex.open(savedFile.path);
                                // final open = OpenFile.open(savedFile.path);
                                // print(open.toString());
                              }
                            }
                          },
                        ),
                      );
                    },
                  );
          }),
        ),
      ],
    );
  }

  Widget buildHeader(MediaQueryData mediaQuery, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: mediaQuery.size.width * 0.04,
        right: mediaQuery.size.width * 0.04,
        top: mediaQuery.size.width * 0.04,
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                BlocProvider.of<NotificationBloc>(context)
                    .add(const InitializeNotificationEvent());
              },
              icon: const Icon(
                Icons.refresh,
                size: 20,
                color: Palette.cuiPurple,
              )),
          SizedBox(width: mediaQuery.size.width * 0.13),
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Palette.cuiPurple.withOpacity(0.1),
                  spreadRadius: 4,
                  blurRadius: 5,
                  offset: const Offset(2, 2))
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          selectedIndex == 0 ? Palette.cuiPurple : Colors.white,
                      // color: Palette.aeroBlue,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                      // border: Border.all(
                      //   color: Colors.grey,
                      //   width: 1.0,
                      // ),
                    ),
                    child: Text(
                      "Notifications",
                      style: TextStyle(
                        color: selectedIndex == 0
                            ? Palette.white
                            : Palette.cuiPurple,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                    decoration: BoxDecoration(
                      color: selectedIndex == 1
                          ? Colors.green.shade900
                          : Palette.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      border: Border.all(
                        color: selectedIndex == 1
                            ? Colors.green.shade900
                            : Palette.white,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      "Noticeboard",
                      style: TextStyle(
                        color: selectedIndex == 1
                            ? Colors.yellow.shade50
                            : Palette.cuiPurple,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
