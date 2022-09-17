import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:main_jobs/consts/contss.dart';
import 'package:main_jobs/screens/auth/forget_pass.dart';
import 'package:main_jobs/screens/auth/login.dart';
import 'package:main_jobs/services/global_methods.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/RegisterScreen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formkey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  bool _obscureText = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _addressTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  //to create register Email and Password method
  void _submitFormOnRegister() async {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formkey.currentState!.save();
      setState(() {});
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        final User? user = FirebaseAuth.instance.currentUser;
        final _uid = user!.uid;
        user.updateDisplayName(_fullNameController.text);
        user.reload();
        // To save data user in firebase
        await FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id': _uid,
          'name': _fullNameController.text,
          'email': _emailTextController.text.toLowerCase(),
          'shipping-address': _addressTextController.text,
          // 'userWish': []
          //'userCart': [],
          'createAt': Timestamp.now(),
        });
        // to create errorDialog method
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {});
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {});
      } finally {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // To create RegisterScreen screen UI
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // To control with autoplay images background
          Swiper(
            duration: 800,
            autoplayDelay: 6000,
            itemBuilder: (BuildContext context, int index) {
              return Image.asset(
                // To fetch images background
                Constss.authImagesPaths[index],
                fit: BoxFit.cover,
              );
            },
            autoplay: true,
            itemCount: Constss.authImagesPaths.length,
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const SizedBox(
                  height: 10.0,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () =>
                      Navigator.canPop(context) ? Navigator.pop(context) : null,
                  child: Icon(
                    IconlyLight.arrowLeft2,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Welcome',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Sign up to shopping',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_emailFocusNode),
                        keyboardType: TextInputType.name,
                        controller: _fullNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "This Field is missing";
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Full name',
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.blue,
                          )),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.white,
                          )),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        focusNode: _emailFocusNode,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_passFocusNode),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailTextController,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains("@")) {
                            return "Please enter a valid email address";
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.blue,
                          )),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.white,
                          )),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Password
                      TextFormField(
                        focusNode: _passFocusNode,
                        obscureText: _obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passTextController,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return "Please enter a valid password";
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_addressFocusNode),
                        decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                            ),
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.white,
                            )),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        focusNode: _addressFocusNode,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: _submitFormOnRegister,
                        controller: _addressTextController,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 10) {
                            return "Please enter a valid address";
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          hintText: 'Shipping address',
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.blue,
                          )),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context,
                            routeName: ForgetPasswordScreen.routeName);
                      },
                      child: const Text(
                        'Forget password?',
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.lightBlue,
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic),
                      )),
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white30,
                    ),
                    onPressed: () {
                      _submitFormOnRegister();
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                    text: TextSpan(
                        text: 'Already a user?',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                        children: <TextSpan>[
                      TextSpan(
                          text: ' Sign in',
                          style: const TextStyle(
                              color: Colors.lightBlue, fontSize: 18),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacementNamed(
                                  context, LoginScreen.routeName);
                            })
                    ])),
              ],
            ),
          )
        ],
      ),
    );
  }
}
