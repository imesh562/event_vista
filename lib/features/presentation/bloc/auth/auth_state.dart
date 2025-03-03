part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends BaseState<AuthState> {}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  AuthAuthenticated(this.user);
}

class AuthNeedsProfilePicture extends AuthState {
  final User user;

  AuthNeedsProfilePicture(this.user);
}

class AuthProfileIncomplete extends AuthState {
  final User user;

  AuthProfileIncomplete(this.user);
}

class ProfileLoaded extends AuthState {
  final User user;
  final Map<String, dynamic> userData;

  ProfileLoaded(this.user, this.userData);
}
