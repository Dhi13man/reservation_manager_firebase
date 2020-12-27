import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:restaurant_manage/backend/bloc/Data/Data_state.dart';
import 'package:restaurant_manage/backend/bloc/Login/Login_bloc.dart';

export 'package:restaurant_manage/backend/bloc/Data/Data_state.dart';

class DataBloc extends Cubit<DataState> {
  final FirebaseFirestore _firestore;
  final LoginBloc _loginBloc;

  DataBloc({
    FirebaseFirestore firestore,
    DataState initialState,
    @required LoginBloc loginBloc,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _loginBloc = loginBloc,
        super(initialState ?? UnDataState());
}
