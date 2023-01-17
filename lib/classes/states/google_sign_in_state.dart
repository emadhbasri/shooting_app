import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

Future<GoogleSignInAccount?> googleLogin() async {
  print('googleLogin');
  GoogleSignIn googleSignIn = GoogleSignIn();

  try {
    var googleUser = await googleSignIn.signIn();
    print('googleUser $googleUser');
    if (googleUser == null) return null;
    // else return googleUser;
    GoogleSignInAccount user = googleUser;
    // return user;
    var gogleAuth = await googleUser.authentication;
    print('gogleAuth $gogleAuth');
    print('gogleAuth.accessToken ${gogleAuth.accessToken}');

    var credential = GoogleAuthProvider.credential(
        accessToken: gogleAuth.accessToken, idToken: gogleAuth.idToken);
    print('credential $credential');
    var fireAuth = await FirebaseAuth.instance.signInWithCredential(credential);
    print('FirebaseAuth $fireAuth');
    return user;
  } catch (e) {
    print('eeee $e');
  }
}

Future<AuthorizationCredentialAppleID> appleLogin() async {

  AuthorizationCredentialAppleID credential =
      await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
  );


  return credential;
}
