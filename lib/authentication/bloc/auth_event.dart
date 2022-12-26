import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthMailLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthMailLoginEvent({
    required this.email,
    required this.password,
  });
}

class AuthMailRegisterEvent extends AuthEvent {
  final Map<String, dynamic> userData;
  final XFile file;
  const AuthMailRegisterEvent({required this.userData, required this.file});
}

class AuthPhoneLoginEvent extends AuthEvent {
  final String phone;
  const AuthPhoneLoginEvent({required this.phone});
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

class OnAuthNavigateAppEvent extends AuthEvent {
  const OnAuthNavigateAppEvent();
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
