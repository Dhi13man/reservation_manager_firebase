import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:restaurant_manage/backend/constants.dart';

class LoginButtons extends StatelessWidget {
  const LoginButtons({
    Key key,
    @required AppConstants appConstants,
  })  : _appConstants = appConstants,
        super(key: key);

  final AppConstants _appConstants;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () => _appConstants.toggleTheme(),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                _appConstants.getForeGroundColor,
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            ),
            child: Text(
              'Submit',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            'or',
            style: TextStyle(color: _appConstants.getForeGroundColor),
          )
        ],
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final AppConstants _appConstants;

  const LoginForm({Key key, @required AppConstants appConstants})
      : _appConstants = appConstants,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: _appConstants.getForeGroundColor),
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      color: _appConstants.getLighterForeGroundColor[50].withAlpha(255),
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
      shadowColor: _appConstants.getLighterForeGroundColor,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          children: [
            FormBuilderTextField(
              decoration: InputDecoration(
                labelText: 'Username',
              ),
              attribute: 'name',
            ),
            FormBuilderTextField(
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              attribute: 'pass',
            ),
            LoginButtons(appConstants: _appConstants)
          ],
        ),
      ),
    );
  }
}

class HotelAppLoginScreen extends StatelessWidget {
  final String _title;

  HotelAppLoginScreen({Key key, String title})
      : _title = title ?? 'App Title',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    AppConstants _appConstants = context.watch<AppConstants>();

    return Scaffold(
      backgroundColor: _appConstants.getBackGroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(50),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color:
                      _appConstants.getLighterForeGroundColor.withOpacity(0.2)),
              child: Icon(
                Icons.restaurant_menu,
                size: 170,
                color: _appConstants.getLighterForeGroundColor.withOpacity(0.9),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                _title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _appConstants.getForeGroundColor,
                  fontSize: 30,
                ),
              ),
            ),
            LoginForm(appConstants: _appConstants),
          ],
        ),
      ),
    );
  }
}
