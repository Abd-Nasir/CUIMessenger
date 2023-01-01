import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import '/authentication/model/user.dart';

class AuthState extends Equatable {
  final User? user;
  const AuthState(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading(User? user) : super(user);
}

class AuthStateStudentLogin extends AuthState {
  const AuthStateStudentLogin(User? user) : super(user);
}

class AuthStateTeacherLogin extends AuthState {
  const AuthStateTeacherLogin(User? user) : super(user);
}

class AuthStateLoggedIn extends AuthState {
  const AuthStateLoggedIn(User? user) : super(user);
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut(User? user) : super(user);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification(User? user) : super(user);
}

class AuthStateStudentLoginFailure extends AuthState {
  final Exception exception;
  const AuthStateStudentLoginFailure(this.exception, User? user) : super(user);
}

class AuthStateFacultyLoginFailure extends AuthState {
  final Exception exception;
  const AuthStateFacultyLoginFailure(this.exception, User? user) : super(user);
}

class AuthStateLogOutFailure extends AuthState {
  final Exception exception;
  const AuthStateLogOutFailure(this.exception, User? user) : super(user);
}

class AuthStateNotificationError extends AuthState {
  const AuthStateNotificationError(User? user) : super(user);
}

class AuthStateLocationError extends AuthState {
  const AuthStateLocationError(User? user) : super(user);
}
