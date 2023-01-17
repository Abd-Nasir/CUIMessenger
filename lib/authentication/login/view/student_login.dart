import 'package:cui_messenger/authentication/bloc/auth_bloc.dart';
import 'package:cui_messenger/authentication/bloc/auth_event.dart';
import 'package:cui_messenger/authentication/login/view/select_user_screen.dart';
import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/helpers/routes/routenames.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:cui_messenger/helpers/style/custom_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({Key? key}) : super(key: key);

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passwordVisible = false;

  final _firebaseInstance = FirebaseAuth.instance;
  void signIn() {
    try {
      if (formKey.currentState!.validate()) {
        BlocProvider.of<AuthBloc>(context).add(AuthStudentLoginEvent(
            email: _emailController.text, password: _passwordController.text));
        setState(() {});
      }
    } catch (e) {
      print('catch  ---> $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      // backgroundColor: Palette.white,

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Palette.black,
          ),
          onPressed: () {
            BlocProvider.of<AuthBloc>(context).add(const AuthLogoutEvent());
            // RouteGenerator.navigatorKey.currentState!.pop();
            // RouteGenerator.navigatorKey.currentState!
            //     .pushReplacementNamed(selectUserRoute);
          },
        ),
        centerTitle: true,
        title: const Text(
          "Student Login",
          // textAlign: TextAlign.left,
          style: TextStyle(
              color: Palette.cuiPurple,
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: mediaQuery.size.height * 0.04),
              Image.asset('assets/images/logo.png',
                  height: 140, width: 140, alignment: Alignment.topCenter),
              SizedBox(height: mediaQuery.size.height * 0.03),
              const Text(
                "CUI Messenger",
                style: TextStyle(
                    color: Palette.cuiPurple,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: mediaQuery.size.height * 0.02),
              Form(
                key: formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.size.width * 0.05),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: mediaQuery.size.height * 0.02),
                      Container(
                        decoration: CustomWidgets.textInputDecoration,
                        padding: EdgeInsets.symmetric(
                            horizontal: mediaQuery.size.width * 0.04,
                            vertical: 4),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Palette.white,
                            labelText: 'Email',
                            labelStyle:
                                TextStyle(color: Palette.cuiBlue, fontSize: 18),
                            hintText: 'Enter Email',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your email";
                            } else if (!value.endsWith("@cuiwah.edu.pk")) {
                              return "Enter your University provided email";
                            } else if (!(value.startsWith("fa") ||
                                value.startsWith("sp") ||
                                value.startsWith("FA") ||
                                value.startsWith("Fa") ||
                                value.startsWith("SP") ||
                                value.startsWith("Sp") ||
                                value.startsWith("fA") ||
                                value.startsWith("sP"))) {
                              return "Enter valid Email";
                            } else if (value.indexOf("-") != 4) {
                              return "Enter a valid Email";
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
                            vertical: 4),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: !passwordVisible,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: passwordVisible
                                      ? Palette.grey
                                      : Palette.cuiBlue,
                                ),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Password',
                            labelStyle:
                                TextStyle(color: Palette.cuiBlue, fontSize: 18),
                            hintText: 'Enter Password',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Password";
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: (() async {
                            // _firebaseInstance.currentUser!.reload();
                            // User currentUser = _firebaseInstance.currentUser!;
                            // print(_firebaseInstance.currentUser!);
                            // _firebaseInstance.currentUser!
                            //     .updateDisplayName("Abdullah Nasir");
                            // await currentUser.sendEmailVerification().then(
                            //     (value) => print(
                            //         "Email sent to: ${currentUser.email}"));
                            // _firebaseInstance.currentUser!
                            //     .sendEmailVerification();
                            // FirebaseAuth.instance.signOut();
                            print({BlocProvider.of<AuthBloc>(context).state});
                          }),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: signIn,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Palette.cuiPurple),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                                onPressed: (() {
                                  RouteGenerator.navigatorKey.currentState!
                                      .pushNamed(studentSignupPageRoute);
                                }),
                                child: const Text(
                                  "Sign up here",
                                  style: TextStyle(color: Palette.cuiBlue),
                                ))
                          ])
                    ],
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
