import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/helpers/routes/routenames.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:cui_messenger/helpers/style/custom_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _firebaseInstance = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      // backgroundColor: Palette.white,

      // appBar: AppBar(
      //   leading: IconButton(
      //     onPressed: (() {}),
      //     icon: const Icon(Icons.arrow_back_sharp),
      //     color: Palette.cuiBlue,
      //   ),
      //   centerTitle: true,
      //   title: const Text(
      //     "Login",
      //     style: TextStyle(color: Colors.black87),
      //   ),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: SafeArea(
        child: Stack(
          // alignment: Alignment.bottomCenter,
          children: [
            Container(
              color: Palette.cuiPurple.withOpacity(0.5),
              height: mediaQuery.size.height * 0.4,
              padding: EdgeInsets.only(top: 30, bottom: 20),
              // margin: EdgeInsets.only(top: 30, bottom: 20),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset('assets/images/logo.png',
                        height: 160,
                        width: 160,
                        alignment: Alignment.topCenter),
                    const Text(
                      "CUI Messenger",
                      style: TextStyle(
                          color: Palette.cuiPurple,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: mediaQuery.size.height * 0.6,
                padding: const EdgeInsets.all(30),
                alignment: Alignment.bottomCenter,
                decoration: const BoxDecoration(
                    color: Palette.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: Form(
                  key: formKey,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Students Login",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Palette.cuiBlue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        decoration: CustomWidgets.textInputDecoration,
                        padding: EdgeInsets.symmetric(
                            horizontal: mediaQuery.size.width * 0.04,
                            vertical: 4),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            filled: true,
                            fillColor: Palette.cuiOffWhite,
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
                            }
                            // else if (!value.endsWith("@cuiwah.edu.pk")) {
                            //   return "Enter your University provided email";
                            // } else if (!(value.startsWith("fa") ||
                            //     value.startsWith("sp") ||
                            //     value.startsWith("FA") ||
                            //     value.startsWith("Fa") ||
                            //     value.startsWith("SP") ||
                            //     value.startsWith("Sp") ||
                            //     value.startsWith("fA") ||
                            //     value.startsWith("sP"))) {
                            //   return "Enter valid Email";
                            // }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: CustomWidgets.textInputDecoration,
                        padding: EdgeInsets.symmetric(
                            horizontal: mediaQuery.size.width * 0.04,
                            vertical: 4),
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
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
                            _firebaseInstance.currentUser!.reload();
                            User currentUser = _firebaseInstance.currentUser!;
                            print(_firebaseInstance.currentUser!);
                            _firebaseInstance.currentUser!
                                .updateDisplayName("Abdullah Nasir");
                            // await currentUser.sendEmailVerification().then(
                            //     (value) => print(
                            //         "Email sent to: ${currentUser.email}"));
                            // _firebaseInstance.currentUser!
                            //     .sendEmailVerification();
                            // FirebaseAuth.instance.signOut();
                          }),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: (() {
                          if (formKey.currentState!.validate()) {
                            _firebaseInstance.createUserWithEmailAndPassword(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim());
                            // FirebaseAuth.instance.currentUser!
                            //     .sendEmailVerification();
                          }
                        }),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Palette.cuiBlue),
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
                                      .pushNamed(signupPageRoute);
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
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Palette.black,
                  ),
                  onPressed: () {
                    RouteGenerator.navigatorKey.currentState!.pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
