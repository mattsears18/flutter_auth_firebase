# flutter_auth_firebase

This package is a wrapper to [FlutterFire](https://pub.dartlang.org/packages/firebase_auth) package so that it can be used with the [Authentication Starter](https://github.com/aqwert/flutter_auth_starter/) project


# Setup

As a prerequisite to using firebase authentication you need to follow the instruction provided by the [FlutterFire](https://pub.dartlang.org/packages/firebase_auth) package.

At a minumum the dependencies required are:

* [flutter_auth_base](https://pub.dartlang.org/packages/flutter_auth_base) : The interfaces that allow the abstraction
* [firebase_auth](https://pub.dartlang.org/packages/firebase_auth) : The Firebase for ios and android package
* [google_sign_in](https://pub.dartlang.org/packages/google_sign_in) : To support signin in to google


# Implement

Example code of using the package

Imports:
```dart
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:flutter_auth_firebase/flutter_auth_firebase.dart';
```

```dart
AuthService createFirebaseAuthService() {
  var authService = new FirebaseAuthService();
  authService.authProviders.addAll([
    new FirebaseEmailProvider(service: authService),
    new FirebaseGoogleProvider(service: authService)
  ]);
  authService.linkProviders.addAll([
    new FirebaseEmailProvider(service: authService),
    new FirebaseGoogleProvider(service: authService)
  ]);

  return authService;
}
```

## .authProviders

These are the authentication providers that are supported by the application and need to be set within the Firebase console. The ones supported by this package are:

* Email with Password
* Google Signin

## .linkProviders

These represent the authenticaton providers that allow linking or connecting multiple accounts together which is supported by Firebase

## .preAuthPhotoProvider, .postAuthPhotoProvider

Additionally the `authService.preAuthPhotoProvider` and/or `authService.postAuthPhotoProvider` can be configured to return a profile picture.  See the [flutter_auth_starter](https://github.com/aqwert/flutter_auth_starter/blob/master/README.md#configure-the-authservice) project for details.

# TODO

 - [ ] Twitter provider
 - [ ] Facebook provider
 - [ ] Anonymous Signin
 - [ ] Passwordless signin
 - [ ] Verification by phone

# Issues and Feedback

Since this is based on the [FlutterFire](https://pub.dartlang.org/packages/firebase_auth) package there are some things not yet implemented in order for this package to be supported.

- [ ] Change Email Address : [issue 17343](https://github.com/flutter/flutter/issues/17343)
- [ ] Change password : [issue 16775](https://github.com/flutter/flutter/issues/16775)
- [ ] Close / Remove Account : [issue 15907](https://github.com/flutter/flutter/issues/15907)


Please [create](https://github.com/aqwert/flutter_auth_firebase/issues/new) an issue to provide feedback or an issue.