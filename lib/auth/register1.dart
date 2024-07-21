// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, use_build_context_synchronously

import 'package:csi/auth/register2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register1 extends StatefulWidget {
  const Register1({super.key});

  @override
  State<Register1> createState() => _Register1State();
}

class _Register1State extends State<Register1> {
  bool obscured = true;
  bool terms = false;
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  String? theme;
  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
    );

    final List<String> allowedDomains = [
      'gmail.com',
      'outlook.com',
      'yahoo.com',
      'hotmail.com',
    ];

    if (!emailRegex.hasMatch(email)) {
      return false;
    }

    String domain = email.split('@').last.toLowerCase();

    if (!allowedDomains.contains(domain)) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    var branches = [
      'CIVIL',
      'MECH',
      'CSE',
      'IT',
      'AI',
      'AIDS',
      'AIML',
      'EEE',
      'ECE',
    ];
    var years = [
      'I',
      'II',
      'III',
      'IV',
    ];

    final auth = FirebaseAuth.instance;

    final db = FirebaseFirestore.instance;

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
                        'Let\'s Start',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      Text(
                        'Create an account',
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
                        Navigator.pop(context);
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
                            const Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 25),
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
                                    child: Text('Full Name'),
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
                                      controller: name,
                                      obscureText: false,
                                      keyboardType: TextInputType.name,
                                      onTap: () {
                                        if (email.text.isNotEmpty &&
                                            !isValidEmail(email.text)) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Please use your Personal Email')));
                                          email.clear();
                                        }
                                      },
                                      decoration: InputDecoration(
                                          // hintText: 'Name',
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          )),
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
                                    child: Text('Email Address'),
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
                                      onFieldSubmitted: (value) {
                                        if (!isValidEmail(value)) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Please use your Personal Email')));
                                          email.clear();
                                        }
                                      },
                                      decoration: InputDecoration(
                                        // hintText: 'Email',
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15.0, 15, 15, 0),
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
                                      onTap: () {
                                        if (email.text.isNotEmpty &&
                                            !isValidEmail(email.text)) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Please use your Personal Email')));
                                          email.clear();
                                        }
                                      },
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
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //       vertical: 5, horizontal: 5),
                            //   child: Row(
                            //     children: [
                            //       Checkbox(
                            //           checkColor:
                            //               Theme.of(context).primaryColorLight,
                            //           overlayColor:
                            //               const MaterialStatePropertyAll(
                            //                   Colors.transparent),
                            //           activeColor:
                            //               const Color.fromRGBO(17, 12, 49, 1),
                            //           shape: RoundedRectangleBorder(
                            //             borderRadius:
                            //                 BorderRadius.circular(5.0),
                            //           ),
                            //           value: terms,
                            //           onChanged: (value) {
                            //             setState(() {
                            //               terms = value!;
                            //             });
                            //           }),
                            //       const Text(
                            //         'I agree to the Terms & conditions\nand Privacy Policy',
                            //         style: TextStyle(fontSize: 11),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            const SizedBox(
                              height: 40,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (email.text.isNotEmpty &&
                                    !isValidEmail(email.text)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please use your Personal Email')));
                                  email.clear();
                                }
                                if (name.text.isEmpty ||
                                    email.text.isEmpty ||
                                    password.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Fill all fields')));
                                } else {
                                  try {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register2(
                                              name: name.text,
                                              email: email.text,
                                              password: password.text)),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
                                  }
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
                                'Continue',
                                style: TextStyle(color: Colors.grey.shade200),
                              ),
                            ),
                            const SizedBox(
                              height: 0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Already have an account?'),
                                TextButton(
                                    style: const ButtonStyle(
                                        overlayColor: WidgetStatePropertyAll(
                                            Colors.transparent)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(context, '/sign-in');
                                    },
                                    child: const Text(
                                      'Sign In',
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
