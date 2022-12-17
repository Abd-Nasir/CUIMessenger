import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginScreen2 extends StatelessWidget {
  const LoginScreen2({Key? key}) : super(key: key);

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
            color: Palette.cuiBlue,
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
                    color: Palette.cuiBlue,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: mediaQuery.size.height * 0.7,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(color: Colors.yellow),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset('assets/images/logo.png',
                            height: 160,
                            width: 160,
                            alignment: Alignment.topCenter),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "CUI Messenger",
                          style: TextStyle(
                              color: Palette.cuiBlue,
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
                                  color: Palette.cuiBlue, fontSize: 18),
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
                                  color: Palette.cuiBlue, fontSize: 18),
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
                            backgroundColor:
                                MaterialStateProperty.all(Palette.cuiBlue),
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
      ),
    );
  }
}
