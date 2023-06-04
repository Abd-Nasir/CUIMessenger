import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cui_messenger/authentication/model/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '/authentication/bloc/auth_event.dart';
import '/authentication/bloc/auth_provider.dart';
import '/authentication/bloc/auth_state.dart';
import '/helpers/routes/routegenerator.dart';
import '/helpers/routes/routenames.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading(null)) {
    on<AuthEventInitialize>((event, emit) async {
      emit(const AuthStateLoading(null));
      await provider.initialize().then((value) async {
        // final fbuser = provider.currentUser;
        final user = provider.userData;

        if (FirebaseAuth.instance.currentUser != null) {
          if (FirebaseAuth.instance.currentUser!.emailVerified &&
              !user!.isRestricted) {
            print(user.isRestricted);
            final token = await FirebaseMessaging.instance.getToken();
            // print("token");
            FirebaseFirestore.instance
                .collection('registered-users')
                .doc(user.uid)
                .update({
              'token': token,
              // 'timestamp': FieldValue.serverTimestamp(),
            });
            emit(AuthStateLoggedIn(user));
          } else if (!FirebaseAuth.instance.currentUser!.emailVerified) {
            emit(AuthStateNeedsVerification(user));
          } else if (user!.isRestricted) {
            emit(AuthStateAccountRestricted(user));
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
            // print(user);
            if (user != null) {
              if (FirebaseAuth.instance.currentUser!.emailVerified &&
                  !user.isRestricted) {
                print("\nEmitting Logged in user!\n");
                final token = await FirebaseMessaging.instance.getToken();
                FirebaseFirestore.instance
                    .collection('registered-users')
                    .doc(user.uid)
                    .update({
                  'token': token,
                });
                emit(AuthStateLoggedIn(user));
              } else if (!FirebaseAuth.instance.currentUser!.emailVerified) {
                emit(AuthStateNeedsVerification(user));
                // RouteGenerator.navigatorKey.currentState!
                //     .pushNamedAndRemoveUntil(verifyMailRoute, (route) => false);
              } else if (user.isRestricted) {
                emit(AuthStateAccountRestricted(user));
              }
            } else {
              emit(AuthStateStudentLoginFailure(
                  Exception("Unknown error occurred. Please try again later!"),
                  null));
            }
          });
        } catch (error) {
          emit(AuthStateStudentLoginFailure(
              Exception("Unknown error occurred"), null));
        }
      },
    );

    on<AuthTeacherLoginEvent>(
      (event, emit) async {
        emit(const AuthStateLoading(null));

        try {
          await provider
              .teacherLogin(email: event.email, password: event.password)
              .then((user) async {
            // final user = provider.currentUser;

            if (user != null) {
              if (FirebaseAuth.instance.currentUser!.emailVerified) {
                emit(AuthStateLoggedIn(user));
              } else {
                emit(AuthStateNeedsVerification(user));
                // RouteGenerator.navigatorKey.currentState!
                //     .pushNamedAndRemoveUntil(verifyMailRoute, (route) => false);
              }
            } else {
              emit(AuthStateFacultyLoginFailure(
                  Exception("Unknown error occurred. Please try again later!"),
                  null));
            }
          });
        } catch (error) {
          emit(AuthStateFacultyLoginFailure(
              Exception("Unknown error occurred"), null));
        }
      },
    );

    on<AuthStudentRegisterEvent>(
      (event, emit) async {
        emit(const AuthStateLoading(null));

        final user = await provider.registerStudentWithEmail(
            event.userData, event.file, event.password);
        if (user != null) {
          if (FirebaseAuth.instance.currentUser!.emailVerified) {
            emit(AuthStateLoggedIn(user));
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

        final user = await provider.registerFacultyWithEmail(
            event.userData, event.file, event.password);
        if (user != null) {
          if (FirebaseAuth.instance.currentUser!.emailVerified) {
            emit(AuthStateLoggedIn(user));
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
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    });

    // on<OnAuthNavigateAppEvent>(
    //   (event, emit) async {
    //     emit(const AuthStateLoading(null));
    //     await provider.initialize().then((value) {
    //       final user = provider.userData;

    //       if (FirebaseAuth.instance.currentUser != null) {
    //         if (FirebaseAuth.instance.currentUser!.emailVerified) {
    //           emit(AuthStateLoggedIn(user));
    //         } else if (!FirebaseAuth.instance.currentUser!.emailVerified) {
    //           emit(AuthStateNeedsVerification(user));
    //         }
    //       } else {
    //         emit(const AuthStateLoggedOut(null));
    //       }
    //     });
    //   },
    // );

    on<AuthDeleteAccountEvent>((event, emit) async {
      print("in delete account");
      final userRef = FirebaseFirestore.instance
          .collection("registered-users")
          .doc(FirebaseAuth.instance.currentUser!.uid);
      userRef.get().then((user) {
        UserModel userModel = UserModel.fromJson(user.data()!);
        print(userModel.firstName);
        print(userModel.email);
        FirebaseStorage.instance.refFromURL(userModel.profilePicture).delete();
      });
      userRef.delete();
      // userRef.collection("chats").get().then((value) {
      //   value.docs.forEach((element) {
      //     element;
      //   });
      // });
      FirebaseAuth.instance.currentUser!.delete().then((_) {
        emit(const AuthStateLoggedOut(null));
      });
    });

    //update password
    on<UpdateUserPasswordEvent>(
      (event, emit) {
        provider.changePassword(event.oldPassword, event.updatedPassword);
      },
    );
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
