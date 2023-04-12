import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io' as io;

import '../../helpers/style/colors.dart';
import '../../helpers/style/custom_widgets.dart';
import '../model/posts.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  XFile? pickedImage;

  Future pickImage(ImageSource source) async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 60,
        maxHeight: 600,
        maxWidth: 600,
      );
      if (image == null) return;
      setState(() {
        pickedImage = image;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: Palette.cuiOffWhite,
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.done_rounded))
          ],
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          title: const Text(
            'Create Post',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          backgroundColor: Palette.cuiOffWhite,
          centerTitle: true,
        ),
        // bottomSheet: bottomSheet(context),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const TextField(
                            decoration: InputDecoration(
                                hintText: "What's on your mind?"),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          SizedBox(height: mediaQuery.size.height * 0.02),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight: mediaQuery.size.height * 0.6,
                                maxWidth: mediaQuery.size.width * 1),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 1),
                              ),
                              child: pickedImage == null
                                  ? const Icon(Icons.image_outlined,
                                      size: 200, color: Palette.grey
                                      // size: mediaQuery.size.width * 1,
                                      )
                                  : Image.file(
                                      io.File(pickedImage!.path),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                CustomWidgets.textButton(
                  text: "Upload Image",
                  onTap: () {
                    bottomSheet(context);
                  },
                  mediaQuery: mediaQuery,
                ),
              ],
            ),
          ],
        ));
  }

  void bottomSheet(BuildContext context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (context) {
          return Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
            height: MediaQuery.of(context).size.height * 0.22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text("Choose Gallery"),
                  onTap: () {
                    pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Camera"),
                  onTap: () {
                    pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
