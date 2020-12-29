import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:reservation_manager/backend/bloc/Login/Login_bloc.dart';
import 'package:reservation_manager/backend/constants.dart';

import 'package:reservation_manager/screens/splash_screen.dart';
import 'package:reservation_manager/screens/reservation_screen.dart';

class LoginButtons extends StatelessWidget {
  const LoginButtons({
    Key key,
    @required AppConstants appConstants,
    @required bool isFormValid,
    @required Map<String, TextEditingController> controlmap,
  })  : _isFormValid = isFormValid,
        _controlmap = controlmap,
        _appConstants = appConstants,
        buttonPadding = const EdgeInsets.symmetric(
          horizontal: 35,
          vertical: 18,
        ),
        super(key: key);

  final AppConstants _appConstants;
  final EdgeInsets buttonPadding;
  final bool _isFormValid;
  final Map<String, TextEditingController> _controlmap;

  Color _buttonForegroundColor(bool isEnabled) =>
      (isEnabled) ? _appConstants.getForeGroundColor : Colors.grey;

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);

    // Build Button Styles

    final ButtonStyle _buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        _buttonForegroundColor(_isFormValid),
      ),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(buttonPadding),
    );

    bool isEmailValid = (_controlmap['user'] == null)
        ? false
        : FormBuilderValidators.email()(_controlmap['user'].text) == null;

    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: (!isEmailValid)
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                          content:
                              Text('Check Email For Password Reset Link...'),
                        ),
                      );
                      loginBloc.forgotPassword(_controlmap['user'].text);
                    },
              child: Text(
                'Forgot password',
                style: TextStyle(
                  color: _buttonForegroundColor(isEmailValid),
                  fontSize: 10,
                ),
              ),
            ),
          ),
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
  final Map<String, TextEditingController> _controlMap = {
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
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ],
                decoration: InputDecoration(
                  labelText: 'Email Address',
                ),
                controller: _controlMap['user'],
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
                controller: _controlMap['pass'],
                attribute: 'pass',
              ),
              LoginButtons(
                appConstants: widget._appConstants,
                isFormValid: _validatedForm,
                controlmap: _controlMap,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controlMap.forEach((_, TextEditingController c) => c.dispose());
    super.dispose();
  }
}

class LoginScreen extends StatelessWidget {
  final String _title;

  static const routeName = '/login';
  LoginScreen({Key key, String title})
      : _title = title ?? 'App Title',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    AppConstants _appConstants = context.watch<AppConstants>();
    LoginBloc loginBloc = context.watch<LoginBloc>();

    return BlocListener<LoginBloc, LoginState>(
      cubit: loginBloc,
      listener: (context, state) {
        if (state is LoadingLoginState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(days: 30),
              padding: EdgeInsets.all(2),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Attempting to Log you in...'),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }

        if (state is SignedInLoginState) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          Navigator.pushReplacementNamed(
            context,
            ReservationListScreen.routeName,
          );
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        } else if (state is ErrorLoginState) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ErrorLoginState errorState = state;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Center(child: Text('Sign in Error')),
              content: Text('${errorState.errorMessage}'),
            ),
          );
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        }
      },
      child: Scaffold(
        backgroundColor: _appConstants.getBackGroundColor,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AppHeroIcon(appConstants: _appConstants, iconSize: 150.0),
                Container(
                  margin: EdgeInsets.all(20),
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
      ),
    );
  }
}
