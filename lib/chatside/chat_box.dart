// import 'dart:async';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cui_messenger/chat/model/chat.dart';
// import 'package:cui_messenger/helpers/routes/routegenerator.dart';
// import 'package:cui_messenger/helpers/style/colors.dart';
// import 'package:cui_messenger/helpers/style/custom_widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// // // import 'package:safepall/helpers/routes/routegenerator.dart';
// // import 'package:safepall/helpers/style/colors.dart';
// // import 'package:safepall/helpers/style/custom_widgets.dart';
// // import 'package:safepall/screens/authentication/bloc/auth_bloc.dart';
// // import 'package:safepall/screens/authentication/model/user.dart' as my_user;
// import 'dart:io' as io;
// // import 'package:file_picker/file_picker.dart';
// // import 'package:safepall/screens/chat/model/chat.dart';
// // import 'package:safepall/screens/chat/model/chat_list.dart';

// class ChatBox extends StatefulWidget {
//   const ChatBox({
//     super.key,
//   });

//   @override
//   State<ChatBox> createState() => _ChatBoxState();
// }

// class _ChatBoxState extends State<ChatBox> {
//   String _enteredMessage = "";
//   final TextEditingController _messageController = TextEditingController();

//   late io.File messageImage;
//   // FilePickerResult? result;
//   String? fileName;
//   // PlatformFile? pickedFile;
//   io.File? fileToDisplay;
//   bool isLoading = false;
//   String fullName = '';
//   var _scrollController = ScrollController();

//   // Socket declaration
//   // late sc_io.Socket socket;

//   final newMessageFormKey = GlobalKey<FormState>();
//   final List messages = [
//     "Hi I'm abdullah",
//     "I'm Usama",
//     "Hey Leon",
//   ];
//   final List imageUrl = [];

//   // void pickFile(BuildContext context, MediaQueryData mediaQueryData) async {
//   //   try {
//   //     setState(() {
//   //       isLoading = true;
//   //     });
//   //     result = await FilePicker.platform.pickFiles(
//   //       type: FileType.any,
//   //       // allowedExtensions: ["jpg", "pdf", "png", "doc"],
//   //       allowMultiple: false,
//   //     );
//   //     print("Result: $result");
//   //     if (result != null) {
//   //       // fileName = result!.files.first.name;
//   //       pickedFile = result!.files.first;
//   //       print("Picked File has$pickedFile");
//   //       fileToDisplay = io.File(pickedFile!.path.toString());
//   //       print("File to display has:$fileToDisplay");
//   //       setState(() {
//   //         messageImage = fileToDisplay as io.File;
//   //       });

//   //       imageBottomSheet(context, mediaQueryData, messageImage);
//   //     }
//   //     print("This is picked file ${pickedFile!.name}");
//   //   } catch (e) {
//   //     print(e);
//   //   }
//   // }

//   Future pickImage(ImageSource source, MediaQueryData mediaQueryData) async {
//     try {
//       final image = await ImagePicker().pickImage(source: source);
//       if (image != null) {
//         final imageTemporary = io.File(image.path);
//         setState(() => messageImage = imageTemporary);

//         imageBottomSheet(context, mediaQueryData, messageImage);
//       } else {
//         return;
//       }
//     } on PlatformException catch (e) {
//       print('Failed to pick image: $e');
//     }
//   }

//   // Send Message to other user:
//   void sendMessage() {
//     scrollToBottom();
//     print("Message send!");
//   }

//   void scrollToBottom() {
//     print("MEthod running");
//     final bottomOffset = _scrollController.position.maxScrollExtent;
//     _scrollController.animateTo(
//       bottomOffset,
//       duration: const Duration(milliseconds: 100),
//       curve: Curves.easeOut,
//     );
//   }

//   late Timer timer;

//   @override
//   void initState() {
//     // TODO: implement initState

