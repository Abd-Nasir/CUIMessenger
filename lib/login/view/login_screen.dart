import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return MaterialApp(
      title: 'CUI Meseenger',
      home: Scaffold(
        backgroundColor: const Color.fromARGB(232, 255, 255, 255),
        appBar: AppBar(
          leading: IconButton(
            onPressed: (() {}),
            icon: const Icon(Icons.arrow_back_sharp),
            color: const Color.fromARGB(255, 2, 77, 139),
          ),
          centerTitle: true,
          title: const Text(
            "Login",
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Stack(
              children: [
                Container(
                  height: mediaQuery.size.height,
                  decoration: const BoxDecoration(
                    color: Palette.frenchBlue,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: mediaQuery.size.height * 0.7,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(color: Colors.black),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.network(
                          'https://seeklogo.com/images/C/comsats-university-islamabad-logo-B7C2E461B5-seeklogo.com.png',
                          height: 160,
                          width: 160,
                          alignment: Alignment.topCenter,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "CUI Messenger",
                          style: TextStyle(
                              color: Color.fromARGB(255, 2, 77, 139),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 2, 77, 139),
                                  fontSize: 18),
                              hintText: 'Enter Email',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 2, 77, 139),
                                  fontSize: 18),
                              hintText: 'Enter Password',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: (() {}),
                            child: const Text(
                              "Forgot Password?",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: (() {}),
                          child: const Text(
                            "SIGN IN",
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 2, 77, 139)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account?"),
                              TextButton(
                                  onPressed: (() {}),
                                  child: Text(
                                    "Sign up here",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 2, 77, 139)),
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
      ),
    );
  }
}
