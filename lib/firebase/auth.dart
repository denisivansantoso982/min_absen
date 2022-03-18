import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future<User?> getCurrentUserData() async {
  User? theUser;
  auth.authStateChanges().listen((user) {
    if (user == null) {
      theUser = null;
    } else {
      theUser = user;
    }
  });

  await Future.delayed(const Duration(seconds: 1));

  return theUser;
}

Future<GoogleSignInAccount?> signInWithGoogle() async {
  final GoogleSignInAccount? result = await GoogleSignIn().signIn();

  return result;
  // try {
  //   GoogleSignInAccount? account = await GoogleSignIn().signIn();
  //   print(account);
  // } on PlatformException catch (error) {
  //   print(error.code);
  // } catch (error) {
  //   print(error);
  // }
}

Future<UserCredential> authenticateEmail(GoogleSignInAccount googleUser) async {
  final GoogleSignInAuthentication? googleAuth =
      await googleUser.authentication;
  final theCredential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  return await auth.signInWithCredential(theCredential);
}

Future<void> signOut() async {
  auth.signOut();
  GoogleSignIn().signOut();
}
