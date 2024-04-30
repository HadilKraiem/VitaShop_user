import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';

import '../../root_screen.dart';
import '../../services/my_app_functions.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  // Future<void> _googleSignSignIn({required BuildContext context}) async {
  //   try {
  //      print("Starting Google sign-in process...");
  //     final googleSignIn = GoogleSignIn();

  //     final googleAccount = await googleSignIn.signIn();
  //     if (googleAccount != null) {
  //       print("Google sign-in successful, getting authentication...");
  //       final googleAuth = await googleAccount.authentication;
  //       if (googleAuth.accessToken != null && googleAuth.idToken != null) {
  //          print("Google authentication successful, signing in with Firebase...");
  //         final authResults = await FirebaseAuth.instance
  //             .signInWithCredential(GoogleAuthProvider.credential(
  //           accessToken: googleAuth.accessToken,
  //           idToken: googleAuth.idToken,

  //         )
  //         );
  //          print("Firebase sign-in successful.");
  //         if (authResults.additionalUserInfo!.isNewUser) {
  //           print("New user detected, adding user data to Firestore...");
  //           await FirebaseFirestore.instance
  //               .collection("users")
  //               .doc(
  //                 authResults.user!.uid,
  //               )
  //               .set({
  //             'userId': authResults.user!.uid,
  //             'userName': authResults.user!.displayName,
  //             'userImage': authResults.user!.photoURL,
  //             'userEmail': authResults.user!.email,
  //             'createdAt': Timestamp.now(),
  //             'userWish': [],
  //             'userCart': [],
  //           });
  //           print("User data added to Firestore.");
  //         }
  //       }
  //     }
  //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //       Navigator.pushReplacementNamed(context, RootScreen.routeName);
  //     });
  //   } on FirebaseException catch (error) {
  //     // Print or log Firebase errors
  //     print("Firebase Error: ${error.message}");
  //     await MyAppFunctions.showErrorOrWarningDialog(
  //       context: context,
  //       subtitle: error.message.toString(),
  //       fct: () {},
  //     );
  //   } catch (error) {
  //     // Print or log generic errors
  //     print("Generic Error: $error");
  //     await MyAppFunctions.showErrorOrWarningDialog(
  //       context: context,
  //       subtitle: error.toString(),
  //       fct: () {},
  //     );
  //   }
  // }
  Future<void> _googleSignSignIn({required BuildContext context}) async {
    try {
      print("Starting Google sign-in process...");
      final googleSignIn = GoogleSignIn();

      final googleAccount = await googleSignIn.signIn();
      if (googleAccount != null) {
        print("Google sign-in successful, getting authentication...");
        final googleAuth = await googleAccount.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          print(
              "Google authentication successful, signing in with Firebase...");
          final authResults = await FirebaseAuth.instance.signInWithCredential(
            GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken!,
              idToken: googleAuth.idToken!,
            ),
          );
          if (googleAuth.accessToken != null && googleAuth.idToken != null) {
            // Proceed with sign-in
          } else {
            print(
                "Google authentication failed: Access token or ID token is null.");
            print(googleAuth.accessToken);
            print(googleAuth.idToken);
            // Handle the case where access token or ID token is null
          }
          print("Firebase sign-in successful.");
          if (authResults.additionalUserInfo!.isNewUser) {
            print("New user detected, adding user data to Firestore...");
            await FirebaseFirestore.instance
                .collection("users")
                .doc(authResults.user!.uid)
                .set({
              'userId': authResults.user!.uid,
              'userName': authResults.user!.displayName,
              'userImage': authResults.user!.photoURL,
              'userEmail': authResults.user!.email,
              'createdAt': Timestamp.now(),
              'userWish': [],
              'userCart': [],
            });
            print("User data added to Firestore.");
          }
        } else {
          print(
              "Google authentication failed: Access token or ID token is null.");
          // Handle the case where access token or ID token is null
        }
      } else {
        print("Google sign-in failed: No Google account selected.");
        // Handle the case where user didn't select any Google account
      }
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacementNamed(context, RootScreen.routeName);
      });
    } on FirebaseException catch (error) {
      // Print or log Firebase errors
      print("Firebase Error: ${error.message}");
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: error.message.toString(),
        fct: () {},
      );
    } catch (error) {
      // Print or log generic errors
      print("Generic Error: $error");
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: error.toString(),
        fct: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        padding: const EdgeInsets.all(12.0),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12.0,
          ),
        ),
      ),
      icon: const Icon(
        Ionicons.logo_google,
        color: Colors.red,
      ),
      label: const Text(
        "Sign in with google",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () async {
        await _googleSignSignIn(context: context);
      },
    );
  }
}
