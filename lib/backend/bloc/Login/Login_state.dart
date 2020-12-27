import 'package:equatable/equatable.dart';

import 'package:restaurant_manage/backend/repos/data_classes.dart';

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

/// Initialized
class SignedOutLoginState extends LoginState {
  final String hello;

  SignedOutLoginState(this.hello) : super([hello]);

  @override
  String toString() => 'Signed out State';
}

class SignedInLoginState extends LoginState {
  final User user;

  SignedInLoginState({this.user}) : super([user]);

  @override
  String toString() => 'Signed in user ${user.name} State';
}

/// Error
class ErrorLoginState extends LoginState {
  final String errorMessage;

  ErrorLoginState(this.errorMessage) : super([errorMessage]);

  @override
  String toString() => 'ErrorLoginState';
}
