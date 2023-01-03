import 'dart:io' as io;

import 'package:cui_messenger/authentication/bloc/auth_bloc.dart';
import 'package:cui_messenger/authentication/bloc/auth_event.dart';
import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/helpers/routes/routenames.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:cui_messenger/helpers/style/custom_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';
// import 'package:safepall/screens/authentication/bloc/auth_bloc.dart';
// import 'package:safepall/screens/authentication/bloc/auth_event.dart';

class FacultySignupPage extends StatefulWidget {
  const FacultySignupPage({Key? key}) : super(key: key);

  @override
  State<FacultySignupPage> createState() => _FacultySignupPageState();
}

class _FacultySignupPageState extends State<FacultySignupPage> {
  final signUpFormKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();
  TextEditingController countryCodeController =
      TextEditingController(text: "+92");

  DateTime dateTime = DateTime.now();
  String error = "";
  bool isLoading = false;

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
      // final imageTemporary = io.File(image.path);
      setState(() {
        pickedImage = image;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void signup() {
    if (signUpFormKey.currentState!.validate()) {
      if (passwordController.text != retypePasswordController.text) {
        setState(() {
          error = "The passwords must be same";
        });
      } else {
        setState(() {
          error = "";
        });
        if (pickedImage != null) {
          setState(() {
            isLoading = true;
          });
          BlocProvider.of<AuthBloc>(context).add(
            AuthFacultyRegisterEvent(
              userData: {
                "uid": "",
                "first-name": firstNameController.text,
                "last-name": lastNameController.text,
                "reg-no": "Faculty member",
                "role": "faculty",
                "email": emailController.text.trim(),
                "phone": countryCodeController.text + phoneController.text,
                "date-of-birth": dateTime.toIso8601String(),
                "password": passwordController.text.trim(),
                "imageUrl": "",
              },
              file: pickedImage!,
            ),
          );

          setState(() {
            isLoading = false;
          });
        } else {
          showSimpleNotification(
            slideDismissDirection: DismissDirection.horizontal,
            const Text("Select an Image"),
            background: Palette.red.withOpacity(0.9),
            duration: const Duration(seconds: 2),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.transparent,
        backgroundColor: Palette.white,
        leading: IconButton(
          onPressed: () {
            RouteGenerator.navigatorKey.currentState!.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Palette.cuiBlue,
          ),
        ),
        title: const Text(
          "Faculty Signup",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Palette.cuiBlue,
              fontSize: 22.0,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: signUpFormKey,
          child: Container(
            width: mediaQuery.size.width,
            height: mediaQuery.size.height,
            color: Palette.white,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.size.width * 0.04, vertical: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: mediaQuery.size.height * 0.01),
                  Container(
                    height: mediaQuery.size.width * 0.3,
                    width: mediaQuery.size.width * 0.3,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: pickedImage == null
                          ? Icon(Icons.account_circle_rounded,
                              size: mediaQuery.size.width * 0.3,
                              color: Palette.cuiBlue
                              // size: mediaQuery.size.width * 0.4,
                              )
                          : Image.file(io.File(pickedImage!.path),
                              fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.02),
                  CustomWidgets.textButton(
                    color: Palette.cuiBlue,
                    mediaQuery: mediaQuery,
                    text: "Upload Image",
                    onTap: () {
                      bottomSheet(context);
                    },
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.04),
                  Container(
                    decoration: CustomWidgets.textInputDecoration,
                    padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.size.width * 0.04,
                        vertical: 0.01),
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter First Name";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.03),
                  Container(
                    decoration: CustomWidgets.textInputDecoration,
                    padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.size.width * 0.04,
                        vertical: 0.01),
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter last name";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.03),
                  Container(
                    decoration: CustomWidgets.textInputDecoration,
                    padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.size.width * 0.04,
                        vertical: 0.01),
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email",
                        hintStyle: TextStyle(
                          color: Palette.hintGrey,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Email";
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return "Enter valid email";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: CustomWidgets.textInputDecoration,
                        padding: EdgeInsets.symmetric(
                            horizontal: mediaQuery.size.width * 0.04,
                            vertical: 0.01),
                        width: mediaQuery.size.width * 0.2,
                        child: TextFormField(
                          controller: countryCodeController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "+92",
                            hintStyle: TextStyle(
                              color: Palette.hintGrey,
                            ),
                          ),
                          readOnly: false,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      Container(
                        decoration: CustomWidgets.textInputDecoration,
                        padding: EdgeInsets.symmetric(
                            horizontal: mediaQuery.size.width * 0.04,
                            vertical: 0.01),
                        width: mediaQuery.size.width * 0.65,
                        child: TextFormField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Contact No",
                            hintStyle: TextStyle(
                              color: Palette.hintGrey,
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Phone No";
                            } else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                                .hasMatch(value)) {
                              return "Enter valid No";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.03),
                  Container(
                    decoration: CustomWidgets.textInputDecoration,
                    padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.size.width * 0.04,
                        vertical: 0.01),
                    child: TextFormField(
                      controller: dateOfBirthController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Date of Birth",
                        hintStyle: TextStyle(
                          color: Palette.hintGrey,
                        ),
                      ),
                      keyboardType: TextInputType.datetime,
                      readOnly: true,
                      onTap: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(1900, 1, 1),
                            maxTime: DateTime.now(),
                            currentTime: dateTime, onConfirm: (date) {
                          dateTime = date;
                          dateOfBirthController.text =
                              "${date.day}-${date.month}-${date.year}";
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Select a date";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.03),
                  Container(
                    decoration: CustomWidgets.textInputDecoration,
                    padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.size.width * 0.04,
                        vertical: 0.01),
                    child: TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",
                        hintStyle: TextStyle(
                          color: Palette.hintGrey,
                        ),
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Valid Password";
                        } else if (value.length < 6) {
                          return "Enter Valid Password";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.03),
                  Container(
                    decoration: CustomWidgets.textInputDecoration,
                    padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.size.width * 0.04,
                        vertical: 0.01),
                    child: TextFormField(
                      controller: retypePasswordController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Re-type Password",
                        hintStyle: TextStyle(
                          color: Palette.hintGrey,
                        ),
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Retype Password";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.03),
                  isLoading
                      ? const CircularProgressIndicator()
                      : CustomWidgets.textButton(
                          text: "Register", mediaQuery: mediaQuery,
                          onTap: signup,
                          color: Palette.cuiBlue,
                          //TODO: Signup implementation
                        ),
                  if (error.isNotEmpty)
                    SizedBox(height: mediaQuery.size.height * 0.02),
                  if (error.isNotEmpty)
                    Text(
                      error,
                      style: const TextStyle(
                        color: Palette.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                      ),
                    ),
                  SizedBox(height: mediaQuery.size.height * 0.04),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Joined us before?",
                          style: TextStyle(color: Palette.black),
                        ),
                        TextSpan(
                          text: "Login Here",
                          style: const TextStyle(
                              color: Palette.frenchBlue,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacementNamed(
                                  context, facultyLoginScreenRoute);
                            },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.08),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
