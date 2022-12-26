import 'package:cui_messenger/authentication/signup/view/signup_screen.dart';
import 'package:cui_messenger/authentication/verification/user_verification.dart';
import 'package:cui_messenger/helpers/routes/routenames.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:cui_messenger/helpers/style/custom_widgets.dart';
import 'package:cui_messenger/authentication/login/view/login_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case loginScreenRoute:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case signupPageRoute:
        return MaterialPageRoute(
          builder: (_) => const SignupPage(),
        );
      case verifyMailRoute:
        return MaterialPageRoute(
          builder: (_) => const VerifyMail(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    MediaQueryData mediaQuery =
        MediaQuery.of(navigatorKey.currentContext as BuildContext);
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Container(
              height: mediaQuery.size.height,
              width: mediaQuery.size.width,
              alignment: Alignment.center,
              color: Palette.aliceBlue,
              child: Column(
                children: [
                  const Text('Error Loading Page'),
                  GestureDetector(
                    onTap: () {
                      // navigatorKey.currentState!
                      //   .pushNamedAndRemoveUntil(splashRoute, (route) => false)
                    },
                    child: Container(
                      width: mediaQuery.size.width * 0.82,
                      decoration: CustomWidgets.textInputDecoration,
                      padding: EdgeInsets.symmetric(
                          vertical: mediaQuery.size.width * 0.04,
                          horizontal: 0.0),
                      child: const Text('Go Back'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
