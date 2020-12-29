import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:reservation_manage/backend/constants.dart';

import 'package:reservation_manage/screens/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  static const routeName = '/';
  @override
  Widget build(BuildContext context) {
    AppConstants _appConstants = context.watch<AppConstants>();
    Firebase.initializeApp().then(
      (value) => Navigator.pushReplacementNamed(context, LoginScreen.routeName),
    );

    return Scaffold(
      backgroundColor: _appConstants.getBackGroundColor,
      body: Center(
        child: AppHeroIcon(appConstants: _appConstants),
      ),
    );
  }
}

class AppHeroIcon extends StatelessWidget {
  const AppHeroIcon({
    Key key,
    num iconSize,
    EdgeInsets margin,
    EdgeInsets padding,
    this.backgroundColor,
    this.foregroundColor,
    @required AppConstants appConstants,
  })  : _appConstants = appConstants,
        _size = iconSize ?? 170.0,
        _margin = margin ?? const EdgeInsets.all(20),
        _padding = padding ?? const EdgeInsets.all(50),
        super(key: key);

  final AppConstants _appConstants;
  final EdgeInsets _margin, _padding;
  final num _size;
  final Color backgroundColor, foregroundColor;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () => _appConstants.toggleTheme(),
      child: Tooltip(
        message: 'Toggle Theme',
        child: Hero(
          tag: 'icon',
          child: Container(
            margin: _margin,
            padding: _padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: (backgroundColor) ??
                  _appConstants.getLighterForeGroundColor.withOpacity(0.2),
            ),
            child: Icon(
              Icons.restaurant_menu,
              size: _size.toDouble(),
              color: (foregroundColor) ??
                  _appConstants.getLighterForeGroundColor.withOpacity(0.9),
            ),
          ),
        ),
      ),
    );
  }
}
