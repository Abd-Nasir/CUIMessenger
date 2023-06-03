import 'package:cui_messenger/authentication/login/view/change_password.dart';
import 'package:cui_messenger/authentication/login/view/edit_profile.dart';
import 'package:cui_messenger/authentication/login/view/select_user_screen.dart';
import 'package:cui_messenger/authentication/login/view/faculty_login.dart';
import 'package:cui_messenger/authentication/signup/view/faculty_signup.dart';
import 'package:cui_messenger/authentication/signup/view/student_signup_screen.dart';
import 'package:cui_messenger/authentication/verification/user_verification.dart';
import 'package:cui_messenger/feed/view/comment_screen.dart';

import 'package:cui_messenger/feed/view/new_post_screen.dart';
import 'package:cui_messenger/feed/view/preview_image.dart';
import 'package:cui_messenger/helpers/routes/routenames.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:cui_messenger/helpers/style/custom_widgets.dart';
import 'package:cui_messenger/authentication/login/view/student_login.dart';
import 'package:cui_messenger/splash.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
        );
      case selectUserRoute:
        return MaterialPageRoute(
          builder: (_) => const SelectUserScreen(),
        );
      case studentLoginScreenRoute:
        return MaterialPageRoute(
          builder: (_) => const StudentLoginScreen(),
        );
      case facultyLoginScreenRoute:
        return MaterialPageRoute(
          builder: (_) => const FacultyLoginScreen(),
        );
      case facultySignupPageRoute:
        return MaterialPageRoute(
          builder: (_) => const FacultySignupPage(),
        );
      case studentSignupPageRoute:
        return MaterialPageRoute(
          builder: (_) => const StudentSignupPage(),
        );
      case verifyMailRoute:
        return MaterialPageRoute(
          builder: (_) => const VerifyMail(),
        );
      case commentScreenRoute:
        if (args != null) {
          return MaterialPageRoute(
            builder: (_) => CommentBox(
              postId: args as String,
            ),
          );
        }

        return _errorRoute();

      case newPostScreenRoute:
        return MaterialPageRoute(
          builder: (_) => const NewPost(),
        );
      case editProfileRoute:
        return MaterialPageRoute(
          builder: (_) => const EditProfilePage(),
        );
      case changePasswordRoute:
        return MaterialPageRoute(
          builder: (_) => ChangePassword(),
        );
      case newPostRoute:
        return PageRouteBuilder(
          transitionDuration: const Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const NewPost(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var curve = Curves.easeOutCirc;
            var curveTween = CurveTween(curve: curve);
            const begin = Offset(0.0, 2.0);
            const end = Offset.zero;
            var tween = Tween(begin: begin, end: end).chain(curveTween);
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      case imagePreviewRoute:
        if (args != null) {
          return MaterialPageRoute(
            builder: (_) => PreviewImage(
              imageUrl: args as String,
            ),
          );
        }
        return _errorRoute();
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
