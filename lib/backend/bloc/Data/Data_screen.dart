import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:restaurant_manage/backend/bloc/Data/index.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({
    Key key,
    @required DataBloc dataBloc,
  })  : _dataBloc = dataBloc,
        super(key: key);

  final DataBloc _dataBloc;

  @override
  DataScreenState createState() {
    return DataScreenState();
  }
}

class DataScreenState extends State<DataScreen> {
  DataScreenState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataBloc, DataState>(
        cubit: widget._dataBloc,
        builder: (BuildContext context, DataState currentState) {
          if (currentState is UnDataState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorDataState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage ?? 'Error'),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text('reload'),
                    onPressed: _load,
                  ),
                ),
              ],
            ));
          }
          if (currentState is InDataState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(currentState.hello),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void _load() {
    widget._dataBloc.add(LoadDataEvent());
  }
}
