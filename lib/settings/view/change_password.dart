import 'package:cui_messenger/authentication/bloc/auth_bloc.dart';
import 'package:cui_messenger/authentication/bloc/auth_event.dart';
import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:cui_messenger/helpers/style/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController oldPasswordController = TextEditingController();

  final TextEditingController retypeOldPasswordController =
      TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();

  String error = "";

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Palette.white,
      body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(width: mediaQuery.size.width * 0.05),
                    IconButton(
                        onPressed: () {
                          RouteGenerator.navigatorKey.currentState!.pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Palette.cuiPurple,
                        ))
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.size.width * 0.1),
                  child: Column(
                    children: [
                      SizedBox(height: mediaQuery.size.height * 0.07),
                      const Text(
                        "Change Password",
                        style: TextStyle(
                            color: Palette.cuiPurple,
                            fontSize: 28,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: mediaQuery.size.height * 0.03),
                      const Text(
                        "Wanna change your password?\n Make sure you choose a strong one!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Palette.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: mediaQuery.size.height * 0.05),
                      Container(
                        decoration: CustomWidgets.textInputDecoration,
                        padding: EdgeInsets.symmetric(
                            horizontal: mediaQuery.size.width * 0.04,
                            vertical: 4),
                        child: TextFormField(
                          controller: oldPasswordController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter old Password",
                            hintStyle: TextStyle(
                              color: Palette.hintGrey,
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      SizedBox(height: mediaQuery.size.height * 0.03),
                      Container(
                        decoration: CustomWidgets.textInputDecoration,
                        padding: EdgeInsets.symmetric(
                            horizontal: mediaQuery.size.width * 0.04,
                            vertical: 4),
                        child: TextFormField(
                          controller: newPasswordController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter new Password",
                            hintStyle: TextStyle(
                              color: Palette.hintGrey,
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      SizedBox(height: mediaQuery.size.height * 0.03),
                      Container(
                        decoration: CustomWidgets.textInputDecoration,
                        padding: EdgeInsets.symmetric(
                            horizontal: mediaQuery.size.width * 0.04,
                            vertical: 4),
                        child: TextFormField(
                          controller: retypeOldPasswordController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Re-type new password",
                            hintStyle: TextStyle(
                              color: Palette.hintGrey,
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      SizedBox(height: mediaQuery.size.height * 0.04),
                      ElevatedButton(
                        onPressed: () {
                          if (newPasswordController.text ==
                              retypeOldPasswordController.text) {
                            BlocProvider.of<AuthBloc>(context).add(
                                UpdateUserPasswordEvent(
                                    oldPassword: oldPasswordController.text,
                                    updatedPassword:
                                        newPasswordController.text));
                          } else {
                            setState(() {
                              error = "The passwords must be same";
                            });
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Palette.cuiPurple),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Change Password",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
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
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
