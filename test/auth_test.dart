import 'package:flutter_application_1/services/auth/auth_exception.dart';
import 'package:flutter_application_1/services/auth/auth_provider.dart';
import 'package:flutter_application_1/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Mock Authentication',
    () {
      final provider = MockAuthProvider();
      test(
        'Should not be initialized to begin with',
        () {
          expect(
            provider.isInitialized,
            false,
          );
        },
      );
      test(
        'Cannot log out if not initiallized',
        () {
          expect(
            provider.logOut(),
            throwsA(const TypeMatcher<NotInittializedException>()),
          );
        },
      );
      test(
        'Should be able to be initialized',
        () async {
          await provider.initialize();
          expect(provider.isInitialized, true);
        },
      );
      test(
        'User should be null after initialization',
        () {
          expect(provider.currentUser, null);
        },
      );
      test(
        'Should be able to initializ in less than 2 seconds',
        () async {
          await provider.initialize();
          expect(provider.isInitialized, true);
        },
        timeout: const Timeout(
          Duration(seconds: 2),
        ),
      );
      test(
        'Should be able to initializ in less than 2 seconds',
        () async {
          await provider.initialize();
          expect(provider.isInitialized, true);
        },
        timeout: const Timeout(
          Duration(seconds: 2),
        ),
      );
      test(
        'Create user should delegate to logIn function',
        () async {
          final badEmailUser = provider.createUser(
            email: 'nam@nguyen.com',
            password: 'anypassword',
          );
          expect(
            badEmailUser,
            throwsA(const TypeMatcher<UserNotFoundAuthException>()),
          );
          final badPasswordUser = provider.createUser(
            email: 'someone@nguyen.com',
            password: '123456',
          );
          expect(
            badPasswordUser,
            throwsA(const TypeMatcher<WrongPasswordAuthException>()),
          );
          final user = await provider.createUser(
            email: 'nam',
            password: 'nguyen',
          );
          expect(
            provider.currentUser,
            user,
          );
          expect(
            user.isEmailVerified,
            false,
          );
        },
      );
      test(
        'Logged in user should be able to get verified',
        () {
          provider.sendEmailVerification();
          final user = provider.currentUser;
          expect(
            user,
            isNotNull,
          );
          expect(
            user!.isEmailVerified,
            true,
          );
        },
      );
      test(
        'Should be able to log out and log in again',
        () async {
          await provider.logOut();
          await provider.logIn(
            email: 'email',
            password: 'password',
          );
          final user = provider.currentUser;
          expect(
            user,
            isNotNull,
          );
        },
      );
    },
  );
}

class NotInittializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInittializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInittializedException();
    if (email == 'nam@nguyen.com') throw UserNotFoundAuthException();
    if (password == '123456') throw WrongPasswordAuthException();
    const user = AuthUser(
      id: 'my_id',
      isEmailVerified: false,
      email: 'nam@nguyen.com',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInittializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInittializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(
      id: 'my_id',
      isEmailVerified: true,
      email: 'nam@nguyen.com',
    );
    _user = newUser;
  }
}
