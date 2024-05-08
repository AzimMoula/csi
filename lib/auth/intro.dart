// ignore_for_file: unused_local_variable, prefer_const_declarations, non_constant_identifier_names, use_build_context_synchronously

import 'package:csi/auth/register1.dart';
import 'package:csi/global/widgets/text_field.dart';
import 'package:csi/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  bool obscured = true;
  String? theme;

  @override
  void initState() {
    check();
    super.initState();
  }

  Future check() async {
    final auth = FirebaseAuth.instance;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? email = preferences.getString('email');
    String? password = preferences.getString('password');
    if (email == null || password == null) {
      return const Intro();
    } else {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      if (email == 'admin@csi.com') {
        Navigator.of(context).pushReplacementNamed('/admin-home');
      } else {
        Navigator.of(context).pushReplacementNamed('/user-home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final userID = auth.currentUser?.uid;
    final db = FirebaseFirestore.instance;
    final admin_email = 'admin@csi.com';
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                color: const Color.fromRGBO(17, 12, 49, 1),
                child: Container(
                  height: 450.5,
                  decoration: BoxDecoration(
                      // color: Theme.of(context).scaffoldBackgroundColor,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(50))),
                  child: Center(
                      child: Image.asset(
                          fit: BoxFit.fitHeight,
                          height: 150,
                          width: 225,
                          Theme.of(context).brightness == Brightness.light
                              ? 'assets/CSI-MJCET black.png'
                              : 'assets/CSI-MJCET white.png')),
                ),
              ),
              Positioned(
                  left: 0,
                  top: 450,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(17, 12, 49, 1),
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(50))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 43),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'Computer Society of India',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 22),
                              ),
                            ),
                            const SizedBox(
                              height: 2.5,
                            ),
                            const Center(
                              child: Text(
                                'Muffakham Jah College of Engineering and Technology',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Center(
                              child: Text(
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Venenatis tellus in metus vulputate eu scelerisque.',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.5),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/sign-in'),
                              style: const ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)))),
                                  minimumSize: MaterialStatePropertyAll(
                                      Size(double.maxFinite, 50)),
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.white)),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                    color: Color.fromRGBO(17, 12, 49, 1)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/register1'),
                              style: const ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 2.5, color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)))),
                                  minimumSize: MaterialStatePropertyAll(
                                      Size(double.maxFinite, 50)),
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color.fromRGBO(17, 12, 49, 1))),
                              child: Text(
                                'Register',
                                style: TextStyle(color: Colors.grey.shade200),
                              ),
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
