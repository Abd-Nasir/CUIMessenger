import 'package:cui_messenger/authentication/verification/user_verification.dart';
import 'package:cui_messenger/home/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/helpers/routes/routegenerator.dart';
import '/helpers/style/custom_widgets.dart';
import 'authentication/bloc/auth_bloc.dart';
import 'authentication/bloc/auth_event.dart';
import 'authentication/bloc/auth_state.dart';
import 'authentication/login/view/login_screen.dart';
import '/helpers/style/colors.dart';
// import 'package:safepall/screens/root/root.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthStateLoggedIn) {
        print("Auth is logged in");
        setState(() {});
      } else if (state is AuthStateNeedsVerification) {
        print("\n");
        print("\n");
        print("authState naeed verification");
        RouteGenerator.navigatorKey.currentState!
            .popUntil((route) => route.isFirst);
        setState(() {});
      } else if (state is AuthStateLoggedOut) {
        print("\n");
        print("\n");
        print("authState logout");
        setState(() {});
      }
    }, builder: (context, state) {
      if (state is AuthStateLoading) {
        return Scaffold(
            body: SafeArea(
          child: Center(
            child: Container(
              height: mediaQuery.size.height,
              width: mediaQuery.size.width,
              padding: EdgeInsets.symmetric(
                  vertical: mediaQuery.size.height * 0.01,
                  horizontal: mediaQuery.size.width * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "CUI Messenger",
                    style: TextStyle(
                      color: Palette.cuiPurple,
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.1),
                  SizedBox(
                    height: mediaQuery.size.width * 0.14,
                    width: mediaQuery.size.width * 0.14,
                    child: CircularProgressIndicator(
                      color: Palette.cuiPurple,
                      strokeWidth: mediaQuery.size.width * 0.02,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
      } else if (state is AuthStateLoggedIn) {
        return const HomePage();
      } else if (state is AuthStateNeedsVerification) {
        print("Accessed Auth State Verify Mail");
        return const VerifyMail();
      } else if (state is AuthStateLoginFailure) {
        return const LoginScreen(
            // error: state.exception.toString(),
            );
      } else {
        print("To login screen");
        return const LoginScreen();
      }
    });
  }
}
