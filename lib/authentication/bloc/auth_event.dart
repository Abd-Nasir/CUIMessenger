import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
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
  final Map<String, dynamic> userData;
  final XFile file;
  const AuthStudentRegisterEvent({required this.userData, required this.file});
}

class AuthFacultyRegisterEvent extends AuthEvent {
  final Map<String, dynamic> userData;
  final XFile file;
  const AuthFacultyRegisterEvent({required this.userData, required this.file});
}

class AuthPhoneVerifyEvent extends AuthEvent {
  final String code;
  const AuthPhoneVerifyEvent({required this.code});
}

class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();
}

class AuthForgotPasswordSendOTPEvent extends AuthEvent {
  final String phone;
  const AuthForgotPasswordSendOTPEvent({required this.phone});
}

class AuthForgotPasswordVerifyOTPEvent extends AuthEvent {
  final String code;
  const AuthForgotPasswordVerifyOTPEvent({required this.code});
}

class AuthForgotPasswordEvent extends AuthEvent {
  final String email;
  const AuthForgotPasswordEvent({required this.email});
}

class UpdateUserPasswordEvent extends AuthEvent {
  final String password;
  const UpdateUserPasswordEvent({required this.password});
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

class AuthUpdateUserDataEvent extends AuthEvent {
  final Map<String, dynamic> dataChanged;
  final XFile? file;
  final String? oldImageKey;
  final String userid;

  const AuthUpdateUserDataEvent(
      {required this.userid,
      required this.dataChanged,
      required this.file,
      required this.oldImageKey});
}

class AuthDeleteAccountEvent extends AuthEvent {
  final String email;
  const AuthDeleteAccountEvent({required this.email});
}

class AuthUpdateCacheEvent extends AuthEvent {
  const AuthUpdateCacheEvent();
}

class CheckEmailVerified extends AuthEvent {
  const CheckEmailVerified();
}

class ResendVerificationMail extends AuthEvent {
  const ResendVerificationMail();
}
