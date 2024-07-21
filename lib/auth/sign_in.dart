// ignore_for_file: unused_local_variable, prefer_const_declarations, non_constant_identifier_names, use_build_context_synchronously

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool obscured = true;
  bool remember = false;
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();
  // int attempts = 0;

  String? theme;

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final userID = auth.currentUser?.uid;
    final db = FirebaseFirestore.instance;
    final admin_email = 'admin@csi.com';
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                height: 272,
                color: const Color.fromRGBO(17, 12, 49, 1),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      Text(
                        'Sign in to your account',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  left: 20,
                  top: 50,
                  child: IconButton(
                      color: const Color.fromRGBO(17, 12, 49, 1),
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.white)),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/intro');
                      },
                      icon: const Icon(Icons.chevron_left))),
              Positioned(
                  left: 0,
                  top: 225,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(50)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 43),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Column(
                              children: [],
                            ),
                            const Text(
                              'Sign In',
                              style: TextStyle(
                                  // color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 25),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child: Text('Your Email'),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(233, 233, 242, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    height: 50,
                                    width: double.maxFinite,
                                    child: TextFormField(
                                      style:
                                          const TextStyle(color: Colors.black),
                                      controller: email,
                                      obscureText: false,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                          // hintText: 'Email',
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(15))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child: Text('Password'),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(233, 233, 242, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    height: 50,
                                    width: double.maxFinite,
                                    child: TextField(
                                      style:
                                          const TextStyle(color: Colors.black),
                                      controller: password,
                                      obscureText: obscured,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            highlightColor: Colors.transparent,
                                            onPressed: () {
                                              setState(
                                                () => obscured = !obscured,
                                              );
                                            },
                                            icon: Icon(
                                              obscured
                                                  ? Icons
                                                      .visibility_off_outlined
                                                  : Icons.visibility_outlined,
                                              color: const Color.fromRGBO(
                                                  156, 163, 200, 1),
                                            ),
                                          ),
                                          // icon: const Icon(Icons.key),
                                          // hintText: 'Password',
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(15))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                          checkColor: Theme.of(context)
                                              .primaryColorLight,
                                          overlayColor:
                                              const WidgetStatePropertyAll(
                                                  Colors.transparent),
                                          activeColor: const Color.fromRGBO(
                                              17, 12, 49, 1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          value: remember,
                                          onChanged: (value) {
                                            setState(() {
                                              remember = value!;
                                            });
                                          }),
                                      const Text('Remember Me')
                                    ],
                                  ),
                                  TextButton(
                                      style: const ButtonStyle(
                                          overlayColor: WidgetStatePropertyAll(
                                              Colors.transparent)),
                                      onPressed: () async {
                                        try {
                                          await auth
                                              .sendPasswordResetEmail(
                                                  email: email.text)
                                              .then((value) => ScaffoldMessenger
                                                      .of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Password Reset email sent'))));
                                        } on FirebaseAuthException catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      e.message.toString())));
                                        }
                                      },
                                      child: const Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                156, 163, 200, 1)),
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                if (email.text == admin_email) {
                                  try {
                                    await auth.signInWithEmailAndPassword(
                                        email: email.text,
                                        password: password.text);
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                    Navigator.of(context)
                                        .pushReplacementNamed('/admin-home');
                                    showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Text(
                                                    'Welcome back ${email.text}'),
                                              ),
                                            ));
                                  } on FirebaseAuthException catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text(e.message.toString())));
                                  }
                                } else {
                                  try {
                                    await auth.signInWithEmailAndPassword(
                                        email: email.text,
                                        password: password.text);
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                    Navigator.of(context)
                                        .pushReplacementNamed('/user-home');
                                    showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('Users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .snapshots(),
                                                    builder:
                                                        ((context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15.0),
                                                          child: FittedBox(
                                                            child: Text(
                                                                'Welcome back ${snapshot.data!['Name']}'),
                                                          ),
                                                        );
                                                      }
                                                      return const Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    })),
                                              ),
                                            ));
                                  } on FirebaseAuthException catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text(e.message.toString())));
                                  }
                                }
                                if (auth.currentUser != null) {
                                  if (remember) {
                                    preferences.setString('email', email.text);
                                    preferences.setString(
                                        'password', password.text);
                                  }
                                  await FirebaseMessaging.instance
                                      .subscribeToTopic('events');
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //     const SnackBar(
                                  //         content: Text('Signed In')));
                                }
                              },
                              style: const ButtonStyle(
                                  shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)))),
                                  minimumSize: WidgetStatePropertyAll(
                                      Size(double.maxFinite, 50)),
                                  backgroundColor: WidgetStatePropertyAll(
                                      Color.fromRGBO(17, 12, 49, 1))),
                              child: Text(
                                'Sign In',
                                style: TextStyle(color: Colors.grey.shade200),
                              ),
                            ),
                            const SizedBox(
                              height: 0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('I\'m a new user'),
                                TextButton(
                                    style: const ButtonStyle(
                                        overlayColor: WidgetStatePropertyAll(
                                            Colors.transparent)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                          context, '/register1');
                                    },
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(156, 163, 200, 1)),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
