/*
 * flutter_auth_firebase
 * Copyright (c) 2018 Lance Johnstone. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_auth_base/flutter_auth_base.dart';

import 'firebase_user_account.dart';

class FirebaseUser extends AuthUser {
  FirebaseUser(this.user);

  fb.FirebaseUser user;

  @override
  String get displayName => user?.displayName ?? '';

  @override
  String get email => user?.email ?? '';

  @override
  bool get isEmailVerified => user?.isEmailVerified;

  @override
  bool get isValid => user != null;

  @override
  String get uid => user?.uid;

  @override
  String get photoUrl => user.photoUrl;

  @override
  List<AuthUserAccount> get providerAccounts => _authProviders(user);

  List<AuthUserAccount> _authProviders(fb.FirebaseUser user) {
    var providers = new List<AuthUserAccount>();
    if (user != null) {
      for (var prov in user.providerData ?? new List<fb.UserInfo>()) {
        var editable = prov.providerId == 'password';

        providers.add(new FirebaseUserAccount(
            canChangeDisplayName: editable,
            canChangeEmail: editable,
            canChangePassword: editable)
          ..providerName = getProviderName(prov.providerId)
          ..email = prov.email
          ..displayName = prov.displayName
          ..photoUrl = prov.photoUrl);
      }
    }
    return providers;
  }

  String getProviderName(String id) {
    if (id.startsWith('google.com')) return 'google';

    return id;
  }
}
