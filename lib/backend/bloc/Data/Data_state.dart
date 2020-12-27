import 'package:equatable/equatable.dart';

abstract class DataState extends Equatable {
  final List propss;
  DataState([this.propss]);

  @override
  List<Object> get props => (propss ?? []);
}

/// UnInitialized
class UnDataState extends DataState {
  @override
  String toString() => 'FireBase Uninitialised';
}

/// Initialized
class InDataState extends DataState {
  InDataState() : super([]);

  @override
  String toString() => 'Firebase Initialised and working State';
}

/// Error
class ErrorDataState extends DataState {
  final String errorMessage;

  ErrorDataState(this.errorMessage) : super([errorMessage]);

  @override
  String toString() => 'ErrorDataState';
}
