import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isVerified;

  const AuthUser(this.isVerified);

  factory AuthUser.fromfirebase(User user) => AuthUser(user.emailVerified);
}
