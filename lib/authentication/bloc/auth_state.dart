import 'package:cui_messenger/authentication/model/user.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import '/authentication/model/user.dart';

class AuthState extends Equatable {
  final UserData? user;

  const AuthState(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading(UserData? user) : super(user);
}

class AuthStateStudentLogin extends AuthState {
  const AuthStateStudentLogin(UserData? user) : super(user);
}

class AuthStateTeacherLogin extends AuthState {
  const AuthStateTeacherLogin(UserData? user) : super(user);
}

class AuthStateLoggedIn extends AuthState {
  const AuthStateLoggedIn(UserData? user) : super(user);
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut(UserData? user) : super(user);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification(UserData? user) : super(user);
}

class AuthStateStudentLoginFailure extends AuthState {
  final Exception exception;
  const AuthStateStudentLoginFailure(this.exception, UserData? user)
      : super(user);
}

class AuthStateFacultyLoginFailure extends AuthState {
  final Exception exception;
  const AuthStateFacultyLoginFailure(this.exception, UserData? user)
      : super(user);
}

class AuthStateLogOutFailure extends AuthState {
  final Exception exception;
  const AuthStateLogOutFailure(this.exception, UserData? user) : super(user);
}

class AuthStateNotificationError extends AuthState {
  const AuthStateNotificationError(UserData? user) : super(user);
}

class AuthStateLocationError extends AuthState {
  const AuthStateLocationError(UserData? user) : super(user);
}
