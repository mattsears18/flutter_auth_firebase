/*
 * flutter_auth_firebase
 * Copyright (c) 2018 Lance Johnstone. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';

import 'package:flutter/services.dart';

import 'firebase_auth_service.dart';
import 'firebase_user.dart';

import 'user_acceptance_callback.dart';

class FirebaseEmailProvider extends AuthProvider implements LinkableProvider {
  FirebaseEmailProvider(
      {@required FirebaseAuthService service,
      UserAcceptanceCallback hasUserAcceptedTerms})
      : _service = service,
        _hasUserAcceptedTerms = hasUserAcceptedTerms;

  final UserAcceptanceCallback _hasUserAcceptedTerms;
  final FirebaseAuthService _service;

  @override
  String get providerName => "password";

  @override
  String get providerDisplayName => "Email with Password";

  @override
  Future<AuthUser> create(Map<String, String> args,
      {termsAccepted = false}) async {
    if (!termsAccepted) {
      throw new UserAcceptanceRequiredException(args);
    } else {
      var user = await _service.auth.createUserWithEmailAndPassword(
          email: args['email'], password: args['password']);

      return _service.authUserChanged.value = FirebaseUser(user);
    }
  }

  @override
  Future<AuthUser> signIn(Map<String, String> args,
      {termsAccepted = false}) async {
    var user = await _service.auth.signInWithEmailAndPassword(
        email: args['email'], password: args['password']);

    // gives a chance that the owner can check if the end user needs to accept terms.
    // even if they already exist
    if (!termsAccepted && _hasUserAcceptedTerms != null) {
      bool accepted = await _hasUserAcceptedTerms(user?.uid);
      if (!accepted) {
        throw new UserAcceptanceRequiredException(args);
      }
    }

    return _service.authUserChanged.value = new FirebaseUser(user);
  }

  @override
  Future<AuthUser> sendPasswordReset(Map<String, String> args) async {
    await _service.auth.sendPasswordResetEmail(email: args['email']);

    return _service.authUserChanged.value;
  }

  @override
  Future<AuthUser> sendVerification(Map<String, String> args) async {
    var user = await _service.auth.currentUser();

    await user.sendEmailVerification();

    return _service.authUserChanged.value;
  }

  @override
  Future<AuthUser> changePassword(Map<String, String> args) async {
    //https://firebase.google.com/docs/auth/web/manage-users#re_authenticate_a_user
    //https://firebase.google.com/docs/auth/web/manage-users#delete_a_user
    throw new UnimplementedError('Change password is not available');
  }

  @override
  Future<AuthUser> changePrimaryIdentifier(Map<String, String> args) async {
    //https://firebase.google.com/docs/auth/web/manage-users#re_authenticate_a_user
    //https://firebase.google.com/docs/auth/web/manage-users#delete_a_user
    //Also send a verification email?
    throw new UnimplementedError('Change email is not available');
  }

  @override
  Future<AuthUser> linkAccount(Map<String, String> args) async {
    //need to reauthenticate using the last known provider

    try {
      var user = await _service.auth.linkWithEmailAndPassword(
          email: args['email'], password: args['password']);

      return _service.authUserChanged.value = new FirebaseUser(user);
    } on PlatformException catch (error) {
      if (error.details.toString().startsWith('This operation is sensitive')) {
        throw new AuthRequiredException();
      }
      throw error;
    }
  }
}
