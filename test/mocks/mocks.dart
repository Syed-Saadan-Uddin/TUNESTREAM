import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// This annotation tells the build_runner to generate mock implementations
// for all the classes listed below. This is essential for unit testing
// anything that interacts with Firebase, as it allows us to simulate
// Firebase's behavior without making real network calls.
@GenerateMocks([
  FirebaseAuth,
  GoogleSignIn,
  UserCredential, // The object returned after a successful sign-in
  User,           // The Firebase user object
  GoogleSignInAccount,
  GoogleSignInAuthentication,
])
void main() {
  // This main function is empty and is only here to hold the annotation.
}