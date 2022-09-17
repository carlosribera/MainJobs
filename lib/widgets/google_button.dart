import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:main_jobs/screens/home_screen.dart';
import 'package:main_jobs/services/global_methods.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({Key? key}) : super(key: key);

  Future<void> _googleSignIn(context) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResult = await FirebaseAuth.instance.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken),
          );

          if (authResult.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(authResult.user!.uid)
                .set({
              'id': authResult.user!.uid,
              'name': authResult.user!.displayName,
              'email': authResult.user!.email,
              'shipping-address': '',
              //'userWish':[],
              //'userCart':[],
              'createdAt': Timestamp.now(),
            });
          }
          // to navigate to home screen after log in
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const FetchScreen(),
            ),
          );
        } on FirebaseException catch (error) {
          GlobalMethods.errorDialog(
              subtitle: '${error.message}', context: context);
        } catch (error) {
          GlobalMethods.errorDialog(subtitle: '$error', context: context);
        } finally {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 140,
      decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          )),
      child: Padding(
        padding: EdgeInsets.only(right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Image.asset(
                'assets/images/google.png',
                height: 30,
              ),
              iconSize: 50,
              onPressed: () {
                _googleSignIn(context);
              },
            ),
            Text(
              'google',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
