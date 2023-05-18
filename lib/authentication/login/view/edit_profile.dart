// import 'dart:io';

// import 'package:cui_messenger/authentication/bloc/auth_bloc.dart';
// import 'package:cui_messenger/authentication/model/user_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:overlay_support/overlay_support.dart';

// import 'package:url_launcher/url_launcher.dart';

// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({Key? key}) : super(key: key);

//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   TextEditingController firstNameController = TextEditingController();
//   TextEditingController lastNameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController dateOfBirthController = TextEditingController();
//   TextEditingController addressController = TextEditingController();

//   XFile? pickedImage;
//   bool isCancelSubscription = true;
//   late UserModel user;

//   @override
//   void initState() {
//     user = BlocProvider.of<AuthBloc>(context).state.user!;
//     super.initState();
//     firstNameController.text = user.firstName;
//     lastNameController.text = user.lastName;
//     emailController.text = user.email;
//     phoneController.text = user.phoneNumber;
//     dateOfBirthController.text =
//         DateFormat.yMMMMd().format(DateTime.parse(user.dateOfBirth));
//     addressController.text = user.address;

//     print('hjfdgfdijijfgi   ${user.toJson()}');
//   }

//   @override
//   Widget build(BuildContext context) {
//     MediaQueryData mediaQuery = MediaQuery.of(context);
//     return Scaffold(
//       body: SafeArea(
//         bottom: false,
//         child: Padding(
//           padding:
//               EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.04),
//           child: Column(
//             children: [
//               SizedBox(height: mediaQuery.size.height * 0.03),
//               buildHeader(mediaQuery),
//               SizedBox(height: mediaQuery.size.height * 0.01),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: mediaQuery.size.width * 0.02),
//                     child: Column(
//                       children: [
//                         SizedBox(height: mediaQuery.size.height * 0.02),
//                         createContactPicture(mediaQuery, user.profilePicture),
//                         SizedBox(height: mediaQuery.size.height * 0.03),
//                         Container(
//                           decoration: CustomWidgets.textInputDecoration,
//                           padding: EdgeInsets.symmetric(
//                               horizontal: mediaQuery.size.width * 0.04,
//                               vertical: 4),
//                           child: TextFormField(
//                             controller: firstNameController,
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               hintText: AppLocalizations.of(context)
//                                   .translate('first_name'),
//                               hintStyle: const TextStyle(
//                                 color: Palette.hintGrey,
//                               ),
//                             ),
//                             keyboardType: TextInputType.text,
//                           ),
//                         ),
//                         SizedBox(height: mediaQuery.size.height * 0.03),
//                         Container(
//                           decoration: CustomWidgets.textInputDecoration,
//                           padding: EdgeInsets.symmetric(
//                               horizontal: mediaQuery.size.width * 0.04,
//                               vertical: 4),
//                           child: TextFormField(
//                             controller: lastNameController,
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               hintText: AppLocalizations.of(context)
//                                   .translate('last_name'),
//                               hintStyle: const TextStyle(
//                                 color: Palette.hintGrey,
//                               ),
//                             ),
//                             keyboardType: TextInputType.text,
//                           ),
//                         ),
//                         SizedBox(height: mediaQuery.size.height * 0.03),
//                         Container(
//                           decoration: CustomWidgets.textInputDecoration,
//                           padding: EdgeInsets.symmetric(
//                               horizontal: mediaQuery.size.width * 0.04,
//                               vertical: 4.0),
//                           child: TextFormField(
//                             controller: emailController,
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               hintText: AppLocalizations.of(context)
//                                   .translate('e_mail'),
//                               hintStyle: const TextStyle(
//                                 color: Palette.hintGrey,
//                               ),
//                             ),
//                             readOnly: true,
//                             onTap: () {
//                               showSimpleNotification(
//                                 Text(AppLocalizations.of(context)
//                                     .translate("sorry_mail_cannot_change")),
//                                 background: Palette.yellow.withOpacity(0.9),
//                                 duration: const Duration(seconds: 2),
//                               );
//                             },
//                           ),
//                         ),
//                         SizedBox(height: mediaQuery.size.height * 0.03),
//                         Container(
//                           decoration: CustomWidgets.textInputDecoration,
//                           padding: EdgeInsets.symmetric(
//                               horizontal: mediaQuery.size.width * 0.04,
//                               vertical: 4.0),
//                           child: TextFormField(
//                             controller: phoneController,
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               hintText: AppLocalizations.of(context)
//                                   .translate('phone_no'),
//                               hintStyle: const TextStyle(
//                                 color: Palette.hintGrey,
//                               ),
//                             ),
//                             keyboardType: TextInputType.phone,
//                           ),
//                         ),
//                         SizedBox(height: mediaQuery.size.height * 0.03),
//                         Container(
//                           decoration: CustomWidgets.textInputDecoration,
//                           padding: EdgeInsets.symmetric(
//                               horizontal: mediaQuery.size.width * 0.04,
//                               vertical: 4.0),
//                           child: TextFormField(
//                             controller: dateOfBirthController,
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               hintText: AppLocalizations.of(context)
//                                   .translate('date_of_birth'),
//                               hintStyle: const TextStyle(
//                                 color: Palette.hintGrey,
//                               ),
//                             ),
//                             readOnly: true,
//                             onTap: () {
//                               showSimpleNotification(
//                                 Text(AppLocalizations.instance
//                                     .tr("sorry_mail_cannot_change")),
//                                 background: Palette.yellow.withOpacity(0.9),
//                                 duration: const Duration(seconds: 2),
//                               );
//                             },
//                           ),
//                         ),
//                         SizedBox(height: mediaQuery.size.height * 0.03),
//                         Container(
//                           decoration: CustomWidgets.textInputDecoration,
//                           padding: EdgeInsets.symmetric(
//                               horizontal: mediaQuery.size.width * 0.04,
//                               vertical: 4.0),
//                           child: TextFormField(
//                             controller: addressController,
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               hintText: AppLocalizations.of(context)
//                                   .translate('address'),
//                               hintStyle: const TextStyle(
//                                 color: Palette.hintGrey,
//                               ),
//                             ),
//                             keyboardType: TextInputType.streetAddress,
//                           ),
//                         ),
//                         SizedBox(height: mediaQuery.size.height * 0.04),
//                         GestureDetector(
//                           onTap: () {
//                             showDialog(
//                               context: context,
//                               builder: (_) => AlertDialog(
//                                 backgroundColor: Palette.white,
//                                 contentPadding: EdgeInsets.symmetric(
//                                     horizontal: mediaQuery.size.width * 0.08,
//                                     vertical: mediaQuery.size.height * 0.02),
//                                 actionsAlignment: MainAxisAlignment.spaceEvenly,
//                                 title: Text(
//                                   "Are you sure you want to delete your account?",
//                                   textAlign: TextAlign.center,
//                                   style: const TextStyle(
//                                     color: Palette.textColor,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14.0,
//                                   ),
//                                 ),
//                                 content: Text(
//                                   "Once done this can't be reverted. Your contacts, messages, notificaions and devices will be removed from our system with immediate effect!",
//                                   textAlign: TextAlign.center,
//                                   style: const TextStyle(
//                                     color: Palette.textColor,
//                                     fontSize: 12.0,
//                                   ),
//                                 ),
//                                 actions: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       RouteGenerator.navigatorKey.currentState!
//                                           .pop('dialog');
//                                     },
//                                     child: Text(
//                                       AppLocalizations.of(context)
//                                           .translate('cancel'),
//                                       style: const TextStyle(
//                                           color: Palette.textColor,
//                                           fontSize: 12.0),
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       Navigator.of(context, rootNavigator: true)
//                                           .pop('dialog');
//                                       BlocProvider.of<AuthBloc>(context).add(
//                                         AuthDeleteAccountEvent(
//                                             email: BlocProvider.of<AuthBloc>(
//                                                     context)
//                                                 .state
//                                                 .user!
//                                                 .email),
//                                       );
//                                     },
//                                     child: Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           vertical: 6.0, horizontal: 16.0),
//                                       decoration: BoxDecoration(
//                                         color: Palette.red,
//                                         borderRadius:
//                                             BorderRadius.circular(8.0),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             offset: const Offset(0.0, 0.0),
//                                             blurRadius: 16.0,
//                                             color:
//                                                 Palette.red.withOpacity(0.25),
//                                           ),
//                                         ],
//                                       ),
//                                       child: Text(
//                                         "Delete",
//                                         style: const TextStyle(
//                                             color: Palette.white,
//                                             fontSize: 12.0),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                           child: Container(
//                             width: mediaQuery.size.width,
//                             padding: EdgeInsets.symmetric(
//                                 vertical: mediaQuery.size.height * 0.02,
//                                 horizontal: mediaQuery.size.width * 0.02),
//                             decoration: BoxDecoration(
//                               color: Palette.red,
//                               borderRadius: BorderRadius.circular(8.0),
//                               boxShadow: [
//                                 BoxShadow(
//                                   offset: const Offset(0.0, 2.0),
//                                   blurRadius: 16.0,
//                                   color: Palette.red.withOpacity(0.15),
//                                 )
//                               ],
//                             ),
//                             child: const Text(
//                               "Delete your account!",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Palette.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: mediaQuery.size.width * 0.04),
//                         isCancelSubscription == true
//                             ? InkWell(
//                                 onTap: () async {
//                                   // Api.instance
//                                   //     .getActiveSubscription(context,
//                                   //         customer:
//                                   //             user.stripeClientId.toString(),
//                                   //         status: 'active')
//                                   //     .then((value) {
//                                   //   if (value.isNotEmpty) {
//                                   //     print('sub id --> ${value.toString()}');
//                                   //     Api.instance.cancelSubscription(
//                                   //         email:
//                                   //             BlocProvider.of<AuthBloc>(context)
//                                   //                 .state
//                                   //                 .user!
//                                   //                 .email,
//                                   //         subscriptionId: value.toString());
//                                   //   }
//                                   // });
//                                   CustomerInfo info =
//                                       await Purchases.getCustomerInfo();
//                                   String? url =
//                                       "https://apps.apple.com/account/subscriptions";
//                                   if (url != null) {
//                                     if (!await launchUrl(Uri.parse(url))) {
//                                       print("Can not launch url!");
//                                     }
//                                   }
//                                 },
//                                 child: Container(
//                                   width: mediaQuery.size.width,
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: mediaQuery.size.height * 0.02,
//                                       horizontal: mediaQuery.size.width * 0.02),
//                                   decoration: BoxDecoration(
//                                     color: Palette.red,
//                                     borderRadius: BorderRadius.circular(8.0),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         offset: const Offset(0.0, 2.0),
//                                         blurRadius: 16.0,
//                                         color: Palette.red.withOpacity(0.15),
//                                       )
//                                     ],
//                                   ),
//                                   child: Text(
//                                     AppLocalizations.of(context)
//                                         .translate('cancel_subscription'),
//                                     textAlign: TextAlign.center,
//                                     style: const TextStyle(
//                                       color: Palette.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             : Container(),
//                         SizedBox(height: mediaQuery.size.height * 0.04),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget createContactPicture(
//       MediaQueryData mediaQuery, String profilePicture) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           width: mediaQuery.size.width * 0.4,
//           height: mediaQuery.size.width * 0.4,
//           decoration: BoxDecoration(
//             color: Palette.white,
//             borderRadius: BorderRadius.circular(200.0),
//             boxShadow: [
//               BoxShadow(
//                 color: Palette.frenchBlue.withOpacity(0.25),
//                 offset: const Offset(0.0, 2.0),
//                 blurRadius: 16.0,
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(200.0),
//             child: pickedImage != null
//                 ? Image.file(
//                     File(pickedImage!.path),
//                     fit: BoxFit.cover,
//                   )
//                 : Image.network(
//                     profilePicture,
//                     width: mediaQuery.size.width * 0.4,
//                     fit: BoxFit.cover,
//                   ),
//           ),
//         ),
//         Column(
//           children: [
//             GestureDetector(
//               onTap: () => showChoiceDialog(context),
//               child: Container(
//                 width: mediaQuery.size.width * 0.36,
//                 padding: EdgeInsets.symmetric(
//                     vertical: mediaQuery.size.height * 0.02,
//                     horizontal: mediaQuery.size.width * 0.02),
//                 decoration: BoxDecoration(
//                   color: Palette.white,
//                   borderRadius: BorderRadius.circular(8.0),
//                   boxShadow: [
//                     BoxShadow(
//                       offset: const Offset(0.0, 2.0),
//                       blurRadius: 16.0,
//                       color: Palette.frenchBlue.withOpacity(0.15),
//                     )
//                   ],
//                 ),
//                 child: Text(
//                   AppLocalizations.of(context).translate('upload_picture'),
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(color: Palette.frenchBlue),
//                 ),
//               ),
//             ),
//             SizedBox(height: mediaQuery.size.height * 0.02),
//             (pickedImage != null)
//                 ? GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         pickedImage = null;
//                       });
//                     },
//                     child: Container(
//                       width: mediaQuery.size.width * 0.36,
//                       padding: EdgeInsets.symmetric(
//                           vertical: mediaQuery.size.height * 0.02,
//                           horizontal: mediaQuery.size.width * 0.02),
//                       decoration: BoxDecoration(
//                         color: Palette.red,
//                         borderRadius: BorderRadius.circular(8.0),
//                         boxShadow: [
//                           BoxShadow(
//                             offset: const Offset(0.0, 2.0),
//                             blurRadius: 16.0,
//                             color: Palette.red.withOpacity(0.15),
//                           )
//                         ],
//                       ),
//                       child: Text(
//                         AppLocalizations.of(context)
//                             .translate('delete_picture'),
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(color: Palette.white),
//                       ),
//                     ),
//                   )
//                 : Container(),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget buildHeader(MediaQueryData mediaQuery) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         IconButton(
//           onPressed: () => showDialog(
//             context: context,
//             builder: (_) => AlertDialog(
//               backgroundColor: Palette.white,
//               contentPadding: EdgeInsets.symmetric(
//                   horizontal: mediaQuery.size.width * 0.08,
//                   vertical: mediaQuery.size.height * 0.02),
//               actionsAlignment: MainAxisAlignment.spaceEvenly,
//               title: Text(
//                 AppLocalizations.of(context).translate('discard_changes'),
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   color: Palette.textColor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14.0,
//                 ),
//               ),
//               content: Text(
//                 AppLocalizations.of(context)
//                     .translate('discard_changes_subtitle'),
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   color: Palette.textColor,
//                   fontSize: 12.0,
//                 ),
//               ),
//               actions: [
//                 GestureDetector(
//                   onTap: () {
//                     RouteGenerator.navigatorKey.currentState!.pop('dialog');
//                   },
//                   child: Text(
//                     AppLocalizations.of(context).translate('cancel'),
//                     style: const TextStyle(
//                         color: Palette.textColor, fontSize: 12.0),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.of(context, rootNavigator: true).pop('dialog');
//                     RouteGenerator.navigatorKey.currentState!.pop(context);
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 6.0, horizontal: 16.0),
//                     decoration: BoxDecoration(
//                       color: Palette.red,
//                       borderRadius: BorderRadius.circular(8.0),
//                       boxShadow: [
//                         BoxShadow(
//                           offset: const Offset(0.0, 0.0),
//                           blurRadius: 16.0,
//                           color: Palette.red.withOpacity(0.25),
//                         ),
//                       ],
//                     ),
//                     child: Text(
//                       AppLocalizations.of(context).translate('discard'),
//                       style:
//                           const TextStyle(color: Palette.white, fontSize: 12.0),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           icon: const Icon(Icons.close),
//           color: Palette.textColor,
//         ),
//         Text(
//           AppLocalizations.of(context).translate('account'),
//           style: const TextStyle(
//             color: Palette.textColor,
//             fontSize: 18.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             if (pickedImage != null) {
//               BlocProvider.of<AuthBloc>(context).add(
//                 AuthUpdateUserDataEvent(
//                     userid: BlocProvider.of<AuthBloc>(context).state.user!.uid,
//                     file: pickedImage,
//                     oldImageKey:
//                         BlocProvider.of<AuthBloc>(context).state.user!.imageKey,
//                     dataChanged: {
//                       "first-name": firstNameController.text,
//                       "last-name": lastNameController.text,
//                       "phone": phoneController.text,
//                       "address": addressController.text,
//                     }),
//               );
//             } else {
//               BlocProvider.of<AuthBloc>(context).add(
//                 AuthUpdateUserDataEvent(
//                     userid: BlocProvider.of<AuthBloc>(context).state.user!.uid,
//                     file: null,
//                     oldImageKey: null,
//                     dataChanged: {
//                       "first-name": firstNameController.text,
//                       "last-name": lastNameController.text,
//                       "phone": phoneController.text,
//                       "address": addressController.text,
//                     }),
//               );
//             }
//             RouteGenerator.navigatorKey.currentState!.pop(context);
//           },
//           child: Container(
//             decoration: CustomWidgets.buttonDecoration,
//             padding:
//                 const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
//             child: const Icon(
//               Icons.check,
//               color: Palette.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
