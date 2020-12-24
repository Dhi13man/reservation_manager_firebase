import 'dart:async';
import 'dart:developer' as developer;

import 'package:restaurant_manage/backend/bloc/Data/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DataEvent {
  Stream<DataState> applyAsync({DataState currentState, DataBloc bloc});
}

class UnDataEvent extends DataEvent {
  @override
  Stream<DataState> applyAsync({DataState currentState, DataBloc bloc}) async* {
    yield UnDataState();
  }
}

class LoadDataEvent extends DataEvent {
  @override
  Stream<DataState> applyAsync({DataState currentState, DataBloc bloc}) async* {
    try {
      yield UnDataState();
      await Future.delayed(Duration(seconds: 1));
      yield InDataState('Hello world');
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadDataEvent', error: _, stackTrace: stackTrace);
      yield ErrorDataState(_?.toString());
    }
  }
}
