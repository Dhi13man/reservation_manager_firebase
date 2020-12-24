import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:restaurant_manage/backend/bloc/Data/index.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc(DataState initialState) : super(initialState);

  @override
  Stream<DataState> mapEventToState(DataEvent event) async* {
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'DataBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