//     // _scrollController.addListener(() {
//     //   scrollToBottom();
//     // });
//     _scrollController = ScrollController();
//     Future.delayed(const Duration(seconds: 0), () {
//       // <-- Delay here
//       scrollToBottom();
//     });
//     // timer = Timer.periodic(const Duration(seconds: 0), (Timer t) {
//     //   scrollToBottom();
//     // });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     MediaQueryData mediaQuery = MediaQuery.of(context);
//     return Scaffold(
//       backgroundColor: Palette.aliceBlue,
//       appBar: AppBar(
//         toolbarHeight: mediaQuery.size.height * 0.08,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         flexibleSpace: Center(
//           child: SafeArea(
//             child: Container(
//               padding: EdgeInsets.only(right: mediaQuery.size.width * 0.08),
//               child: Row(
//                 children: <Widget>[
//                   IconButton(
//                     onPressed: () {
//                       RouteGenerator.navigatorKey.currentState!.pop();
//                     },
//                     icon: const Icon(
//                       Icons.arrow_back,
//                       color: Palette.black,
//                     ),
//                   ),
//                   SizedBox(
//                     width: mediaQuery.size.width * 0.01,
//                   ),
//                   Container(
//                     height: 45,
//                     width: 45,
//                     decoration: const BoxDecoration(shape: BoxShape.circle),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(50),
//                       child: CachedNetworkImage(
//                         imageUrl: "",
//                         fit: BoxFit.cover,
//                         progressIndicatorBuilder:
//                             (context, url, downloadProgress) => Center(
//                                 child: CircularProgressIndicator(
//                                     value: downloadProgress.progress)),
//                         errorWidget: (context, url, error) =>
//                             const Icon(Icons.error),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: mediaQuery.size.width * 0.03),
//                   Expanded(
//                     child: Text(
//                       fullName,
//                       style: TextStyle(
//                           fontSize: mediaQuery.size.height * 0.023,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                   Icon(
//                     Icons.info_outline,
//                     color: Palette.frenchBlue,
//                     size: mediaQuery.size.height * 0.04,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               // Expanded(
//               //   child: ListView.builder(
//               //     controller: _scrollController,
//               //     reverse: false,
//               //     itemCount: 5,
//               //     itemBuilder: (ctx, index) => chatBubble(
//               //       mediaQuery: mediaQuery,
//               //       // userName: "Abdullah Nasir",
//               //       message: chat.messages[index],
//               //       // imageUrl: imageUrl.length != 0 ? imageUrl[index] : null,
//               //       isMe: chat.messages[index].sender.uid == currentUser.uid,
//               //     ),
//               //   ),
//               // ),
//               newMessage(mediaQuery),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget chatBubble({
//     required bool isMe,
//     // required String userName,
//     String? imageUrl,
//     required Chat message,
//     required MediaQueryData mediaQuery,
//   }) {
//     return Row(
//       mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//       // mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           // width: MediaQuery.of(context).size.width * 0.5,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.only(
//               topLeft: const Radius.circular(12),
//               topRight: const Radius.circular(12),
//               bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
//               bottomRight: !isMe ? const Radius.circular(12) : Radius.zero,
//             ),
//             color: isMe ? Palette.aeroBlue : Palette.frenchBlue,
//           ),
//           // padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
//           margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           child: Column(
//             crossAxisAlignment:
//                 isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
//             children: [
//               // Text(
//               //   userName,
//               //   style: const TextStyle(fontWeight: FontWeight.bold),
//               // ),
//               if (imageUrl != null)
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                       topRight: Radius.circular(10),
//                       topLeft: Radius.circular(15)),
//                   child: CachedNetworkImage(
//                     height: mediaQuery.size.height * 0.2,
//                     imageUrl: imageUrl,
//                     fit: BoxFit.cover,
//                     progressIndicatorBuilder:
//                         (context, url, downloadProgress) => Center(
//                             child: CircularProgressIndicator(
//                                 value: downloadProgress.progress)),
//                     errorWidget: (context, url, error) =>
//                         const Icon(Icons.error),
//                   ),
//                 ),
//               if (message != null)
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
//                   child: Text(
//                     message.message,
//                     textAlign: isMe ? TextAlign.end : TextAlign.start,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget newMessage(MediaQueryData mediaQueryData) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       margin: const EdgeInsets.only(top: 8),
//       child: Row(
//         children: [
//           IconButton(
//               onPressed: () {
//                 bottomSheet(context, mediaQueryData);
//                 //_add attachment
//               },
//               icon: const CircleAvatar(
//                 backgroundColor: Palette.frenchBlue,
//                 child: Icon(
//                   Icons.add,
//                   color: Palette.white,
//                 ),
//               )),
//           Form(
//             key: newMessageFormKey,
//             child: Expanded(
//               child: Container(
//                 padding: EdgeInsets.only(
//                   left: mediaQueryData.size.width * 0.05,
//                   right: mediaQueryData.size.width * 0.05,
//                 ),
//                 height: 50,
//                 decoration: BoxDecoration(
//                     border: Border.all(width: 1, color: Palette.frenchBlue),
//                     borderRadius: BorderRadius.circular(50)),
//                 child: TextFormField(
//                   controller: _messageController,
//                   maxLines: 4,
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     hintText: "Send a message...",
//                     isDense: true,
//                     contentPadding:
//                         EdgeInsets.symmetric(horizontal: 0, vertical: 10),
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       _enteredMessage = value;
//                     });
//                   },
//                 ),
//               ),
//             ),
//           ),
//           IconButton(
//               onPressed: _enteredMessage.trim().isEmpty
//                   ? null
//                   // ? () {
//                   //     setState(() {
//                   //       imageUrl.add(BlocProvider.of<AuthBloc>(context)
//                   //           .state
//                   //           .user!
//                   //           .profilePicture);
//                   //     });

