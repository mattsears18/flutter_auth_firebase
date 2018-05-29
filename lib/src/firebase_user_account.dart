/*
 * flutter_auth_firebase
 * Copyright (c) 2018 Lance Johnstone. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter_auth_base/flutter_auth_base.dart';

class FirebaseUserAccount extends AuthUserAccount {
  FirebaseUserAccount(
      {bool canChangeEmail = true,
      bool canChangeDisplayName: true,
      bool canChangePassword: true})
      : super(
            canChangeDisplayName: canChangeDisplayName,
            canChangeEmail: canChangeEmail,
            canChangePassword: canChangePassword);
  @override
  String displayName;

  @override
  String email;

  @override
  String providerName;

  @override
  String photoUrl;
}
