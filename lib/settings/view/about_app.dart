import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:flutter/material.dart';

import '../../helpers/routes/routegenerator.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
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
              Row(children: [
                SizedBox(width: mediaQuery.size.width * 0.05),
                IconButton(
                    onPressed: () {
                      RouteGenerator.navigatorKey.currentState!.pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Palette.cuiPurple,
                    )),
              ]),
              const Text(
                "About app",
                style: TextStyle(
                    fontSize: 30,
                    color: Palette.cuiPurple,
                    fontFamily: "assets/fonts/SulphurPoint-Regular.ttf"),
              ),
              SizedBox(height: mediaQuery.size.height * 0.05),
              const Image(
                  height: 100,
                  width: 100,
                  image: AssetImage(
                    "assets/images/logo.png",
                  )),
              SizedBox(
                height: mediaQuery.size.height * 0.01,
              ),
              const Text(
                "CUI Messenger",
                style: TextStyle(
                    color: Palette.cuiPurple,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.005,
              ),
              const Text(
                "Version 1.0.0",
                style: TextStyle(
                  fontFamily: "assets/fonts/SulphurPoint-Regular.ttf",
                  color: Palette.hintGrey,
                  fontSize: 14,
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.width * 0.1,
                  ),
                  child: Column(children: [
                    SizedBox(
                      height: mediaQuery.size.height * 0.05,
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "The “CUI Messenger” is a mobile app which will fill the gaps of communication through providing a platform where Students and Faculty can seamlessly chat, post queries, problems and much more! You will receive notifications & announcement. Moreover, public announcements on notice board serve as a university information provider.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: 1.4,
                          fontFamily: "assets/fonts/SulphurPoint-Regular.ttf",
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}
