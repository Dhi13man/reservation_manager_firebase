import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:restaurant_manage/backend/bloc/Data/Data_bloc.dart';
import 'package:restaurant_manage/backend/bloc/Login/Login_bloc.dart';
import 'package:restaurant_manage/backend/constants.dart';
import 'package:restaurant_manage/screens/add_screen.dart';

import 'package:restaurant_manage/screens/login_screen.dart';

class ReservationList extends StatelessWidget {
  const ReservationList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataBloc _dataBloc = context.watch<DataBloc>();

    return Container(
      child: StreamBuilder(
          stream: _dataBloc.documentStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            DocumentSnapshot docSnap = snapshot.data;
            print(docSnap.data());
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('hi'),
                );
              },
            );
          }),
    );
  }
}

class ReservationListScreen extends StatelessWidget {
  static const routeName = '/reservelist';
  ReservationListScreen({Key key, String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppConstants _appConstants = context.watch<AppConstants>();
    DataBloc _dataBloc = context.watch<DataBloc>();

    return Scaffold(
      backgroundColor: _appConstants.getBackGroundColor,
      body: BlocListener<LoginBloc, LoginState>(
        cubit: BlocProvider.of<LoginBloc>(context),
        listener: (context, state) {
          if (state is SignedOutLoginState) {
            Navigator.of(context).pushReplacementNamed(
              LoginScreen.routeName,
            );
          }
        },
        child: Container(
          margin: EdgeInsets.all(10),
          child: ReservationList(),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () => Navigator.of(context).pushNamed(
          AddReservationScreen.routeName,
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
              _appConstants.getForeGroundColor),
        ),
        child: Icon(
          Icons.my_library_add,
          color: _appConstants.getBackGroundColor,
          size: 40,
        ),
      ),
    );
  }
}
