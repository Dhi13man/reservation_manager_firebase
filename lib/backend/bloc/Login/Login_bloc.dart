import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import 'package:reservation_manager/backend/bloc/Login/Login_state.dart';
import 'package:reservation_manager/backend/repos/authentication.dart';
import 'package:reservation_manager/backend/repos/data_classes.dart' as data;

export 'package:reservation_manager/backend/bloc/Login/Login_state.dart';

class LoginBloc extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(UnLoginState());

  void signInEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      data.User _user = data.User(email: email, password: password);
      emit(LoadingLoginState(user: _user));
      UserCredential cred =
          await _authenticationRepository.logInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(SignedInLoginState(user: _user, credential: cred));
    } catch (e) {
      if (e is LogInWithEmailAndPasswordFailure)
        emit(ErrorLoginState('Log In Error. Check Credentials.'));
      emit(ErrorLoginState(e.toString()));
    }
  }

  void signInGoogle() async {
    try {
      emit(LoadingLoginState());
      UserCredential cred = await _authenticationRepository.logInWithGoogle();
      emit(SignedInLoginState(credential: cred));
    } catch (e) {
      if (e is LogInWithGoogleFailure)
        emit(ErrorLoginState('Error while interfacing Google.'));
      emit(ErrorLoginState(e));
    }
  }

  void signUpEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      data.User _user = data.User(email: email, password: password);
      emit(LoadingLoginState(user: _user));
      UserCredential cred = await _authenticationRepository.signUp(
        email: email,
        password: password,
      );
      emit(SignedInLoginState(user: _user, credential: cred));
    } catch (e) {
      if (e is SignUpFailure)
        emit(ErrorLoginState('Sign Up Error. Try Different Credentials'));
      else if (e is LogInWithEmailAndPasswordFailure)
        emit(ErrorLoginState('Log In Error. Check Credentials.'));
      else
        emit(ErrorLoginState(e.toString()));
    }
  }

  void signOut() async {
    await _authenticationRepository.logOut();
    emit(SignedOutLoginState());
  }

  void forgotPassword(String email) async =>
      await _authenticationRepository.forgotPassword(email);
}
