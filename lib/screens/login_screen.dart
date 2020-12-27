import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:restaurant_manage/backend/bloc/Login/Login_bloc.dart';

import 'package:restaurant_manage/backend/constants.dart';

class LoginButtons extends StatelessWidget {
  const LoginButtons({
    Key key,
    @required AppConstants appConstants,
    @required bool isFormValid,
    @required Map<String, TextEditingController> controlmap,
  })  : _isFormValid = isFormValid,
        _controlmap = controlmap,
        _appConstants = appConstants,
        buttonPadding =
            const EdgeInsets.symmetric(horizontal: 35, vertical: 18),
        super(key: key);

  final AppConstants _appConstants;
  final EdgeInsets buttonPadding;
  final bool _isFormValid;
  final Map<String, TextEditingController> _controlmap;

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = context.watch<LoginBloc>();
    print(loginBloc);

    // Build Button Styles
    final Color _buttonForegroundColor =
        (_isFormValid) ? _appConstants.getForeGroundColor : Colors.grey;
    final ButtonStyle _buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(_buttonForegroundColor),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(buttonPadding),
    );

    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: (!_isFormValid)
                    ? null
                    : () {
                        loginBloc.signInEmail(
                          email: _controlmap['user'].text,
                          password: _controlmap['pass'].text,
                        );
                      },
                style: _buttonStyle,
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: (!_isFormValid)
                    ? null
                    : () {
                        loginBloc.signUpEmail(
                          email: _controlmap['user'].text,
                          password: _controlmap['pass'].text,
                        );
                      },
                style: _buttonStyle,
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: Text(
              'or',
              style: TextStyle(color: _appConstants.getForeGroundColor),
            ),
          ),
          SignInButton(
            (_appConstants.isThemeLight) ? Buttons.Google : Buttons.GoogleDark,
            onPressed: () => loginBloc.signInGoogle(),
          )
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final AppConstants _appConstants;
  final GlobalKey<FormState> _formKey;

  LoginForm({Key key, @required AppConstants appConstants})
      : _appConstants = appConstants,
        _formKey = GlobalKey<FormState>(),
        super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final Map<String, TextEditingController> _controlmap = {
    'user': TextEditingController(),
    'pass': TextEditingController(),
  };
  bool _validatedForm;

  void _update() {
    setState(() => _validatedForm = widget._formKey.currentState.validate());
  }

  @override
  void initState() {
    _validatedForm = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: widget._appConstants.getForeGroundColor),
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      color: widget._appConstants.getLighterForeGroundColor[50].withAlpha(255),
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
      shadowColor: widget._appConstants.getLighterForeGroundColor,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Form(
          key: widget._formKey,
          autovalidateMode: AutovalidateMode.always,
          onChanged: _update,
          child: Column(
            children: [
              FormBuilderTextField(
                validators: [FormBuilderValidators.required()],
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
                controller: _controlmap['user'],
                attribute: 'user',
              ),
              FormBuilderTextField(
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(6),
                ],
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                controller: _controlmap['pass'],
                attribute: 'pass',
              ),
              LoginButtons(
                appConstants: widget._appConstants,
                isFormValid: _validatedForm,
                controlmap: _controlmap,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controlmap.forEach((_, TextEditingController c) => c.dispose());
    super.dispose();
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(50),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: _appConstants.getLighterForeGroundColor
                        .withOpacity(0.2)),
                child: Icon(
                  Icons.restaurant_menu,
                  size: 60,
                  color:
                      _appConstants.getLighterForeGroundColor.withOpacity(0.9),
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
      ),
    );
  }
}
