import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import 'package:restaurant_manage/backend/bloc/Data/Data_bloc.dart';
import 'package:restaurant_manage/backend/bloc/Login/Login_bloc.dart';
import 'package:restaurant_manage/backend/constants.dart';
import 'package:restaurant_manage/backend/repos/authentication.dart';

import 'package:restaurant_manage/screens/splash_screen.dart';
import 'package:restaurant_manage/screens/login_screen.dart';
import 'package:restaurant_manage/screens/reservation_screen.dart';
import 'package:restaurant_manage/screens/add_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppConstants _appConstants = AppConstants();

  runApp(
    ChangeNotifierProvider<AppConstants>.value(
      value: _appConstants,
      builder: (context, child) => ReservationApp(),
    ),
  );
}

class ReservationApp extends StatelessWidget {
  final String _appTitle = 'Restaurant Manager';

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
            authenticationRepository: AuthenticationRepository(),
          ),
        ),
        BlocProvider<DataBloc>(
          create: (context) => DataBloc(
            initialState: UnDataState(),
            loginBloc: BlocProvider.of<LoginBloc>(context),
          ),
        ),
      ],
      child: MaterialApp(
        title: _appTitle,
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case SplashScreen.routeName:
              return PageTransition(
                child: Builder(
                  builder: (context) =>
                      ChangeNotifierProvider<AppConstants>.value(
                    value: context.watch<AppConstants>(),
                    child: SplashScreen(),
                  ),
                ),
                type: PageTransitionType.fade,
                settings: settings,
              );
              break;

            case LoginScreen.routeName:
              return PageTransition(
                child: Builder(
                  builder: (context) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider<AppConstants>.value(
                        value: context.watch<AppConstants>(),
                      ),
                      BlocProvider<LoginBloc>.value(
                        value: context.watch<LoginBloc>(),
                      )
                    ],
                    child: LoginScreen(title: _appTitle),
                  ),
                ),
                type: PageTransitionType.fade,
                duration: Duration(seconds: 2, milliseconds: 500),
                settings: settings,
              );
              break;

            case AddReservationScreen.routeName:
              return PageTransition(
                child: Builder(
                  builder: (context) {
                    return MultiProvider(
                      providers: [
                        ChangeNotifierProvider<AppConstants>.value(
                          value: context.watch<AppConstants>(),
                        ),
                        BlocProvider<DataBloc>.value(
                          value: context.watch<DataBloc>(),
                        )
                      ],
                      child: AddReservationScreen(),
                    );
                  },
                ),
                type: PageTransitionType.rightToLeftWithFade,
                settings: settings,
              );
              break;

            case ReservationListScreen.routeName:
              return PageTransition(
                child: Builder(
                  builder: (context) {
                    return MultiProvider(
                      providers: [
                        ChangeNotifierProvider<AppConstants>.value(
                          value: context.watch<AppConstants>(),
                        ),
                        BlocProvider<DataBloc>.value(
                          value: context.watch<DataBloc>(),
                        )
                      ],
                      child: ReservationListScreen(),
                    );
                  },
                ),
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
