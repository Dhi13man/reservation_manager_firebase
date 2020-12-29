import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final CollectionReference collection;

  InDataState({
    @required this.collection,
  }) : super([collection]);

  @override
  String toString() => 'Firebase Initialised and working State';
}

/// Error
abstract class ErrorDataState extends DataState {
  final String errorMessage;

  ErrorDataState(this.errorMessage) : super([errorMessage]);

  @override
  String toString() => 'ErrorDataState';
}

class ReservationExistsErrorDataState extends DataState {
  final String errorMessage;
  final DateTime bookedTime;

  ReservationExistsErrorDataState({
    this.errorMessage,
    @required this.bookedTime,
  }) : super([errorMessage]);

  @override
  String toString() =>
      'Appointment at ${bookedTime.toIso8601String().replaceAll('T', ' Time: ')} already exists!';
}
