import 'package:flutter/material.dart';

import 'package:restaurant_manage/backend/bloc/Data/Data_bloc.dart';
import 'package:restaurant_manage/backend/bloc/Data/Data_screen.dart';
import 'package:restaurant_manage/backend/bloc/Data/Data_state.dart';

class DataPage extends StatefulWidget {
  static const String routeName = '/data';

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  final DataBloc _dataBloc = DataBloc(UnDataState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data'),
      ),
      body: DataScreen(dataBloc: _dataBloc),
    );
  }

  @override
  void dispose() {
    _dataBloc.close();
    super.dispose();
  }
}
