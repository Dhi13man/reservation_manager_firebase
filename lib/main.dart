import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:restaurant_manage/backend/constants.dart';

import 'package:restaurant_manage/screens/add_screen.dart';
import 'package:restaurant_manage/screens/login_screen.dart';
import 'package:restaurant_manage/screens/reservation_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppConstants>(
          create: (context) => AppConstants(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
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
                  builder: (context) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider<AppConstants>.value(
                        value: context.watch<AppConstants>(),
                      ),
                    ],
                    child: AddReservationScreen(),
                  ),
                ),
                type: PageTransitionType.rightToLeftWithFade,
                settings: settings,
              );
              break;

            case '/reservelist':
              return PageTransition(
                child: Builder(
                  builder: (context) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider<AppConstants>.value(
                        value: context.watch<AppConstants>(),
                      ),
                    ],
                    child: ReservationListScreen(),
                  ),
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
