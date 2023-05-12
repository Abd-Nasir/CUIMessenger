import 'package:cui_messenger/authentication/model/user_model.dart';
import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final UserModel? user;

  const AuthState(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading(UserModel? user) : super(user);
}

class AuthStateStudentLogin extends AuthState {
  const AuthStateStudentLogin(UserModel? user) : super(user);
}

class AuthStateTeacherLogin extends AuthState {
  const AuthStateTeacherLogin(UserModel? user) : super(user);
}

class AuthStateLoggedIn extends AuthState {
  const AuthStateLoggedIn(UserModel? user) : super(user);
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut(UserModel? user) : super(user);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification(UserModel? user) : super(user);
}

class AuthStateStudentLoginFailure extends AuthState {
  final Exception exception;
  const AuthStateStudentLoginFailure(this.exception, UserModel? user)
      : super(user);
}

class AuthStateFacultyLoginFailure extends AuthState {
  final Exception exception;
  const AuthStateFacultyLoginFailure(this.exception, UserModel? user)
      : super(user);
}

class AuthStateLogOutFailure extends AuthState {
  final Exception exception;
  const AuthStateLogOutFailure(this.exception, UserModel? user) : super(user);
}

class AuthStateNotificationError extends AuthState {
  const AuthStateNotificationError(UserModel? user) : super(user);
}

class AuthStateLocationError extends AuthState {
  const AuthStateLocationError(UserModel? user) : super(user);
}
