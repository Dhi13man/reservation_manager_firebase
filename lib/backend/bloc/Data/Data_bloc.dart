import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:reservation_manager/backend/bloc/Data/Data_state.dart';
import 'package:reservation_manager/backend/bloc/Login/Login_bloc.dart';
import 'package:reservation_manager/backend/repos/data_classes.dart';

export 'package:reservation_manager/backend/bloc/Data/Data_state.dart';

class DataBloc extends Cubit<DataState> {
  final FirebaseFirestore _firestore;
  final LoginBloc _loginBloc;
  final String _collectionName = 'reservations';

  DataBloc({
    FirebaseFirestore firestore,
    DataState initialState,
    @required LoginBloc loginBloc,
  })  : _firestore = firestore ?? (kIsWeb)
            ? FirebaseFirestore.instance.enablePersistence()
            : FirebaseFirestore.instance,
        _loginBloc = loginBloc,
        super(initialState ?? UnDataState()) {
    _firestore.settings = Settings(persistenceEnabled: false);
    _initialise();
  }

  /// Token to give each user different session
  String get docToken {
    if (_loginBloc.state is SignedInLoginState) {
      SignedInLoginState _loginState = _loginBloc.state;

      return _loginState.credential.user.uid.toString();
    } else
      return 'default_doc';
  }

  void _initialise() async {
    await _firestore.enableNetwork();
    CollectionReference reservations = FirebaseFirestore.instance.collection(
      _collectionName,
    );

    // Check if user has preffered saved Sorting Preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedCriteria = prefs.getString('criteria');
    bool savedOrder = prefs.getBool('isAscending');

    emit(InDataState(
      collection: reservations,
      criteria: savedCriteria ?? 'Name',
      isAscending: savedOrder ?? true,
    ));
  }

  /// Stream from Firestore
  Stream<DocumentSnapshot> documentStream() {
    if (_loginBloc.state is SignedInLoginState && state is InDataState) {
      InDataState _state = state;
      return _state.collection.doc('${docToken}_doc').snapshots();
    } else {
      _initialise();
      return Stream.empty();
    }
  }

  /// Get from Firestore
  Future<DocumentSnapshot> documentCheck() {
    if (_loginBloc.state is SignedInLoginState && state is InDataState) {
      InDataState _state = state;
      return _state.collection.doc('${docToken}_doc').get();
    } else {
      _initialise();
      return Future.value();
    }
  }

  /// To implement sorted Reservation List Building.
  ///  [filter] specifies what property to sort with from ['Name', 'Reservation Time', 'E-Mail']
  /// List wil be in ascending order if [isAscending] is true
  void rebuildReservationsStream({String filter, bool isAscending}) {
    if (state is InDataState) {
      InDataState _state = state;
      emit(
        InDataState(
          collection: _state.collection,
          criteria: filter ?? _state.criteria,
          isAscending: isAscending ?? _state.isAscending,
        ),
      );
    } else
      _initialise();
  }

  Future<bool> _isReservationTaken(String reservationKey) async {
    DocumentSnapshot snap = await documentCheck();
    Map<String, dynamic> currentData = snap.data();
    return (currentData == null)
        ? false
        : currentData.containsKey(reservationKey);
  }

  Future<bool> addReservation(Reservation reservation) async {
    if (_loginBloc.state is SignedInLoginState && state is InDataState) {
      InDataState _state = state;
      DocumentReference reference = _state.collection.doc('${docToken}_doc');
      String reservationKey =
          reservation.dateTime.millisecondsSinceEpoch.toString();

      if (await _isReservationTaken(reservationKey)) {
        InDataState _state = state;
        emit(ReservationExistsErrorDataState(bookedTime: reservation.dateTime));
        emit(_state);
        return false;
      }

      await reference.set(
        {reservationKey: reservationToMap(reservation)},
        SetOptions(merge: true),
      );
      return true;
    } else {
      _loginBloc.emit(SignedOutLoginState());
      return false;
    }
  }

  Future<void> editReservation(Reservation reservation) async {
    if (_loginBloc.state is SignedInLoginState && state is InDataState) {
      InDataState _state = state;
      CollectionReference reference = _state.collection;
      await reference.doc('${docToken}_doc').update(
        {
          '${reservation.dateTime.millisecondsSinceEpoch}':
              reservationToMap(reservation)
        },
      );
    } else
      _loginBloc.emit(SignedOutLoginState());
  }

  Future<void> deleteReservation(Reservation reservation) async {
    if (_loginBloc.state is SignedInLoginState && state is InDataState) {
      InDataState _state = state;
      CollectionReference reference = _state.collection;
      await reference.doc('${docToken}_doc').update({
        '${reservation.dateTime.millisecondsSinceEpoch}': FieldValue.delete()
      });
    } else
      _loginBloc.emit(SignedOutLoginState());
  }

  /// Utilities

  /// Extracts Database from Firestore and converts it to a list of [Reservation]
  List<Reservation> extractDataFromFirebase(
      Map<dynamic, dynamic> firebaseData) {
    List<Reservation> outputReservationsList = [];
    firebaseData?.forEach(
      (key, value) => outputReservationsList.add(
        mapToReservation(value),
      ),
    );
    outputReservationsList.sort((Reservation a, Reservation b) {
      if (state is InDataState) {
        InDataState _state = state;
        String _criteria = _state.criteria;
        int isAscending = (_state.isAscending) ? 1 : -1;
        if (_criteria == 'name') return isAscending * a.name.compareTo(b.name);
        if (_criteria == 'email')
          return isAscending * a.email.compareTo(b.email);
        if (_criteria == 'datetime')
          return isAscending * a.dateTime.compareTo(b.dateTime);
      }
      return 0;
    });
    return outputReservationsList;
  }

  /// Extracts a Map of values from a Reservation Class
  Map<String, dynamic> reservationToMap(Reservation reservation) => {
        'name': reservation.name,
        'phone': reservation.phoneNum.toString(),
        'email': reservation.email,
        'datetime': reservation.dateTime,
      };

  /// Extracts a Reservation Class from a Firebase Map of values
  Reservation mapToReservation(Map<String, dynamic> map) {
    try {
      return Reservation(
        name: map['name'],
        phoneNum: int.parse(map['phone']),
        email: map['email'],
        dateTime: timestampToDatetime(map['datetime']),
      );
    } catch (e) {
      return Reservation.empty;
    }
  }

  /// Reformat Date String to enable parsing
  /// from mm/dd/yyyy HH:MM:SS to yyyy-dd-mmmm HH:MM:SS
  String reformatDate(String inDateString) {
    String _dateString = inDateString.replaceAll('/', '-');
    List<String> dateTimeTemp = _dateString.split(' ');
    List<String> dateTemp = dateTimeTemp[0].split('-');

    // 0 padding if needed
    for (int i = 0; i < dateTemp.length; i++) {
      String element = dateTemp[i];
      if (element.length == 1) dateTemp[i] = '0$element';
    }

    // Swap Month and day
    String temp = dateTemp[0];
    dateTemp[0] = dateTemp[1];
    dateTemp[1] = temp;

    dateTimeTemp[0] = dateTemp.reversed.join('-');
    _dateString = dateTimeTemp.join(' ');
    return _dateString;
  }

  String dateTimeToString(DateTime dateTime) =>
      dateTime.toIso8601String().replaceAll('T', ' Time: ');

  DateTime timestampToDatetime(Timestamp inputTimestamp) =>
      inputTimestamp.toDate();
}
