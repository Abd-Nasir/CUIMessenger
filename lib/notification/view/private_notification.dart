// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// import '../../helpers/style/colors.dart';

// class PrivateNotifications extends StatefulWidget {
//   const PrivateNotifications({super.key});

//   @override
//   State<PrivateNotifications> createState() => _PrivateNotificationsState();
// }

// class _PrivateNotificationsState extends State<PrivateNotifications> {
//   @override
//   Widget build(BuildContext context) {
//     MediaQueryData mediaQuery= MediaQuery
//     return Container(
//           color: Palette.white,
//           child: Column(children: [
//             Container(
//               padding: EdgeInsets.only(
//                 left: mediaQuery.size.width * 0.04,
//                 right: mediaQuery.size.width * 0.04,
//                 top: mediaQuery.size.width * 0.04,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                       onPressed: () {
//                         BlocProvider.of<NotificationBloc>(context)
//                             .add(const InitializeNotificationEvent());
//                       },
//                       icon: const Icon(
//                         Icons.refresh,
//                         size: 20,
//                         color: Palette.cuiPurple,
//                       )),
//                   // Text(
//                   //   AppLocalizations.of(context).translate('notifications'),
//                   //   style: const TextStyle(
//                   //     fontSize: 24.0,
//                   //     fontWeight: FontWeight.bold,
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//             const Text(
//               "Notifications",
//               style: TextStyle(
//                   fontSize: 30,
//                   color: Palette.cuiPurple,
//                   fontFamily: "assets/fonts/SulphurPoint-Regular.ttf"),
//             ),
//             Expanded(
//               child: Container(
//                 margin: EdgeInsets.only(
//                   top: mediaQuery.size.height * 0.01,
//                 ),
//                 width: mediaQuery.size.width,
//                 // height: mediaQuery.size.height * 0.82,
//                 child: BlocBuilder<NotificationBloc, NotificationState>(
//                     builder: (context, state) {
//                   if (NotificationState is NotificationStateLoading) {
//                     return const Center(
//                       child: CircularProgressIndicator(
//                         color: Palette.cuiPurple,
//                       ),
//                     );
//                   }
//                   return isLoading
//                       ? const Center(
//                           child: CircularProgressIndicator(),
//                         )
//                       : RefreshIndicator(
//                           onRefresh: () async {
//                             //   BlocProvider.of<NotificationBloc>(context)
//                             //       .add(const LoadUserEmeMessageEvent());
//                           },
//                           child: ListView.builder(
//                             shrinkWrap: true,
//                             padding: EdgeInsets.only(
//                               left: mediaQuery.size.width * 0.06,
//                               right: mediaQuery.size.width * 0.06,
//                             ),
//                             itemCount:
//                                 state.notificationProvider.notifications.length,
//                             itemBuilder: (context, index) {
//                               return Container(
//                                 margin: EdgeInsets.only(
//                                     top: mediaQuery.size.height * 0.02,
//                                     bottom: mediaQuery.size.height * 0.02),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(12.0),
//                                   color: Palette.white,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       offset: const Offset(0.0, 2.0),
//                                       blurRadius: 16.0,
//                                       color:
//                                           Palette.cuiPurple.withOpacity(0.15),
//                                     )
//                                   ],
//                                 ),
//                                 child: ListTile(
//                                   //Display the user image
//                                   tileColor: Palette.white,
//                                   minVerticalPadding: 12.0,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12.0),
//                                   ),

//                                   title: Padding(
//                                     padding: const EdgeInsets.only(bottom: 5.0),
//                                     child: Text(
//                                       state.notificationProvider
//                                           .notifications[index].title,
//                                       textAlign: TextAlign.center,
//                                       style: const TextStyle(
//                                           color: Palette.cuiPurple,
//                                           fontSize: 14.0,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                   // Display the last message presented
//                                   subtitle: RichText(
//                                     textAlign: TextAlign.center,
//                                     text: TextSpan(
//                                       children: [
//                                         TextSpan(
//                                           text: state.notificationProvider
//                                               .notifications[index].message,
//                                           style: const TextStyle(
//                                             color: Palette.textColor,
//                                             fontSize: 12.0,
//                                           ),
//                                         ),
//                                         const TextSpan(text: "\n"),
//                                         if (state
//                                                 .notificationProvider
//                                                 .notifications[index]
//                                                 .fileName ==
//                                             "")
//                                           const TextSpan(
//                                               text: "Tap to open document",
//                                               style: TextStyle(
//                                                   height: 1.5,
//                                                   color: Palette.cuiPurple,
//                                                   fontSize: 13,
//                                                   fontWeight: FontWeight.w500)),
//                                         const TextSpan(
//                                           text: " - ",
//                                           style: TextStyle(
//                                             color: Palette.hintGrey,
//                                             fontSize: 12.0,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   onTap: () async {
//                                     print("ontap");
//                                     File checkFile = File(
//                                         "/storage/emulated/0/Documents/CUI Messenger /Documents/${state.notificationProvider.notifications[index].fileName}");

//                                     if (await checkFile.exists()) {
//                                       print("exists");
//                                       showSimpleNotification(
//                                         const Text(
//                                           "document-already-saved",
//                                           style: TextStyle(
//                                             color: Palette.white,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         background:
//                                             Palette.orange.withOpacity(0.9),
//                                         slideDismissDirection:
//                                             DismissDirection.startToEnd,
//                                       );
//                                     } else {
//                                       var response = await Dio().get(
//                                           state.notificationProvider
//                                               .notifications[index].fileUrl!,
//                                           options: Options(
//                                               responseType:
//                                                   ResponseType.bytes));
//                                       print("Response: $response");
//                                       // final iosDirectory =
//                                       //     await getApplicationSupportDirectory();
//                                       final dir = Platform.isIOS
//                                           ? await getApplicationSupportDirectory()
//                                           : await getApplicationDocumentsDirectory();
//                                       print(dir.path);
//                                       File savedFile = await File(
//                                               "${dir.path}/${state.notificationProvider.notifications[index].fileName}")
//                                           .writeAsBytes(response.data);

//                                       if (Platform.isAndroid) {
//                                         final result1 = await FolderFileSaver
//                                             .saveFileIntoCustomDir(
//                                                 dirNamed: "/Documents",
//                                                 filePath: savedFile.path,
//                                                 removeOriginFile: true);
//                                         print(result1);
//                                         if (result1 != null) {
//                                           showSimpleNotification(
//                                             const Text(
//                                               "Document already saved in app directory!",
//                                               style: TextStyle(
//                                                 color: Palette.white,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             background:
//                                                 Palette.green.withOpacity(0.9),
//                                             slideDismissDirection:
//                                                 DismissDirection.startToEnd,
//                                           );
//                                         }
//                                       }
//                                     }
//                                   },
//                                 ),
//                               );
//                             },
//                           ),
//                         );
//                 }),
//               ),
//             ),
//           ]),
//         ),
//       );
//   }
// }