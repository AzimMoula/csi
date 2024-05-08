// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, use_build_context_synchronously

import 'package:csi/auth/sign_in.dart';
import 'package:csi/global/widgets/text_field.dart';
import 'package:csi/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register2 extends StatefulWidget {
  const Register2({super.key});

  @override
  State<Register2> createState() => _Register2State();
}

class _Register2State extends State<Register2> {
  bool obscured = true;
  bool terms = false;
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController roll = TextEditingController();
  String? branch;
  String? year;
  String? theme;
  @override
  Widget build(BuildContext context) {
    List<String> branches = [
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
    List<String> years = [
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
                              MaterialStatePropertyAll(Colors.white)),
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
                                    child: Text('Branch'),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(233, 233, 242, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    height: 53,
                                    width: double.maxFinite,
                                    child: DropdownButtonFormField(
                                      selectedItemBuilder:
                                          (BuildContext context) {
                                        return branches
                                            .map<Widget>((String item) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              item,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark),
                                            ),
                                          );
                                        }).toList();
                                      },
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .labelMedium,
                                      iconEnabledColor:
                                          Theme.of(context).primaryColorDark,
                                      value: branch,
                                      focusColor: Colors.transparent,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(15))),
                                      onChanged: (String? value) {
                                        setState(() {
                                          branch = value!;
                                        });
                                      },
                                      items: branches.map((String item) {
                                        return DropdownMenuItem(
                                          value: item,
                                          child: Text(
                                            item,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child: Text('Year'),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(233, 233, 242, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    height: 53,
                                    width: double.maxFinite,
                                    child: DropdownButtonFormField(
                                      selectedItemBuilder:
                                          (BuildContext context) {
                                        return years.map<Widget>((String item) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          );
                                        }).toList();
                                      },
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .labelMedium,
                                      iconEnabledColor: Colors.black,
                                      value: year,
                                      focusColor: Colors.transparent,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(15))),
                                      onChanged: (String? value) {
                                        setState(() {
                                          year = value!;
                                        });
                                      },
                                      items: years.map((String item) {
                                        return DropdownMenuItem(
                                          value: item,
                                          child: Text(
                                            item,
                                            // style: Theme.of(context)
                                            //     .primaryTextTheme
                                            //     .labelMedium,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child: Text('Roll Number'),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(233, 233, 242, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    height: 53,
                                    width: double.maxFinite,
                                    child: TextFormField(
                                      style:
                                          const TextStyle(color: Colors.black),
                                      controller: roll,
                                      obscureText: false,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        // hintText: 'Roll Number',
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Row(
                                children: [
                                  Checkbox(
                                      checkColor: const Color.fromRGBO(
                                          233, 233, 242, 1),
                                      overlayColor:
                                          const MaterialStatePropertyAll(
                                              Colors.transparent),
                                      activeColor:
                                          const Color.fromRGBO(17, 12, 49, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      value: terms,
                                      onChanged: (value) {
                                        setState(() {
                                          terms = value!;
                                        });
                                      }),
                                  const Text(
                                    'I agree to the Terms & conditions\nand Privacy Policy',
                                    style: TextStyle(fontSize: 11),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (branch == null ||
                                    year == null ||
                                    roll.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Fill all fields')));
                                } else {
                                  if (terms) {
                                    try {
                                      final docRef = db
                                          .collection('Users')
                                          .doc(auth.currentUser?.uid);
                                      docRef.update({
                                        'Branch': branch,
                                        'Roll': roll.text,
                                        'Year': year,
                                      });
                                      if (auth.currentUser != null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text('Registered')));
                                        Navigator.pushReplacementNamed(
                                            context, '/user-home');
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(e.toString())));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Accept the Terms and Conditions')));
                                  }
                                }
                              },
                              style: const ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)))),
                                  minimumSize: MaterialStatePropertyAll(
                                      Size(double.maxFinite, 50)),
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color.fromRGBO(17, 12, 49, 1))),
                              child: Text(
                                'Sign Up',
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
