import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:restaurant_manage/backend/bloc/Data/Data_state.dart';
import 'package:restaurant_manage/backend/bloc/Login/Login_bloc.dart';
import 'package:restaurant_manage/backend/repos/data_classes.dart';

export 'package:restaurant_manage/backend/bloc/Data/Data_state.dart';

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
  }

  void initialise() async {
    await _firestore.enableNetwork();
    CollectionReference reservations = FirebaseFirestore.instance.collection(
      _collectionName,
    );
    emit(InDataState(collection: reservations));
  }

  Stream<DocumentSnapshot> documentStream() {
    if (_loginBloc.state is SignedInLoginState) {
      SignedInLoginState _loginState = _loginBloc.state;

      return FirebaseFirestore.instance
          .collection(_collectionName)
          .doc('${_loginState.credential.credential.token}_doc')
          .snapshots();
    }
    return Stream.empty();
  }

  Future<void> addReservation(Reservation reservation) async {
    if (_loginBloc.state is SignedInLoginState && state is InDataState) {
      InDataState _state = state;
      SignedInLoginState _loginState = _loginBloc.state;
      print('hi?');
      CollectionReference reference = _state.collection;
      await reference
          .doc('${_loginState.credential.credential.token}_doc')
          .set({'${reservation.dateTime}': reservationToMap(reservation)});
    }
  }

  Future<void> editReservation(Reservation reservation) async {
    if (_loginBloc.state is SignedInLoginState && state is InDataState) {
      InDataState _state = state;
      SignedInLoginState _loginState = _loginBloc.state;
      CollectionReference reference = _state.collection;
      await reference
          .doc('${_loginState.credential.credential.token}_doc')
          .update({'${reservation.dateTime}': reservationToMap(reservation)});
    }
  }

  Future<void> deleteReservation(Reservation reservation) async {
    if (_loginBloc.state is SignedInLoginState && state is InDataState) {
      InDataState _state = state;
      SignedInLoginState _loginState = _loginBloc.state;
      CollectionReference reference = _state.collection;
      await reference
          .doc('${_loginState.credential.credential.token}_doc')
          .update({'${reservation.dateTime}': FieldValue.delete()});
    }
  }

  /// Utilities
  Map<String, dynamic> reservationToMap(Reservation reservation) => {
        'name': reservation.name,
        'phone': reservation.phoneNum.toString(),
        'email': reservation.email,
        'datetime': reservation.dateTime,
      };

  Reservation mapToReservation(Map<String, dynamic> map) => Reservation(
        name: map['name'],
        phoneNum: int.parse(map['phone']),
        email: map['email'],
        dateTime: map['datetime'],
      );

  String reformatDate(String inDateString) {
    String _dateString = inDateString.replaceAll('/', '-');
    List<String> temp = _dateString.split(' ');
    temp[0] = temp[0].split('-').reversed.join('-');
    _dateString = temp.join(' ');
    return _dateString;
  }
}
