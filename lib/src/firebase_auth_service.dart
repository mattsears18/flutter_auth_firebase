/*
 * flutter_auth_firebase
 * Copyright (c) 2018 Lance Johnstone. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import 'firebase_user.dart';

///
class FirebaseAuthService implements AuthService {
  FirebaseAuthService() : auth = fb.FirebaseAuth.instance {
    auth.onAuthStateChanged.firstWhere((user) {
      _authChangeNotifier.value = new FirebaseUser(user);
      return true;
    });
  }

  ///
  final fb.FirebaseAuth auth;

  final ValueNotifier<AuthUser> _authChangeNotifier =
      new ValueNotifier<AuthUser>(new FirebaseUser(null));

  ///
  @override
  ValueNotifier<AuthUser> get authUserChanged => _authChangeNotifier;

  ///
  @override
  List<AuthProvider> authProviders = new List<AuthProvider>();

  @override
  List<LinkableProvider> linkProviders = new List<LinkableProvider>();

  AuthOptions _options = new AuthOptions(
    canVerifyAccount: true,
    canChangePassword: false, // package needs to support first
    canChangeEmail: false, // package needs to support first
    canLinkAccounts: true,
    canChangeDisplayName: true,
    canSendForgotEmail: true,
    canDeleteAccount: false, // package needs to support first
  );
  @override
  AuthOptions get options => _options;

  @override
  PhotoUrlProvider postAuthPhotoProvider;

  @override
  PhotoUrlProvider preAuthPhotoProvider;

  @override
  Future<AuthUser> currentUser() async {
    var user = await auth.currentUser();

    return new FirebaseUser(user);
  }

  @override
  Future<String> currentUserToken({bool refresh = false}) async {
    var user = await auth.currentUser();

    if (user == null) {
      return null;
    }
    return await user.getIdToken(refresh: refresh);
  }

  @override
  Future<AuthUser> refreshUser() async {
    var user = await auth.currentUser();
    await user.reload();
    user = await auth.currentUser();

    return _authChangeNotifier.value = new FirebaseUser(user);
  }

  @override
  Future<AuthUser> setUserDisplayName(String name) async {
    var profile = new fb.UserUpdateInfo();
    profile.displayName = name;

    await auth.updateProfile(profile);
    var newUser = await auth.currentUser();
    return authUserChanged.value = new FirebaseUser(newUser);
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();

    var user = await auth.currentUser();

    return _authChangeNotifier.value = new FirebaseUser(user);
  }

  @override
  Future<void> closeAccount(Map<String, String> reauthenticationArgs) {
    //https://firebase.google.com/docs/auth/web/manage-users#re_authenticate_a_user
    //https://firebase.google.com/docs/auth/web/manage-users#delete_a_user
    throw new UnimplementedError('Closing Account is not available');
  }
}
