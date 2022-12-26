import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
// import 'package:permission_handler/permission_handler.dart';
import '/authentication/bloc/auth_event.dart';
import '/authentication/bloc/auth_provider.dart';
import '/authentication/bloc/auth_state.dart';
import '/helpers/routes/routegenerator.dart';
import '/helpers/routes/routenames.dart';
import '/helpers/style/colors.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading(null)) {
    on<AuthEventInitialize>((event, emit) async {
      // print("Auth Bloc Event Initialized");
      // Check Notifications and Exit App
      emit(const AuthStateLoading(null));
      emit(const AuthStateNeedsVerification(null));
      //    else {
      //   emit(const AuthStateNotificationError(null));
    });

    on<AuthMailLoginEvent>(
      (event, emit) async {
        emit(const AuthStateLoading(null));

        try {
          print("Inside log in");
          await provider
              .logInWithEmail(email: event.email, password: event.password)
              .then((user) async {
            print(user);
            if (user != null) {
              if (FirebaseAuth.instance.currentUser!.emailVerified) {
                // print("\nEmitting Logged in user!\n");
                emit(AuthStateLoggedIn(user));
              } else {
                emit(AuthStateNeedsVerification(user));
                // RouteGenerator.navigatorKey.currentState!
                //     .pushNamedAndRemoveUntil(verifyMailRoute, (route) => false);
              }
            } else {
              emit(AuthStateLoginFailure(
                  Exception("Unknown error occurred. Please try again later!"),
                  null));
            }
          });
        } on FirebaseAuthException catch (error) {
          print("In Exception Here");
          if (error.code == 'invalid-email') {
            emit(AuthStateLoginFailure(
                Exception("Invalid email entered!"), null));
          } else if (error.code == 'user-disabled') {
            emit(AuthStateLoginFailure(
                Exception("User has been disabled!"), null));
          } else if (error.code == 'user-not-found') {
            emit(AuthStateLoginFailure(
                Exception("User does not exist, please check your details!"),
                null));
          } else if (error.code == 'wrong-password') {
            emit(AuthStateLoginFailure(
                Exception("User does not exist, please check your details!"),
                null));
          } else {
            emit(AuthStateLoginFailure(
                Exception("Unknown error occurred"), null));
          }
        } catch (error) {
          print("Here");
          emit(
              AuthStateLoginFailure(Exception("Unknown error occurred"), null));
        }
      },
    );

    on<AuthMailRegisterEvent>(
      (event, emit) async {
        emit(const AuthStateLoading(null));

        final user =
            await provider.registerWithEmail(event.userData, event.file);
        if (user != null) {
          if (FirebaseAuth.instance.currentUser!.emailVerified) {
            emit(AuthStateLoggedIn(user));
            // print("Pushing to home page!");]
            //TODO: Push to homepage
            // RouteGenerator.navigatorKey.currentState!.pushNamedAndRemoveUntil(
            //     home, (route) => route.isFirst);
          } else {
            FirebaseAuth.instance.currentUser!.sendEmailVerification();
            emit(AuthStateNeedsVerification(user));
            RouteGenerator.navigatorKey.currentState!.pushNamedAndRemoveUntil(
                verifyMailRoute, (route) => route.isFirst);
          }
        } else {
          emit(AuthStateLoginFailure(Exception("Failed to login"), null));
        }
      },
    );

    on<AuthLogoutEvent>(
      (event, emit) async {
        emit(const AuthStateLoading(null));
        await FirebaseAuth.instance.signOut();
        emit(const AuthStateLoggedOut(null));
      },
    );

    // on<AuthForgotPasswordSendOTPEvent>((event, emit) {
    //   emit(const AuthStateLoading(null));

    //   provider.sendPinCodeToPhone(event.phone).then((value) {
    //     if (value) {
    //       RouteGenerator.navigatorKey.currentState!.pushNamed(
    //           forgotPasswordVerificationRoute,
    //           arguments: event.phone);
    //       showSimpleNotification(
    //         Text(AppLocalizations.instance.tr('otp_sent')),
    //         background: Palette.green.withOpacity(0.9),
    //         duration: const Duration(seconds: 2),
    //         slideDismissDirection: DismissDirection.horizontal,
    //       );
    //     }
    //   });
    // });

    // on<AuthForgotPasswordVerifyOTPEvent>((event, emit) async {
    //   emit(const AuthStateLoading(null));

    //   try {
    //     await provider.verifyPhone(code: event.code).then((value) {
    //       if (value) {
    //         RouteGenerator.navigatorKey.currentState!
    //             .pushNamed(resetPasswordRoute);
    //       }
    //     });
    //   } catch (error) {
    //     print(error);
    //   }
    // });

    // on<UpdateUserPasswordEvent>((event, emit) async {
    //   emit(const AuthStateLoading(null));
    //   try {
    //     await provider
    //         .updateUserPassword(password: event.password)
    //         .then((value) async {
    //       if (value) {
    //         await provider.loginWithPhone().then((value) {
    //           if (value) {
    //             emit(AuthStateLoggedIn(provider.currentUser));
    //             showSimpleNotification(
    //               Text(AppLocalizations.instance.tr('password_update_success')),
    //               background: Palette.green.withOpacity(0.9),
    //               duration: const Duration(seconds: 2),
    //               slideDismissDirection: DismissDirection.horizontal,
    //             );

    //             RouteGenerator.navigatorKey.currentState!
    //                 .pushNamedAndRemoveUntil(rootRoute, (route) => false);
    //           }
    //         });
    //       }
    //     });
    //   } catch (error) {
    //     print(error);
    //   }
    // });

    // on<AuthLoggedInAndPaid>((event, emit) async {
    //   await Purchases.logIn(provider.currentUser!.uid);
    //   if (provider.currentUser!.payment == "trial") {
    //     print("Trial");
    //     await provider.saveUser();
    //     // showSimpleNotification(
    //     // slideDismissDirection: DismissDirection.horizontal,
    //     //   Text(AppLocalizations.instance.tr('trial_success')),
    //     //   background: Palette.green.withOpacity(0.9),
    //     //   duration: const Duration(seconds: 2),

    //     // );
    //     // RouteGenerator.navigatorKey.currentState!
    //     //     .pushNamedAndRemoveUntil(rootRoute, (route) => false);

    //     // emit(AuthStateLoggedInAndPaid(provider.currentUser));
    //     DateTime trialStartDate =
    //         DateTime.parse(provider.currentUser!.trialStarted);
    //     DateTime today = DateTime.now();
    //     Duration dif = today.difference(trialStartDate);
    //     print(
    //         "Date: ${trialStartDate.toString()}\nDifference in time: ${dif.inSeconds}\nDays: ${dif.inDays}");
    //     if (dif.inDays < 8) {
    //       provider.currentUser!.isTrialCompleted = false;
    //       emit(AuthStateLoggedInAndPaid(provider.currentUser));
    //     } else {
    //       provider.currentUser!.isTrialCompleted = true;
    //       emit(AuthStateLoggedIn(provider.currentUser));
    //     }
    //   } else if (provider.currentUser!.payment == "yearly") {
    //     print("Yearly Subscribed");
    //     await provider.saveUser();
    //     DateTime paymentDate =
    //         DateTime.parse(provider.currentUser!.lastPaymentDate);
    //     DateTime today = DateTime.now();
    //     Duration dif = today.difference(paymentDate);
    //     if (dif.inDays <= 365) {
    //       RouteGenerator.navigatorKey.currentState!
    //           .pushNamedAndRemoveUntil(rootRoute, (route) => false);
    //       emit(AuthStateLoggedInAndPaid(provider.currentUser));
    //     } else {
    //       emit(AuthStateLoggedIn(provider.currentUser));
    //     }
    //   } else if (provider.currentUser!.payment == "monthly") {
    //     print("Monthly Subscribed");
    //     await provider.saveUser();
    //     DateTime paymentDate =
    //         DateTime.parse(provider.currentUser!.lastPaymentDate);
    //     DateTime today = DateTime.now();
    //     Duration dif = today.difference(paymentDate);
    //     if (dif.inDays <= 30) {
    //       emit(AuthStateLoggedIn(provider.currentUser));
    //     } else {
    //       RouteGenerator.navigatorKey.currentState!
    //           .pushNamedAndRemoveUntil(rootRoute, (route) => false);
    //       emit(AuthStateLoggedInAndPaid(provider.currentUser));
    //     }
    //   }
    //   // print(
    //   //     "Setting user to be on trial!\nState: ${provider.currentUser!.payment}");
    // });

    // on<AuthUploadUserProfilePictureEvent>((event, emit) async {
    //   await provider.uploadProfilePicture(event.file, event.userID);
    // });

    // on<AuthUpdateUserDataEvent>(
    //   (event, emit) async {
    //     var response = await provider.updateUserData(
    //         userid: event.userid,
    //         dataChanged: event.dataChanged,
    //         file: event.file,
    //         oldImageKey: event.oldImageKey);
    //     if (response) {
    //       showSimpleNotification(
    //         Text(AppLocalizations.instance.tr('user_update_success')),
    //         background: Palette.green.withOpacity(0.9),
    //         duration: const Duration(seconds: 2),
    //         slideDismissDirection: DismissDirection.horizontal,
    //       );
    //     } else {
    //       showSimpleNotification(
    //         Text(AppLocalizations.instance.tr('update_user_failed')),
    //         background: Palette.red.withOpacity(0.9),
    //         duration: const Duration(seconds: 2),
    //         slideDismissDirection: DismissDirection.horizontal,
    //       );
    //     }
    //   },
    // );

    on<CheckEmailVerified>((event, emit) async {
      await FirebaseAuth.instance.currentUser!.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        emit(AuthStateLoggedIn(provider.currentUser));
        // RouteGenerator.navigatorKey.currentState!
        //     .pushNamedAndRemoveUntil(paymentRoute, (route) => false);
        // add(const OnAuthNavigateAppEvent());
      } else {
        // Do nothing and stay on the same screen.
      }
    });

    on<ResendVerificationMail>((event, emit) async {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    });

    // on<AuthDeleteAccountEvent>((event, emit) async {
    //   bool res = await provider.deleteAccount(event.email);
    //   if (res) {
    //     emit(const AuthStateLoggedOut(null));
    //   }
    // });

    // on<AuthForgotPasswordEvent>(
    //   (event, emit) async {
    //     try {
    //       emit(const AuthStateLoading(null));
    //       await FirebaseAuth.instance
    //           .sendPasswordResetEmail(email: event.email);
    //       showSimpleNotification(
    //         Text(AppLocalizations.instance.tr('forgot-password-sent-success')),
    //         background: Palette.green.withOpacity(0.9),
    //         duration: const Duration(seconds: 2),
    //         slideDismissDirection: DismissDirection.horizontal,
    //       );
    //       emit(const AuthStateLoggedOut(null));
    //     } on FirebaseAuthException catch (error) {
    //       if (error.code == "invalid-email") {
    //         showSimpleNotification(
    //           Text(AppLocalizations.instance.tr('invalid-email')),
    //           background: Palette.red.withOpacity(0.9),
    //           duration: const Duration(seconds: 2),
    //           slideDismissDirection: DismissDirection.horizontal,
    //         );
    //       } else if (error.code == "user-not-found") {
    //         showSimpleNotification(
    //           Text(AppLocalizations.instance.tr('user-not-found')),
    //           background: Palette.red.withOpacity(0.9),
    //           duration: const Duration(seconds: 2),
    //           slideDismissDirection: DismissDirection.horizontal,
    //         );
    //       } else {
    //         showSimpleNotification(
    //           Text(AppLocalizations.instance.tr('unknown-error-occurred')),
    //           background: Palette.red.withOpacity(0.9),
    //           duration: const Duration(seconds: 2),
    //           slideDismissDirection: DismissDirection.horizontal,
    //         );
    //       }
    //     } catch (error) {
    //       print("Error occured in Forgot Password: $error");
    //       showSimpleNotification(
    //         Text(AppLocalizations.instance.tr('unknown-error-occurred')),
    //         background: Palette.red.withOpacity(0.9),
    //         duration: const Duration(seconds: 2),
    //         slideDismissDirection: DismissDirection.horizontal,
    //       );
    //     }
    //   },
    // );
  }
}
