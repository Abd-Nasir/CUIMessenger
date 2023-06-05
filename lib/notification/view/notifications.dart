// import 'dart:io';
import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/helpers/routes/routenames.dart';
import 'package:cui_messenger/helpers/style/custom_widgets.dart';
import 'package:cui_messenger/notification/model/pdf_viewer_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:cui_messenger/notification/bloc/notifications_bloc.dart';
import 'package:cui_messenger/notification/bloc/notifications_event.dart';
import 'package:cui_messenger/notification/bloc/notifications_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:overlay_support/overlay_support.dart';

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

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1)).then((_) {
      setState(() {
        isLoading = false;
      });
    });
    // initPlatformState();

    super.initState();
  }

  void refresh() {
    setState(() {
      isLoading = true;
    });

    BlocProvider.of<NotificationBloc>(context)
        .add(const InitializeNotificationEvent());
    Future.delayed(const Duration(seconds: 1)).then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Scaffold(
        backgroundColor: Palette.white,
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
                                  final notice =
                                      state.notificationProvider.notices[index];
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
                                      if (notice.fileName != "")
                                        GestureDetector(
                                          onTap: () {
                                            if (notice.fileType == 'pdf') {
                                              RouteGenerator
                                                  .navigatorKey.currentState!
                                                  .pushNamed(
                                                pdfViewerRoute,
                                                arguments: PDFViewerPage(
                                                    fileName: notice.fileName!,
                                                    url: notice.fileUrl!),
                                              );
                                            } else if (notice.fileType ==
                                                    'png' ||
                                                notice.fileType == "jpg" ||
                                                notice.fileType == "jpeg") {
                                              previewImage(
                                                  context,
                                                  mediaQuery,
                                                  notice.fileUrl!,
                                                  notice.fileName!);
                                            } else {
                                              CustomWidgets.saveFile(
                                                  fileUrl: notice.fileUrl!,
                                                  fileName: notice.fileName!);
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
    return Container(
      height: mediaQuery.size.height * 0.73,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Notifications",
            style: TextStyle(
                fontSize: 30,
                color: Palette.cuiPurple,
                fontFamily: "assets/fonts/SulphurPoint-Regular.ttf"),
          ),
          Container(
            // color: Palette.white,
            // margin: EdgeInsets.only(
            //   top: mediaQuery.size.height * 0.01,
            // ),
            // width: mediaQuery.size.width,
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
                  : Expanded(
                      child: ListView.builder(
                        // shrinkWrap: true,
                        padding: EdgeInsets.only(
                          left: mediaQuery.size.width * 0.06,
                          right: mediaQuery.size.width * 0.06,
                        ),
                        itemCount:
                            state.notificationProvider.notifications.length,
                        itemBuilder: (context, index) {
                          final notification =
                              state.notificationProvider.notifications[index];
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
                                  notification.title,
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
                                      text: notification.message,
                                      style: const TextStyle(
                                        color: Palette.textColor,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    const TextSpan(text: "\n"),
                                    if (notification.fileName != "")
                                      TextSpan(
                                          text: notification.fileName,
                                          style: const TextStyle(
                                              height: 1.5,
                                              color: Palette.cuiPurple,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500)),
                                    if (notification.fileName != "")
                                      const TextSpan(text: "\n"),
                                    if (notification.fileName != "")
                                      TextSpan(
                                          text: notification.fileType != "docx"
                                              ? "Tap to open document"
                                              : "Tap to save document",
                                          style: const TextStyle(
                                              height: 1.5,
                                              color: Palette.cuiPurple,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                              onTap: () {
                                if (notification.fileName != "") {
                                  if (notification.fileType == 'pdf') {
                                    RouteGenerator.navigatorKey.currentState!
                                        .pushNamed(
                                      pdfViewerRoute,
                                      arguments: PDFViewerPage(
                                          fileName: notification.fileName!,
                                          url: notification.fileUrl!),
                                    );
                                  } else if (notification.fileType == 'png' ||
                                      notification.fileType == "jpg" ||
                                      notification.fileType == "jpeg") {
                                    previewImage(
                                        context,
                                        mediaQuery,
                                        notification.fileUrl!,
                                        notification.fileName!);
                                  } else {
                                    CustomWidgets.saveFile(
                                        fileUrl: notification.fileUrl!,
                                        fileName: notification.fileName!);
                                  }
                                }
                              },
                            ),
                          );
                        },
                      ),
                    );
            }),
          ),
        ],
      ),
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
                refresh();
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

  void previewImage(BuildContext context, MediaQueryData mediaQuery,
      String imageLink, String fileName) {
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(top: 30),
            // height: MediaQuery.of(context).size.height * 0.64,
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: CustomWidgets.textInputDecoration,
                  child: InteractiveViewer(
                    panEnabled: false, // Set it to false
                    boundaryMargin: const EdgeInsets.all(100),
                    minScale: 0.5,
                    maxScale: 2,

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        imageLink,
                        // height: 300,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25, left: 10),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Palette.privacyPolicy.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(400),
                  ),
                  child: GestureDetector(
                    child: Icon(
                      Icons.close_outlined,
                      color: Palette.white,
                      size: MediaQuery.of(context).size.width * 0.04,
                    ),
                    onTap: () {
                      RouteGenerator.navigatorKey.currentState!.pop(context);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: mediaQuery.size.height * 0.03,
                    right: mediaQuery.size.width * 0.03,
                    bottom: mediaQuery.size.height * 0.03,
                  ),
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    backgroundColor: Palette.cuiPurple,
                    onPressed: () async {
                      var response = await Dio().get(imageLink,
                          options: Options(responseType: ResponseType.bytes));
                      final result = await ImageGallerySaver.saveImage(
                          Uint8List.fromList(response.data),
                          quality: 80,
                          name: "${fileName}_${DateTime.now().toString()}");
                      // debugPrint(result);
                      if (result['isSuccess'] != null) {
                        if (result['isSuccess']) {
                          showSimpleNotification(
                            const Text(
                              "Image saved to gallery",
                              style: TextStyle(
                                color: Palette.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            background: Palette.green.withOpacity(0.9),
                            slideDismissDirection: DismissDirection.startToEnd,
                          );
                        }
                      }
                      if (mounted) {
                        RouteGenerator.navigatorKey.currentState!.pop(context);
                      }
                    },
                    child: const Icon(Icons.download_outlined),
                  ),
                )
              ],
            ),
          );
        });
  }
}
