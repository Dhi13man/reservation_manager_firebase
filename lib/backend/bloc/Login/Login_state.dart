import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:reservation_manage/backend/repos/data_classes.dart' as data;

abstract class LoginState extends Equatable {
  final List propss;
  LoginState([this.propss]);

  @override
  List<Object> get props => (propss ?? []);
}

/// UnInitialized
class UnLoginState extends LoginState {
  UnLoginState();

  @override
  String toString() => 'UnLoginState';
}

class LoadingLoginState extends LoginState {
  final data.User user;

  LoadingLoginState({this.user}) : super([user]);

  @override
  String toString() => (user == null)
      ? 'Loading Google Account State'
      : 'Loading Account with Email: ${user.email}';
}

/// Initialized
class SignedOutLoginState extends LoginState {
  SignedOutLoginState() : super([]);

  @override
  String toString() => 'Signed out State';
}

class SignedInLoginState extends LoginState {
  final data.User user;
  final UserCredential credential;

  SignedInLoginState({this.user, this.credential}) : super([credential]);

  @override
  String toString() => (user == null)
      ? 'Signed in with Google State'
      : 'Signed in State. Email: ${user.email}';
}

/// Error
class ErrorLoginState extends LoginState {
  final String errorMessage;

  ErrorLoginState(this.errorMessage) : super([errorMessage]);

  @override
  String toString() => 'ErrorLoginState';
}
