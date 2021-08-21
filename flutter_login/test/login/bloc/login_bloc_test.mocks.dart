// Mocks generated by Mockito 5.0.14 from annotations
// in flutter_login/test/login/bloc/login_bloc_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:authentication_repository/src/authentication_repository.dart'
    as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [AuthenticationRepostiory].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationRepostiory extends _i1.Mock
    implements _i2.AuthenticationRepostiory {
  MockAuthenticationRepostiory() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Stream<_i2.AuthenticationStatus> get status =>
      (super.noSuchMethod(Invocation.getter(#status),
              returnValue: Stream<_i2.AuthenticationStatus>.empty())
          as _i3.Stream<_i2.AuthenticationStatus>);
  @override
  _i3.Future<void> login({String? username, String? password}) =>
      (super.noSuchMethod(
          Invocation.method(
              #login, [], {#username: username, #password: password}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  void logout() => super.noSuchMethod(Invocation.method(#logout, []),
      returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  String toString() => super.toString();
}
