import 'package:cui_messenger/authentication/bloc/auth_bloc.dart';
import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:cui_messenger/notification/bloc/notifications_bloc.dart';
import 'package:cui_messenger/notification/bloc/notifications_event.dart';
import 'package:cui_messenger/notification/bloc/notifications_provider.dart';
import 'package:cui_messenger/notification/bloc/notifications_state.dart';
import 'package:cui_messenger/notification/model/myNotification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1)).then((_) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  // String parseMessage(String message) {
  //   String toReturn = "";
  //   String temp = message.substring(0,
  //       message.contains("\nPin") ? message.indexOf("\nPin") : message.length);

  //   List<String> tempList = temp.split(":");

  //   if (tempList.first == "Help Needed!\nCurrent Address" ||
  //       tempList.first == "¡Ayuda!\nUbicación actual") {
  //     toReturn =
  //         "${AppLocalizations.instance.tr("help_needed_current_address")}:${tempList.last}";
  //   }

  //   if (temp.contains("left Safety Zone")) {
  //     temp = temp.replaceAll(
  //         "left Safety Zone", AppLocalizations.instance.tr('left-safety-zone'));
  //   }

  //   if (toReturn.isEmpty) {
  //     toReturn = temp;
  //   }

  // print("Message Otiginal: $temp");
  // print("Message Return: $toReturn");
  // print("Message: $temp");

  //   return toReturn;
  // }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Scaffold(
      // backgroundColor:
      // BlocProvider.of<SettingsBloc>(context).state.provider.isDarkMode!
      //     ? Palette.black
      //     : Palette.white,
      body: SafeArea(
        bottom: false,
        child: Container(
          color: Palette.white,
          child: Column(children: [
            Container(
              padding: EdgeInsets.only(
                left: mediaQuery.size.width * 0.04,
                right: mediaQuery.size.width * 0.04,
                top: mediaQuery.size.width * 0.04,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        BlocProvider.of<NotificationBloc>(context)
                            .add(InitializeNotificationEvent());
                      },
                      icon: const Icon(
                        Icons.refresh,
                        size: 20,
                        color: Palette.cuiBlue,
                      )),
                  // Text(
                  //   AppLocalizations.of(context).translate('notifications'),
                  //   style: const TextStyle(
                  //     fontSize: 24.0,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
            ),
            const Text(
              "Notifications",
              style: TextStyle(
                  fontSize: 30,
                  color: Palette.cuiBlue,
                  fontFamily: "assets/fonts/SulphurPoint-Regular.ttf"),
            ),
            Expanded(
              child: Container(
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
                          child: CircularProgressIndicator(),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            BlocProvider.of<NotificationBloc>(context)
                                .add(const LoadUserEmeMessageEvent());
                          },
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(
                              left: mediaQuery.size.width * 0.06,
                              right: mediaQuery.size.width * 0.06,
                            ),
                            itemCount:
                                state.notificationProvider.notifications.length,
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
                                        color: Palette.black.withOpacity(0.10),
                                        offset: const Offset(0.0, 0.0),
                                        blurRadius: 4.0,
                                      ),
                                    ]),
                                child: ListTile(
                                  //Display the user image
                                  tileColor: Palette.white,
                                  minVerticalPadding: 12.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),

                                  // leading: Container(
                                  //   decoration: BoxDecoration(
                                  //     color: Palette.white,
                                  //     borderRadius:
                                  //         BorderRadius.circular(500),
                                  //   ),
                                  //   width: mediaQuery.size.width * 0.14,
                                  //   height: mediaQuery.size.width * 0.14,
                                  //   child: ClipRRect(
                                  //     borderRadius:
                                  //         BorderRadius.circular(500),
                                  //     child: CachedNetworkImage(
                                  //       imageUrl: "",
                                  //       // imageUrl: state.notificationProvider.notifications[index].,
                                  //       fit: BoxFit.cover,
                                  //       progressIndicatorBuilder: (context,
                                  //               url, downloadProgress) =>
                                  //           Center(
                                  //               child:
                                  //                   CircularProgressIndicator(
                                  //                       value:
                                  //                           downloadProgress
                                  //                               .progress)),
                                  //       errorWidget:
                                  //           (context, url, error) =>
                                  //               const Icon(
                                  //         Icons.error,
                                  //         color: Palette.darkBlue,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      state.notificationProvider
                                          .notifications[index].title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Palette.cuiBlue,
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
                                        const TextSpan(
                                            text: "Tap to open document",
                                            style: TextStyle(
                                                height: 1.5,
                                                color: Palette.cuiBlue,
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
                                    // if (!await launchUrl(
                                    //     Uri.parse(mapLink.trim()))) {
                                    //   showSimpleNotification(
                                    //     slideDismissDirection:
                                    //         DismissDirection
                                    //             .horizontal,
                                    //     Text(
                                    //       AppLocalizations.of(context)
                                    //           .translate(
                                    //               'cant_open_location'),
                                    //       style: const TextStyle(
                                    //           color: Palette.white),
                                    //     ),
                                    //     background: Palette.orange
                                    //         .withOpacity(0.9),
                                    //     duration: const Duration(
                                    //         seconds: 3),
                                    //   );
                                    // }
                                  },
                                ),
                              );
                            },
                          ),
                        );
                }),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