//                   //     chatBubble(
//                   //       isMe: true,
//                   //       mediaQuery: mediaQueryData,
//                   //       imageUrl: BlocProvider.of<AuthBloc>(context)
//                   //           .state
//                   //           .user!
//                   //           .profilePicture,
//                   //     );
//                   //   }
//                   : () {
//                       sendMessage();
//                       // chatBubble(
//                       //     isMe: true,
//                       //     message: _messageController.text,
//                       //     mediaQuery: mediaQueryData);
//                       // messages.add(_messageController.text);

//                       print(messages.length);

//                       _messageController.clear();
//                     }, //_send message implementation here
//               icon: CircleAvatar(
//                 radius: mediaQueryData.size.width * 0.05,
//                 child: Icon(
//                   Icons.send,
//                   color: Palette.white,
//                   size: mediaQueryData.size.width * 0.05,
//                 ),
//               )),
//         ],
//       ),
//     );
//   }

//   void bottomSheet(BuildContext context, MediaQueryData mediaQueryData) {
//     showModalBottomSheet(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         context: context,
//         builder: (context) {
//           return Container(
//             padding:
//                 EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
//             height: MediaQuery.of(context).size.height * 0.22,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       child: CircleAvatar(
//                           backgroundColor:
//                               Palette.privacyPolicy.withOpacity(0.25),
//                           radius: MediaQuery.of(context).size.width * 0.09,
//                           child: Icon(
//                             Icons.camera,
//                             color: Palette.privacyPolicy,
//                             size: MediaQuery.of(context).size.width * 0.08,
//                           )),
//                       onTap: () {
//                         pickImage(ImageSource.camera, mediaQueryData);
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                     const Text("Camera"),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       child: CircleAvatar(
//                         backgroundColor: Palette.green.withOpacity(0.25),
//                         radius: MediaQuery.of(context).size.width * 0.09,
//                         child: Icon(
//                           Icons.photo_size_select_actual_rounded,
//                           color: Palette.green,
//                           size: MediaQuery.of(context).size.width * 0.08,
//                         ),
//                       ),
//                       onTap: () {
//                         pickImage(ImageSource.gallery, mediaQueryData);
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                     const Text("Gallery"),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       child: CircleAvatar(
//                         backgroundColor: Palette.red.withOpacity(0.25),
//                         radius: MediaQuery.of(context).size.width * 0.09,
//                         child: Icon(
//                           Icons.file_present_rounded,
//                           color: Palette.red,
//                           size: MediaQuery.of(context).size.width * 0.08,
//                         ),
//                       ),
//                       onTap: () {
//                         // pickFile(context, mediaQueryData);
//                         RouteGenerator.navigatorKey.currentState!.pop();
//                         // Navigator.of(context).pop();
//                       },
//                     ),
//                     const Text("Document"),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         });
//   }

//   void imageBottomSheet(
//       BuildContext context, MediaQueryData mediaQuery, io.File imageToDisplay) {
//     showModalBottomSheet(
//         enableDrag: false,
//         isScrollControlled: true,
//         isDismissible: false,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         context: context,
//         builder: (context) {
//           return Container(
//             margin: const EdgeInsets.only(bottom: 10, top: 20),
//             height: MediaQuery.of(context).size.height,
//             child: Stack(
//               children: [
//                 Expanded(
//                   child: Container(
//                     alignment: Alignment.center,
//                     margin: const EdgeInsets.only(top: 20),
//                     // height: mediaQuery.size.height * 0.20,
//                     // width: mediaQuery.size.width * 20,
//                     decoration: CustomWidgets.textInputDecoration,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10.0),
//                       child: Image.file(
//                         imageToDisplay,
//                         // height: 300,
//                         width: MediaQuery.of(context).size.width,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(top: 25, left: 10),
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Palette.privacyPolicy,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: GestureDetector(
//                     child: Icon(
//                       Icons.close,
//                       color: Palette.white,
//                       size: MediaQuery.of(context).size.width * 0.08,
//                     ),
//                     onTap: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(
//                     top: mediaQuery.size.height * 0.03,
//                     right: mediaQuery.size.width * 0.03,
//                     bottom: mediaQuery.size.height * 0.03,
//                   ),
//                   alignment: Alignment.bottomRight,
//                   child: FloatingActionButton(
//                     onPressed: () {},
//                     child: const Icon(Icons.send),
//                   ),
//                 )
//               ],
//             ),
//           );
//         });
//   }
// }
