import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final String selectedCriteriaButtonText;
  final bool isAscending;
  static const String sortedByName = 'Name';
  static const String sortedByReservationTime = 'Reservation Time';
  static const String sortedByMail = 'E-Mail';

  InDataState({
    @required this.collection,
    String criteria = 'Name',
    this.isAscending = true,
  })  : selectedCriteriaButtonText = criteria,
        super([collection, criteria, isAscending]) {
    saveSortingPreferences();
  }

  void saveSortingPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('criteria', selectedCriteriaButtonText);
    await prefs.setBool('isAscending', isAscending);
  }

  /// Default filter is ['name']
  String get criteria {
    if (selectedCriteriaButtonText
            .compareTo(InDataState.sortedByReservationTime) ==
        0) return 'datetime';
    if (selectedCriteriaButtonText.compareTo(InDataState.sortedByMail) == 0)
      return 'email';
    return 'name';
  }

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
