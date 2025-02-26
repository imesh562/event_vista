part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends BaseState<AuthState> {}

class AuthInitial extends AuthState {}
