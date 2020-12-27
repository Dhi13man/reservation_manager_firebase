import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:restaurant_manage/backend/bloc/Login/Login_state.dart';
import 'package:restaurant_manage/backend/repos/authentication.dart';

export 'package:restaurant_manage/backend/bloc/Login/Login_state.dart';

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
      await _authenticationRepository.logInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(SignedInLoginState());
    } catch (e) {
      emit(ErrorLoginState(e.toString()));
    }
  }

  void signInGoogle() async {
    try {
      await _authenticationRepository.logInWithGoogle();
      emit(SignedInLoginState());
    } catch (e) {
      emit(ErrorLoginState(e));
    }
  }

  void signUpEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      await _authenticationRepository.signUp(
        email: email,
        password: password,
      );
      emit(SignedInLoginState());
    } catch (e) {
      if (e is SignUpFailure)
        emit(ErrorLoginState('Sign Up Error. Try Different Credentials'));
      else if (e is LogInWithEmailAndPasswordFailure)
        emit(ErrorLoginState('Log In Error. Check Credentials.'));
      else if (e is LogInWithGoogleFailure)
        emit(ErrorLoginState('Log In Error while interfacing Google'));
      else
        emit(ErrorLoginState(e.toString()));
    }
  }

  void signOut() async {
    await _authenticationRepository.logOut();
    emit(SignedOutLoginState());
  }
}
