import 'package:cui_messenger/authentication/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class OnAuthNavigateAppEvent extends AuthEvent {
  const OnAuthNavigateAppEvent();
}

class AuthSelectStudentEvent extends AuthEvent {
  const AuthSelectStudentEvent();
}

class AuthSelectTeacherEvent extends AuthEvent {
  const AuthSelectTeacherEvent();
}

class AuthTeacherLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthTeacherLoginEvent({
    required this.email,
    required this.password,
  });
}

class AuthStudentLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthStudentLoginEvent({
    required this.email,
    required this.password,
  });
}

class AuthStudentRegisterEvent extends AuthEvent {
  final UserModel userData;
  final XFile file;
  final String password;
  const AuthStudentRegisterEvent(
      {required this.userData, required this.file, required this.password});
}

class AuthFacultyRegisterEvent extends AuthEvent {
  final UserModel userData;
  final String password;
  final XFile file;
  const AuthFacultyRegisterEvent(
      {required this.userData, required this.file, required this.password});
}

class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();
}

class UpdateUserPasswordEvent extends AuthEvent {
  final String oldPassword;
  final String updatedPassword;
  const UpdateUserPasswordEvent(
      {required this.oldPassword, required this.updatedPassword});
}

class AuthLoggedInAndPaid extends AuthEvent {
  const AuthLoggedInAndPaid();
}

class AuthUploadUserProfilePictureEvent extends AuthEvent {
  final String userID;
  final XFile file;
  const AuthUploadUserProfilePictureEvent(
      {required this.file, required this.userID});
}

class AuthDeleteAccountEvent extends AuthEvent {
  final String email;
  final String password;
  const AuthDeleteAccountEvent({required this.email, required this.password});
}

class CheckEmailVerified extends AuthEvent {
  const CheckEmailVerified();
}

class ResendVerificationMail extends AuthEvent {
  const ResendVerificationMail();
}

class AuthUpdateUserDataEvent extends AuthEvent {
  final String oldImageUrl;
  final XFile? file;
  final String uId;
  final String phoneNo;
  const AuthUpdateUserDataEvent(
      {required this.phoneNo,
      required this.file,
      required this.oldImageUrl,
      required this.uId});
}
