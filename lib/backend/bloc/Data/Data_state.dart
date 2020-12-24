import 'package:equatable/equatable.dart';

abstract class DataState extends Equatable {

  final List propss;
  DataState([this.propss]);

  @override
  List<Object> get props => (propss ?? []);
}

/// UnInitialized
class UnDataState extends DataState {

  UnDataState();

  @override
  String toString() => 'UnDataState';
}

/// Initialized
class InDataState extends DataState {
  final String hello;

  InDataState(this.hello) : super([hello]);

  @override
  String toString() => 'InDataState $hello';

}

class ErrorDataState extends DataState {
  final String errorMessage;

  ErrorDataState(this.errorMessage): super([errorMessage]);
  
  @override
  String toString() => 'ErrorDataState';
}
