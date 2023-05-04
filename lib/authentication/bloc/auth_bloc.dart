import 'package:bloc/bloc.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:permission_handler/permission_handler.dart';
import '/authentication/bloc/auth_event.dart';
import '/authentication/bloc/auth_provider.dart';
import '/authentication/bloc/auth_state.dart';
import '/helpers/routes/routegenerator.dart';
import '/helpers/routes/routenames.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading(null)) {
    on<AuthEventInitialize>((event, emit) async {
      // print("Auth Bloc Event Initialized");
      // Check Notifications and Exit App
      if (await Permission.notification.isDenied) {
        print("Permission is denied");
        // Request Notification Access again
        PermissionStatus status = await Permission.notification.request();
        print("This is status $status");
        // await openAppSettings();
        // if (await Permission.notification.isDenied) {
        //   emit(const AuthStateNotificationError(null));
        // }
      }
      if (await Permission.notification.isPermanentlyDenied) {
        await openAppSettings().then((value) {
          print(value);
        });
        if (await Permission.notification.isPermanentlyDenied) {
          print("Permanently denied");
          emit(const AuthStateNotificationError(null));
        }
      }
      // if (await Permission.notification.isGranted) {
      print("isGranted");
      emit(const AuthStateLoading(null));
      await provider.initialize().then((value) async {
        // final fbuser = provider.currentUser;
        final user = provider.userData;

        print("Printing user in auth bloc initialization: \n$user");
        if (FirebaseAuth.instance.currentUser != null) {
          if (FirebaseAuth.instance.currentUser!.emailVerified) {
            emit(AuthStateLoggedIn(user));
          } else if (!FirebaseAuth.instance.currentUser!.emailVerified) {
            emit(AuthStateNeedsVerification(user));
          }
        } else {
          emit(const AuthStateLoggedOut(null));
        }
      });
      // }
    });

    on<AuthSelectStudentEvent>((event, emit) async {
      // RouteGenerator.navigatorKey.currentState!
      //     .pushNamed(studentLoginScreenRoute);
      emit(const AuthStateStudentLogin(null));
    });

    on<AuthSelectTeacherEvent>((event, emit) async {
      emit(const AuthStateTeacherLogin(null));
    });

    on<AuthStudentLoginEvent>(
      (event, emit) async {
        emit(const AuthStateLoading(null));

        try {
          await provider
              .studentLogin(email: event.email, password: event.password)
              .then((user) async {
            print(user);
            if (user != null) {
              if (FirebaseAuth.instance.currentUser!.emailVerified) {
                print("\nEmitting Logged in user!\n");
                emit(AuthStateLoggedIn(user));
              } else {
                emit(AuthStateNeedsVerification(user));
                // RouteGenerator.navigatorKey.currentState!
                //     .pushNamedAndRemoveUntil(verifyMailRoute, (route) => false);
              }
            } else {
              print("in else failure");
              emit(AuthStateStudentLoginFailure(
                  Exception("Unknown error occurred. Please try again later!"),
                  null));
            }
          });
        } catch (error) {
          print("Here");
          emit(AuthStateStudentLoginFailure(
              Exception("Unknown error occurred"), null));
        }
      },
    );

    on<AuthTeacherLoginEvent>(
      (event, emit) async {
        emit(const AuthStateLoading(null));

        try {
          print("Inside log in");
          await provider
              .teacherLogin(email: event.email, password: event.password)
              .then((user) async {
            // final user = provider.currentUser;
            print(user);
            if (user != null) {
              if (FirebaseAuth.instance.currentUser!.emailVerified) {
                print("\nEmitting Logged in user!\n");
                emit(AuthStateLoggedIn(user));
              } else {
                emit(AuthStateNeedsVerification(user));
                // RouteGenerator.navigatorKey.currentState!
                //     .pushNamedAndRemoveUntil(verifyMailRoute, (route) => false);
              }
            } else {
              print("in else failure");
              emit(AuthStateFacultyLoginFailure(
                  Exception("Unknown error occurred. Please try again later!"),
                  null));
            }
          });
        } catch (error) {
          print("Here");
          emit(AuthStateFacultyLoginFailure(
              Exception("Unknown error occurred"), null));
        }
      },
    );

    on<AuthStudentRegisterEvent>(
      (event, emit) async {
        emit(const AuthStateLoading(null));

        final user =
            await provider.registerStudentWithEmail(event.userData, event.file);
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
          // emit(AuthStateLoginFailure(Exception("Failed to login"), null));
        }
      },
    );
    on<AuthFacultyRegisterEvent>(
      (event, emit) async {
        emit(const AuthStateLoading(null));

        final user =
            await provider.registerFacultyWithEmail(event.userData, event.file);
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
          emit(
              AuthStateFacultyLoginFailure(Exception("Failed to login"), null));
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
        emit(AuthStateLoggedIn(provider.userData));
        // RouteGenerator.navigatorKey.currentState!
        //     .pushNamedAndRemoveUntil(chatHomeRoute, (route) => false);
        // add(const OnAuthNavigateAppEvent());
      } else {
        // Do nothing and stay on the same screen.
      }
    });

    on<ResendVerificationMail>((event, emit) async {
      print("Email sending");
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    });

    on<OnAuthNavigateAppEvent>(
      (event, emit) async {
        emit(const AuthStateLoading(null));
        await provider.initialize().then((value) {
          final user = provider.userData;

          print("Printing user in auth bloc initialization: \n$user");
          if (FirebaseAuth.instance.currentUser != null) {
            if (FirebaseAuth.instance.currentUser!.emailVerified) {
              emit(AuthStateLoggedIn(user));
            } else if (!FirebaseAuth.instance.currentUser!.emailVerified) {
              emit(AuthStateNeedsVerification(user));
            }
          } else {
            emit(const AuthStateLoggedOut(null));
          }
        });
      },
    );

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
