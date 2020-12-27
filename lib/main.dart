import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import 'package:restaurant_manage/backend/bloc/Data/Data_bloc.dart';
import 'package:restaurant_manage/backend/bloc/Login/Login_bloc.dart';
import 'package:restaurant_manage/backend/constants.dart';
import 'package:restaurant_manage/backend/repos/authentication.dart';

import 'package:restaurant_manage/screens/add_screen.dart';
import 'package:restaurant_manage/screens/login_screen.dart';
import 'package:restaurant_manage/screens/reservation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppConstants>(
            create: (context) => AppConstants()),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
            authenticationRepository: AuthenticationRepository(),
          ),
        ),
        BlocProvider<DataBloc>(
          create: (context) => DataBloc(
            initialState: UnDataState(),
            loginBloc: context.read<LoginBloc>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Restaurant Manager',
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        home: HotelAppLoginScreen(title: 'Restaurant Manager'),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return PageTransition(
                child: Builder(
                  builder: (context) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider<AppConstants>.value(
                        value: context.watch<AppConstants>(),
                      ),
                      BlocProvider<LoginBloc>.value(
                        value: context.read<LoginBloc>(),
                      )
                    ],
                    child: HotelAppLoginScreen(title: 'Restaurant Manager'),
                  ),
                ),
                type: PageTransitionType.fade,
                settings: settings,
              );
              break;

            case '/add':
              return PageTransition(
                child: Builder(
                  builder: (context) {
                    DataBloc dataBloc = context.read<DataBloc>();
                    return MultiProvider(
                      providers: [
                        ChangeNotifierProvider<AppConstants>.value(
                          value: context.watch<AppConstants>(),
                        ),
                        BlocProvider<DataBloc>.value(value: dataBloc)
                      ],
                      child: AddReservationScreen(),
                    );
                  },
                ),
                type: PageTransitionType.rightToLeftWithFade,
                settings: settings,
              );
              break;

            case '/reservelist':
              return PageTransition(
                child: Builder(builder: (context) {
                  DataBloc dataBloc = context.read<DataBloc>();
                  return MultiProvider(
                    providers: [
                      ChangeNotifierProvider<AppConstants>.value(
                        value: context.watch<AppConstants>(),
                      ),
                      BlocProvider<DataBloc>.value(value: dataBloc)
                    ],
                    child: ReservationListScreen(),
                  );
                }),
                type: PageTransitionType.bottomToTop,
                settings: settings,
              );
              break;

            default:
              return null;
          }
        },
      ),
    );
  }
}
