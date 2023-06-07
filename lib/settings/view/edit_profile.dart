import 'dart:io';

import 'package:cui_messenger/authentication/bloc/auth_bloc.dart';
import 'package:cui_messenger/authentication/bloc/auth_event.dart';
import 'package:cui_messenger/authentication/model/user_model.dart';
import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:cui_messenger/helpers/style/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:overlay_support/overlay_support.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController regNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  XFile? pickedImage;

  late UserModel user;

  @override
  void initState() {
    user = BlocProvider.of<AuthBloc>(context).state.user!;
    super.initState();
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
    emailController.text = user.email;
    phoneController.text = user.phoneNo;
    regNoController.text = user.regNo;
    // regController.text = user.regNo;

    print('hjfdgfdijijfgi   ${user.toJson()}');
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.04),
          child: Column(
            children: [
              SizedBox(height: mediaQuery.size.height * 0.03),
              buildHeader(mediaQuery),
              SizedBox(height: mediaQuery.size.height * 0.01),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.size.width * 0.02),
                    child: Column(
                      children: [
                        SizedBox(height: mediaQuery.size.height * 0.02),
                        createContactPicture(mediaQuery, user.profilePicture),
                        SizedBox(height: mediaQuery.size.height * 0.03),
                        Container(
                          decoration: CustomWidgets.textInputDecoration,
                          padding: EdgeInsets.symmetric(
                              horizontal: mediaQuery.size.width * 0.04,
                              vertical: 4),
                          child: TextFormField(
                            controller: firstNameController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "First Name",
                              hintStyle: TextStyle(
                                color: Palette.hintGrey,
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            readOnly: true,
                            onTap: () {
                              showSimpleNotification(
                                const Text("Sorry, Cannot be changed"),
                                background: Palette.yellow.withOpacity(0.9),
                                duration: const Duration(seconds: 2),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.03),
                        Container(
                          decoration: CustomWidgets.textInputDecoration,
                          padding: EdgeInsets.symmetric(
                              horizontal: mediaQuery.size.width * 0.04,
                              vertical: 4),
                          child: TextFormField(
                            controller: lastNameController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Last Name",
                              hintStyle: TextStyle(
                                color: Palette.hintGrey,
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            readOnly: true,
                            onTap: () {
                              showSimpleNotification(
                                const Text("Sorry cannot be changed"),
                                background: Palette.yellow.withOpacity(0.9),
                                duration: const Duration(seconds: 2),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.03),
                        Container(
                          decoration: CustomWidgets.textInputDecoration,
                          padding: EdgeInsets.symmetric(
                              horizontal: mediaQuery.size.width * 0.04,
                              vertical: 4.0),
                          child: TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(
                                color: Palette.hintGrey,
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              showSimpleNotification(
                                const Text("Sorry email cannot be changed"),
                                background: Palette.yellow.withOpacity(0.9),
                                duration: const Duration(seconds: 2),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.03),
                        Container(
                          decoration: CustomWidgets.textInputDecoration,
                          padding: EdgeInsets.symmetric(
                              horizontal: mediaQuery.size.width * 0.04,
                              vertical: 4.0),
                          child: TextFormField(
                            controller: phoneController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone no",
                              hintStyle: TextStyle(
                                color: Palette.hintGrey,
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.03),
                        Container(
                          decoration: CustomWidgets.textInputDecoration,
                          padding: EdgeInsets.symmetric(
                              horizontal: mediaQuery.size.width * 0.04,
                              vertical: 4.0),
                          child: TextFormField(
                            controller: regNoController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Reg No",
                              hintStyle: TextStyle(
                                color: Palette.hintGrey,
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              showSimpleNotification(
                                const Text("Sorry cannot be changed"),
                                background: Palette.yellow.withOpacity(0.9),
                                duration: const Duration(seconds: 2),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.03),
                        GestureDetector(
                          onTap: () {
                            deleteUserBottomSheet(context, mediaQuery);
                          },
                          child: Container(
                            width: mediaQuery.size.width,
                            padding: EdgeInsets.symmetric(
                                vertical: mediaQuery.size.height * 0.02,
                                horizontal: mediaQuery.size.width * 0.02),
                            decoration: BoxDecoration(
                              color: Palette.red,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0.0, 2.0),
                                  blurRadius: 16.0,
                                  color: Palette.red.withOpacity(0.15),
                                )
                              ],
                            ),
                            child: const Text(
                              "Delete your account!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Palette.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: mediaQuery.size.width * 0.04),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createContactPicture(
      MediaQueryData mediaQuery, String profilePicture) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: mediaQuery.size.width * 0.4,
          height: mediaQuery.size.width * 0.4,
          decoration: BoxDecoration(
            color: Palette.white,
            borderRadius: BorderRadius.circular(200.0),
            boxShadow: [
              BoxShadow(
                color: Palette.frenchBlue.withOpacity(0.25),
                offset: const Offset(0.0, 2.0),
                blurRadius: 16.0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(200.0),
            child: pickedImage != null
                ? Image.file(
                    File(pickedImage!.path),
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    profilePicture,
                    width: mediaQuery.size.width * 0.4,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                bottomSheet(context);
              },
              child: Container(
                width: mediaQuery.size.width * 0.36,
                padding: EdgeInsets.symmetric(
                    vertical: mediaQuery.size.height * 0.02,
                    horizontal: mediaQuery.size.width * 0.02),
                decoration: BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0.0, 2.0),
                      blurRadius: 16.0,
                      color: Palette.cuiPurple.withOpacity(0.15),
                    )
                  ],
                ),
                child: const Text(
                  "Upload Picture",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Palette.cuiPurple),
                ),
              ),
            ),
            SizedBox(height: mediaQuery.size.height * 0.02),
            (pickedImage != null)
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        pickedImage = null;
                      });
                    },
                    child: Container(
                      width: mediaQuery.size.width * 0.36,
                      padding: EdgeInsets.symmetric(
                          vertical: mediaQuery.size.height * 0.02,
                          horizontal: mediaQuery.size.width * 0.02),
                      decoration: BoxDecoration(
                        color: Palette.red,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0.0, 2.0),
                            blurRadius: 16.0,
                            color: Palette.red.withOpacity(0.15),
                          )
                        ],
                      ),
                      child: const Text(
                        "Delete Picture",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Palette.white),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ],
    );
  }

  Widget buildHeader(MediaQueryData mediaQuery) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: Palette.white,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.size.width * 0.08,
                  vertical: mediaQuery.size.height * 0.02),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              title: const Text(
                "Discard changes",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Palette.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              content: const Text(
                "Are you sure you want to discard?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Palette.textColor,
                  fontSize: 12.0,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    RouteGenerator.navigatorKey.currentState!.pop('dialog');
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Palette.textColor, fontSize: 12.0),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    RouteGenerator.navigatorKey.currentState!.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Palette.red,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0.0, 0.0),
                          blurRadius: 16.0,
                          color: Palette.red.withOpacity(0.25),
                        ),
                      ],
                    ),
                    child: const Text(
                      "Discard",
                      style: TextStyle(color: Palette.white, fontSize: 12.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          icon: const Icon(Icons.close),
          color: Palette.textColor,
        ),
        const Text(
          "Account",
          style: TextStyle(
            color: Palette.textColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {
            if (user.phoneNo != phoneController.text || pickedImage != null) {
              if (pickedImage != null) {
                BlocProvider.of<AuthBloc>(context).add(
                  AuthUpdateUserDataEvent(
                    uId: user.uid,
                    file: pickedImage!,
                    oldImageUrl: BlocProvider.of<AuthBloc>(context)
                        .state
                        .user!
                        .profilePicture,
                    phoneNo: phoneController.text,
                  ),
                );
              } else {
                BlocProvider.of<AuthBloc>(context).add(
                  AuthUpdateUserDataEvent(
                    oldImageUrl: user.profilePicture,
                    file: null,
                    uId: user.uid,
                    phoneNo: phoneController.text,
                  ),
                );
              }
              RouteGenerator.navigatorKey.currentState!.pop(context);
              setState(() {});
            } else {
              showSimpleNotification(
                const Text("No details changed"),
                background: Palette.yellow.withOpacity(0.9),
                duration: const Duration(seconds: 2),
              );
            }
          },
          child: Container(
            decoration: CustomWidgets.buttonDecoration,
            padding:
                const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
            child: const Icon(
              Icons.check,
              color: Palette.white,
            ),
          ),
        ),
      ],
    );
  }

  Future pickImage(ImageSource source) async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 60,
        maxHeight: 600,
        maxWidth: 600,
      );
      if (image == null) return;
      // final imageTemporary = io.File(image.path);
      setState(() {
        pickedImage = image;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void deleteUserBottomSheet(BuildContext context, MediaQueryData mediaQuery) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    showModalBottomSheet(
        backgroundColor: Palette.white,
        // isDismissible: false,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.size.width * 0.08,
              // vertical: mediaQuery.size.height * 0.15
            ),
            // height: MediaQuery.of(context).size.height * 0.22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: mediaQuery.size.height * 0.1),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          RouteGenerator.navigatorKey.currentState!.pop();
                        },
                        icon: const Icon(Icons.close)),
                  ],
                ),
                // ),
                SizedBox(height: mediaQuery.size.height * 0.1),
                const Icon(
                  Icons.remove_moderator_rounded,
                  size: 100,
                  color: Palette.cuiPurple,
                ),
                SizedBox(height: mediaQuery.size.height * 0.02),
                const Text(
                  "Are you sure you want to delete your account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Palette.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),

                SizedBox(height: mediaQuery.size.height * 0.02),
                const Text(
                  "Verify by logging in with your Email & Password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.03),

                // Container(
                //   decoration: CustomWidgets.textInputDecoration,
                //   padding: EdgeInsets.symmetric(
                //       horizontal: mediaQuery.size.width * 0.04, vertical: 4),
                //   child: TextFormField(
                //     controller: _emailController,
                //     decoration: const InputDecoration(
                //       border: InputBorder.none,
                //       hintText: "Email",
                //       hintStyle: TextStyle(
                //         color: Palette.hintGrey,
                //       ),
                //     ),
                //     keyboardType: TextInputType.text,
                //   ),
                // ),
                // SizedBox(height: mediaQuery.size.height * 0.02),
                Container(
                  decoration: CustomWidgets.textInputDecoration,
                  padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.size.width * 0.04, vertical: 4),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Password",
                      hintStyle: TextStyle(
                        color: Palette.hintGrey,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.03),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Palette.red),
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(
                          AuthDeleteAccountEvent(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim()));
                    },
                    child: const Text("Delete Account")),
              ],
            ),
          );
        });
  }

  void bottomSheet(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
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
                  leading: const Icon(Icons.browse_gallery_outlined),
                  title: const Text("Choose Gallery"),
                  onTap: () {
                    pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.camera),
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
