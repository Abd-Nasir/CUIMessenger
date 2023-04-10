import 'package:cui_messenger/authentication/bloc/auth_bloc.dart';
import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:cui_messenger/notification/bloc/notifications_bloc.dart';
import 'package:cui_messenger/notification/bloc/notifications_event.dart';
import 'package:cui_messenger/notification/bloc/notifications_state.dart';
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
  final GlobalKey _notificationKey = GlobalKey();
  final GlobalKey _askingKey = GlobalKey();

  @override
  void initState() {
    // context.read<NotificationBloc>().add(LoadUserNotificationsEvent(
    //     email: BlocProvider.of<AuthBloc>(context).state.user!.email));
    // langCode = context.read<LanguageBloc>().state.locale.languageCode;
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
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: mediaQuery.size.width * 0.04,
                  right: mediaQuery.size.width * 0.04,
                  top: mediaQuery.size.width * 0.04,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => RouteGenerator.navigatorKey.currentState!
                          .pop(context),
                      child: const Icon(Icons.arrow_back,
                          size: 20, color: Palette.cuiBlue),
                    ),
                    IconButton(
                        onPressed: () {},
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
              Text(
                "Notificaions",
                style: const TextStyle(
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
                      if (state is NotificationStateLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return state.notificationProvider.notifications.isEmpty
                            ? Center(
                                child: GestureDetector(
                                    onTap: () {
                                      // context.read<NotificationBloc>().add(
                                      //     LoadUserNotificationsEvent(
                                      //         email:
                                      //             BlocProvider.of<AuthBloc>(
                                      //                     context)
                                      //                 .state
                                      //                 .user!
                                      //                 .email));
                                    },
                                    child: Text("Notifications not found")),
                              )
                            : RefreshIndicator(
                                onRefresh: () async {
                                  context.read<NotificationBloc>().add(
                                      LoadUserNotificationsEvent(
                                          email:
                                              BlocProvider.of<AuthBloc>(context)
                                                  .state
                                                  .user!
                                                  .email));
                                },
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(
                                    left: mediaQuery.size.width * 0.06,
                                    right: mediaQuery.size.width * 0.06,
                                  ),
                                  itemCount: state.notificationProvider
                                      .notifications.length,
                                  itemBuilder: (context, index) {
                                    String s = state.notificationProvider
                                        .notifications[index].message;

                                    String mapLink = s.substring(
                                        s.indexOf(":") + 1, s.length);

                                    mapLink = mapLink.substring(
                                        mapLink.indexOf(":") + 1,
                                        mapLink.length);
                                    mapLink = mapLink.substring(
                                        mapLink.indexOf(":") + 1,
                                        mapLink.length);
                                    return Container(
                                      margin: EdgeInsets.only(
                                          top: mediaQuery.size.height * 0.02,
                                          bottom:
                                              mediaQuery.size.height * 0.02),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          color: Palette.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Palette.black
                                                  .withOpacity(0.10),
                                              offset: const Offset(0.0, 0.0),
                                              blurRadius: 4.0,
                                            ),
                                          ]),
                                      child: ListTile(
                                        //Display the user image
                                        tileColor: Palette.white,
                                        minVerticalPadding: 12.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
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
                                        title: Text(
                                          state.notificationProvider
                                              .notifications[index].fullName,
                                          style: const TextStyle(
                                              color: Palette.cuiBlue,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        // Display the last message presented
                                        subtitle: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "",
                                                // parseMessage(state
                                                //     .notificationProvider
                                                //     .notifications[index]
                                                //     .message),
                                                // state.notificationProvider
                                                //     .notifications[index].message
                                                //     .substring(
                                                //         0,
                                                //         state
                                                //                 .notificationProvider
                                                //                 .notifications[
                                                //                     index]
                                                //                 .message
                                                //                 .contains("\nPin")
                                                //             ? state
                                                //                 .notificationProvider
                                                //                 .notifications[
                                                //                     index]
                                                //                 .message
                                                //                 .indexOf("\nPin")
                                                //             : state
                                                //                 .notificationProvider
                                                //                 .notifications[
                                                //                     index]
                                                //                 .message
                                                //                 .length),
                                                style: const TextStyle(
                                                  color: Palette.textColor,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                              const TextSpan(text: "\n"),
                                              TextSpan(
                                                  text: "Tap to open location",
                                                  style: const TextStyle(
                                                      height: 1.5,
                                                      color: Palette.cuiBlue,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              TextSpan(
                                                text: "",
                                                // '${DateFormat("EEEE").format(state.notificationProvider.notifications[index].createdAt.toLocal())} ${DateFormat("h:mm a").format(state.notificationProvider.notifications[index].createdAt.toLocal())}',
                                                style: const TextStyle(
                                                  color: Palette.hintGrey,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: " - ",
                                                style: TextStyle(
                                                  color: Palette.hintGrey,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "",
                                                // DateFormat.yMMMMd()
                                                //     .format(state
                                                //         .notificationProvider
                                                //         .notifications[index]
                                                //         .createdAt
                                                //         .toLocal())
                                                //     .toString(),
                                                style: const TextStyle(
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
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
