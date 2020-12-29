import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template user}
/// Reservation model
///
/// [Reservation.empty] represents an unauthenticated reservation.
/// {@endtemplate}
class Reservation extends Equatable {
  /// {@macro user}
  const Reservation({
    @required this.dateTime,
    this.email = '',
    @required this.name,
    @required this.phoneNum,
  })  : assert(dateTime != null),
        assert(name != null);

  /// The current user's name (display name).
  final String name;

  /// Phone number of reservation
  final int phoneNum;

  /// The current user's email address.
  final String email;

  /// Reservation Time Data
  final DateTime dateTime;

  /// Empty user which represents an unauthenticated user.
  static final Reservation empty = Reservation(
    email: '',
    phoneNum: null,
    name: '',
    dateTime: DateTime.now(),
  );

  @override
  List<Object> get props => [email, phoneNum, name, dateTime];
}

/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({
    this.name,
    @required this.email,
    this.id,
    @required this.password,
  })  : assert(email != null),
        assert(password != null);

  /// The current user's email address.
  final String email;

  /// The current user's id.
  final String id;

  /// The current user's name (display name).
  final String name;

  /// The current user's name (display name).
  final String password;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(email: '', id: '', password: '', name: null);

  @override
  List<Object> get props => [email, id, name];
}
