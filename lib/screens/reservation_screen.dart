import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_manage/backend/bloc/Data/Data_bloc.dart';
import 'package:reservation_manage/backend/bloc/Login/Login_bloc.dart';
import 'package:reservation_manage/backend/constants.dart';
import 'package:reservation_manage/backend/repos/data_classes.dart';

import 'package:reservation_manage/screens/add_screen.dart';
import 'package:reservation_manage/screens/login_screen.dart';
import 'package:reservation_manage/screens/splash_screen.dart';

class ReservationListItem extends StatelessWidget {
  const ReservationListItem({
    Key key,
    @required this.reservation,
  }) : super(key: key);

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    AppConstants appConstants = context.watch<AppConstants>();
    DataBloc dataBloc = context.watch<DataBloc>();
    return Card(
      elevation: 10,
      shadowColor: appConstants.getLighterForeGroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: appConstants.getForeGroundColor),
        ),
        child: ListTile(
          onTap: () => Navigator.of(context).pushNamed(
            AddReservationScreen.routeName,
            arguments: reservation,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            reservation?.name ?? 'error',
            style: TextStyle(
              color: appConstants.getForeGroundColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reservation: ${dataBloc.dateTimeToString(reservation.dateTime)}',
                style: TextStyle(
                  color: appConstants.getForeGroundColor,
                  fontSize: 10,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  'Contact: ${reservation.phoneNum.toString()}' +
                      ((reservation.email != null &&
                              reservation.email.isNotEmpty)
                          ? ', ' + reservation.email.toString()
                          : ''),
                  style: TextStyle(
                    color: appConstants.getForeGroundColor,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          isThreeLine: true,
          trailing: IconButton(
            icon: Icon(Icons.delete, color: appConstants.getForeGroundColor),
            onPressed: () => dataBloc.deleteReservation(reservation),
          ),
          tileColor: appConstants.getBackGroundColor,
        ),
      ),
    );
  }
}

class ReservationList extends StatelessWidget {
  const ReservationList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataBloc _dataBloc = context.watch<DataBloc>();
    AppConstants _appConstants = context.watch<AppConstants>();

    return Container(
      child: StreamBuilder(
        stream: _dataBloc.documentStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          DocumentSnapshot docSnap = snapshot.data;
          List<Reservation> reservations =
              _dataBloc.extractDataFromFirebase(docSnap.data());
          if (reservations.isEmpty)
            return Center(
                child: Text(
              'No Reservations added yet!',
              style: TextStyle(
                fontSize: 18,
                color: _appConstants.getForeGroundColor,
              ),
            ));

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              return ReservationListItem(
                reservation: reservations[index] ?? Reservation.empty,
              );
            },
          );
        },
      ),
    );
  }
}

class ReservationListScreen extends StatelessWidget {
  static const routeName = '/reservelist';
  ReservationListScreen({Key key, String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppConstants _appConstants = context.watch<AppConstants>();
    LoginBloc _loginBloc = context.watch<LoginBloc>();

    return Scaffold(
      backgroundColor: _appConstants.getBackGroundColor,
      appBar: AppBar(
        title: Text(
          'Reservations',
          style: TextStyle(color: _appConstants.getBackGroundColor),
        ),
        backgroundColor: _appConstants.getForeGroundColor,
        centerTitle: true,
        leading: AppHeroIcon(
          appConstants: _appConstants,
          iconSize: 20.0,
          margin: EdgeInsets.symmetric(horizontal: 5),
          padding: EdgeInsets.all(8),
          backgroundColor: _appConstants.getBackGroundColor.withOpacity(0.7),
          foregroundColor: _appConstants.getForeGroundColor,
        ),
        actions: [
          TextButton(
            onPressed: () => _loginBloc.signOut(),
            child: Text(
              'Log out',
              style: TextStyle(color: _appConstants.getBackGroundColor),
            ),
          )
        ],
        elevation: 1,
        shadowColor: _appConstants.getLighterForeGroundColor,
      ),
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
