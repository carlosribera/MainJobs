import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import 'package:main_jobs/screens/auth/forget_pass.dart';
import 'package:main_jobs/screens/auth/login.dart';
import 'package:main_jobs/services/global_methods.dart';
import 'package:main_jobs/widgets/text_widget.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController =
      TextEditingController(text: "");

  @override
  void dispose() {
    // TODO: implement dispose
    _addressTextController.dispose();
    super.dispose();
  }

  String? _email;
  String? _name;
  String? address;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    getuserData();
    super.initState();
  }

  Future<void> getuserData() async {
    setState(() {});
    if (user == null) {
      setState(() {});
      return;
    }
    try {
      String _uid = user!.uid;

      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        address = userDoc.get('shipping-address');
        _addressTextController.text = userDoc.get('shipping-address');
      }
    } catch (error) {
      setState(() {});

      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // To create UserProfile screen UI
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData.fallback(),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Hi, ',
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        // to fetch and show name of user
                        TextSpan(
                            text: _name == null ? 'user' : _name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('My name is pressed');
                              }),
                      ]),
                ),
                const SizedBox(
                  height: 5,
                ),
                // to fetch and show email of user
                Text(
                  _email == null ? 'Email' : _email!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  thickness: 2,
                ),
                const SizedBox(
                  height: 20,
                ),
                // to fetch and show Address of user
                _listTiles(
                  title: 'Address 2',
                  subtitle: address,
                  icon: IconlyLight.profile,
                  onPressed: () async {
                    await _showAddressDialog();
                  },
                  color: Colors.black,
                ),
                // to fetch and reset password of user

                _listTiles(
                  title: 'Forget Password',
                  icon: IconlyLight.unlock,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ForgetPasswordScreen(),
                      ),
                    );
                  },
                  color: Colors.black,
                ),

                _listTiles(
                  title: user == null ? 'Login' : 'Logout',
                  icon: user == null ? IconlyLight.login : IconlyLight.logout,
                  onPressed: () {
                    if (user == null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                      return;
                    }
                    GlobalMethods.warningDialog(
                        title: 'Sign out',
                        subtitle: 'Do you wanna sign out',
                        fct: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        context: context);
                  },
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddressDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update'),
          content: TextField(
            controller: _addressTextController,
            maxLines: 5,
            decoration: const InputDecoration(hintText: "Your address"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // to update chage and save to firebase
                String _uid = user!.uid;
                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(_uid)
                      .update({
                    'shipping-address': _addressTextController.text,
                  });

                  Navigator.pop(context);
                  setState(() {
                    address = _addressTextController.text;
                  });
                } catch (err) {
                  GlobalMethods.errorDialog(
                      subtitle: err.toString(), context: context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}

Widget _listTiles({
  required String title,
  String? subtitle,
  required IconData icon,
  required Function onPressed,
  required Color color,
}) {
  return ListTile(
    title: TextWidget(
      text: title,
      color: color,
      textSize: 22,
    ),
    subtitle: TextWidget(
      text: subtitle == null ? "" : subtitle,
      color: color,
      textSize: 18,
    ),
    leading: Icon(icon),
    trailing: const Icon(IconlyLight.arrowRight2),
    onTap: () {
      onPressed();
    },
  );
}
