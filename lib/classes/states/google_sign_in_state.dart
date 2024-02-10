import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// GoogleSignIn googleSignIn = GoogleSignIn();
// GoogleSignInAccount? googleUser;
// late GoogleSignInAccount user;
// late GoogleSignInAuthentication gogleAuth;
// late OAuthCredential credential;
// late UserCredential fireAuth;

// int work = 0;

// Future<void> googleSign1() async {
//   try {
//     googleUser = await googleSignIn.signIn();
//     print('googleUser $googleUser');
//     work=1;
//     print('work $work');
//   } catch (e) {
//     print('eeee $e');
//     return null;
//   }
// }

// Future<void> googleSign2() async {
//   try {
//     user = googleUser!;
//     gogleAuth = await googleUser!.authentication;
//     print('gogleAuth $gogleAuth');
//     print('gogleAuth.accessToken ${gogleAuth.accessToken}');
//     work=2;
//     print('work $work');
//   } catch (e) {
//     print('eeee $e');
//     return null;
//   }
// }

// Future<void> googleSign3() async {
//   try {
//     credential = GoogleAuthProvider.credential(
//         accessToken: gogleAuth.accessToken, idToken: gogleAuth.idToken);
//     print('credential $credential');
//     work=3;
//     print('work $work');
//   } catch (e) {
//     print('eeee $e');
//     return null;
//   }
// }

// Future<void> googleSign4() async {
//   try {
//     fireAuth = await FirebaseAuth.instance.signInWithCredential(credential);
//     print('FirebaseAuth $fireAuth');
//     work=4;
//     print('work $work');
//   } catch (e) {
//     print('eeee $e');
//     return null;
//   }
// }

// Future<DataSignIn?> googleSign5() async {
//   try {
//     work=5;
//     print('work $work');
//     return DataSignIn(
//         fullName: user.displayName ?? '', email: user.email, profilePhoto: user.photoUrl ?? '');

//   } catch (e) {
//     print('eeee $e');
//     return null;
//   }
// }

Future<DataSignIn?> googleSign() async {
  print('googleLogin');
  GoogleSignIn googleSignIn = GoogleSignIn();

  try {
    var googleUser = await googleSignIn.signIn();
    print('googleUser $googleUser');
    if (googleUser == null) return null;
    // else return googleUser;
    // GoogleSignInAccount user = googleUser;
    // var gogleAuth = await googleUser.authentication;
    // print('gogleAuth $gogleAuth');
    // print('gogleAuth.accessToken ${gogleAuth.accessToken}');

    // var credential = GoogleAuthProvider.credential(
    //     accessToken: gogleAuth.accessToken, idToken: gogleAuth.idToken);
    // print('credential $credential');
    // var fireAuth = await FirebaseAuth.instance.signInWithCredential(credential);
    // print('FirebaseAuth $fireAuth');
    return DataSignIn(
        fullName: googleUser.displayName ?? '',
        email: googleUser.email,
        profilePhoto: googleUser.photoUrl ?? '');

    // return DataSignIn(
    //     fullName:'emad haji',
    //     email: 'emadhaji6@gmail.com',
    //     profilePhoto: 'https://lh3.googleusercontent.com/a/AGNmyxY9yy7LcrEujMODbDctNy63tyoigoRtPLn-7scb=s96-c');
  } catch (e) {
    print('eeee $e');
    return null;
  }
}

class DataSignIn {
  late String fullName, username, email, profilePhoto;

  DataSignIn({required this.fullName, required this.email, required this.profilePhoto}) {
    int index = email.lastIndexOf('@');
    this.username = email.substring(0, index);
  }
}

Future<DataSignIn?> appleSign() async {
  try {
    AuthorizationCredentialAppleID appleData = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    if (appleData.email != null && appleData.familyName != null && appleData.givenName != null) {
      OAuthProvider oAuthProvider = OAuthProvider('apple.com');
      OAuthCredential credential = oAuthProvider.credential(
        idToken: appleData.identityToken,
        accessToken: appleData.authorizationCode,
      );

      FirebaseAuth.instance.signInWithCredential(credential);
// var fireAuth =
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
