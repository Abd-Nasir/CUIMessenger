import 'dart:async';

import 'package:cui_messenger/authentication/bloc/auth_bloc.dart';
import 'package:cui_messenger/authentication/bloc/auth_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '/helpers/routes/routegenerator.dart';
import '/helpers/routes/routenames.dart';
import '/helpers/style/colors.dart';
import '/helpers/style/custom_widgets.dart';
// import 'package:safepall/screens/authentication/bloc/auth_bloc.dart';
// import 'package:safepall/screens/authentication/bloc/auth_event.dart';

class VerifyMail extends StatefulWidget {
  const VerifyMail({Key? key}) : super(key: key);

  @override
  State<VerifyMail> createState() => _VerifyMailState();
}

class _VerifyMailState extends State<VerifyMail> {
  Timer? countDownTimer;
  Duration resendDuration = const Duration(seconds: 61);
  bool resendToken = false;

  void startTimer() {
    countDownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  // Step 6
  void setCountDown() {
    setState(() {
      if (resendDuration.inSeconds == 0) {
        countDownTimer!.cancel();
        resendToken = true;
      } else {
        final seconds = resendDuration.inSeconds - 1;
        resendDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  void dispose() {
    if (countDownTimer != null) {
      countDownTimer!.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          height: mediaQuery.size.height * 1,
          width: mediaQuery.size.width,
          padding:
              EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(height: mediaQuery.size.height * 0.08),
              SvgPicture.asset(
                'assets/images/email_icon.svg',
                width: mediaQuery.size.width * 0.4,
              ),
              SizedBox(height: mediaQuery.size.height * 0.04),
              const Text(
                "Verify your Account",
                textAlign: TextAlign.center,
                style: TextStyle(color: Palette.textColor, fontSize: 22.0),
              ),
              SizedBox(height: mediaQuery.size.height * 0.04),
              const Text(
                "Account activation link has been sent to:",
                textAlign: TextAlign.center,
                style: TextStyle(color: Palette.black),
              ),
              Text(
                "${FirebaseAuth.instance.currentUser!.email}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Palette.frenchBlue),
              ),
              SizedBox(height: mediaQuery.size.height * 0.04),
              GestureDetector(
                onTap: () {
                  BlocProvider.of<AuthBloc>(context)
                      .add(const ResendVerificationMail());
                  //TODO: Resend Verification Email
                  setState(() {
                    resendToken = false;
                    resendDuration = const Duration(seconds: 60);
                  });
                  startTimer();
                },
                child: Text(
                  resendToken ? "Resend email" : '${resendDuration.inSeconds}s',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: resendToken ? Palette.green : Palette.red),
                ),
              ),
              SizedBox(height: mediaQuery.size.height * 0.08),
              CustomWidgets.textButton(
                text: "Continue",
                mediaQuery: mediaQuery,
                onTap: () {
                  //TODO: Check Verification email
                  BlocProvider.of<AuthBloc>(context)
                      .add(const CheckEmailVerified());
                },
              ),
              SizedBox(height: mediaQuery.size.height * 0.02),
              CustomWidgets.textButton(
                text: "Sign out",
                mediaQuery: mediaQuery,
                onTap: () {
                  RouteGenerator.navigatorKey.currentState!.pop('dialog');
                  RouteGenerator.navigatorKey.currentState!
                      .pushNamedAndRemoveUntil(
                          studentLoginScreenRoute, (route) => false);
                  BlocProvider.of<AuthBloc>(context)
                      .add(const AuthLogoutEvent());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
