import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

Future<DataSignIn?> googleSign() async {
  print('googleLogin');
  GoogleSignIn googleSignIn = GoogleSignIn();

  try {
    var googleUser = await googleSignIn.signIn();
    print('googleUser $googleUser');
    if (googleUser == null) return null;
    // else return googleUser;
    GoogleSignInAccount user = googleUser;
    var gogleAuth = await googleUser.authentication;
    print('gogleAuth $gogleAuth');
    print('gogleAuth.accessToken ${gogleAuth.accessToken}');

    var credential = GoogleAuthProvider.credential(
        accessToken: gogleAuth.accessToken, idToken: gogleAuth.idToken);
    print('credential $credential');
    var fireAuth = await FirebaseAuth.instance.signInWithCredential(credential);
    print('FirebaseAuth $fireAuth');
    return DataSignIn(
        fullName: user.displayName ?? '',
        email: user.email,
        profilePhoto: user.photoUrl ?? '');
  } catch (e) {
    print('eeee $e');
    return null;
  }
}

class DataSignIn {
  late String fullName, username, email, profilePhoto;

  DataSignIn(
      {required this.fullName,
      required this.email,
      required this.profilePhoto}) {
    int index = email.lastIndexOf('@');
    this.username = email.substring(0, index);
  }
}

Future<DataSignIn?> appleSign() async {
  try {
    AuthorizationCredentialAppleID appleData =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    if (appleData.email != null &&
        appleData.familyName != null &&
        appleData.givenName != null) {
      OAuthProvider oAuthProvider = OAuthProvider('apple.com');
      OAuthCredential credential = oAuthProvider.credential(
        idToken: appleData.identityToken,
        accessToken: appleData.authorizationCode,
      );

      var fireAuth = FirebaseAuth.instance.signInWithCredential(credential);

      print('appleData $appleData');
      print('email ${appleData.email}');
      print('familyName ${appleData.familyName}');
      print('givenName ${appleData.givenName}');

      return DataSignIn(
          fullName: '${appleData.givenName} ${appleData.familyName}',
          email: appleData.email!,
          profilePhoto: '');
    } else {
      return null;
    }
  } catch (e) {
    print('eeee $e');
    return null;
  }
}
