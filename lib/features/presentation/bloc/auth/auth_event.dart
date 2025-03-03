part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends BaseEvent {}

class SignUpWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  SignUpWithEmailEvent({
    required this.email,
    required this.password,
  });
}

class SignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  SignInWithEmailEvent({
    required this.email,
    required this.password,
  });
}

class SignOutEvent extends AuthEvent {}

class UploadProfilePictureEvent extends AuthEvent {
  final File imageFile;

  UploadProfilePictureEvent({
    required this.imageFile,
  });
}

class UpdateUserProfileEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String mailingAddress;

  UpdateUserProfileEvent({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.mailingAddress,
  });
}

class FetchUserProfileEvent extends AuthEvent {}
