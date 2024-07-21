// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, use_build_context_synchronously

import 'package:csi/global/widgets/text_field.dart';
import 'package:csi/services/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class RegisterOld extends StatefulWidget {
  const RegisterOld({super.key});

  @override
  State<RegisterOld> createState() => _RegisterOldState();
}

class _RegisterOldState extends State<RegisterOld> {
  bool obscured = true;
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController roll = TextEditingController();
  String? branch;
  String? year;
  String? theme;
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

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("CSI"),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.chevron_left)),
        actions: [
          IconButton(
            onPressed: () async {
              Provider.of<CSIProvider>(context, listen: false).toggleTheme();
            },
            icon: Icon(theme == 'dark' ? Icons.dark_mode : Icons.light_mode),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Register',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              CustomTextInput(
                controller: name,
                keyboard: TextInputType.name,
                icon: const Icon(Icons.account_circle),
                isObscure: false,
                label: 'Name',
              ),
              CustomTextInput(
                controller: email,
                keyboard: TextInputType.emailAddress,
                icon: const Icon(Icons.email),
                isObscure: false,
                label: 'Email',
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  height: 60,
                  width: double.maxFinite,
                  child: TextField(
                    controller: password,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: obscured,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(
                              () => obscured = !obscured,
                            );
                          },
                          icon: Icon(obscured
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                        ),
                        icon: const Icon(Icons.key),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: DropdownButtonFormField(
                  value: branch,
                  focusColor: Colors.transparent,
                  decoration: InputDecoration(
                      icon: const Icon(Icons.abc),
                      labelText: 'Branch',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onChanged: (String? value) {
                    setState(() {
                      branch = value!;
                    });
                  },
                  items: branches.map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: DropdownButtonFormField(
                  value: year,
                  focusColor: Colors.transparent,
                  decoration: InputDecoration(
                      icon: const Icon(Icons.numbers),
                      labelText: 'Year',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onChanged: (String? value) {
                    setState(() {
                      year = value!;
                    });
                  },
                  items: years.map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                ),
              ),
              CustomTextInput(
                controller: roll,
                keyboard: TextInputType.number,
                icon:
                    const Icon(CupertinoIcons.rectangle_stack_person_crop_fill),
                isObscure: false,
                label: 'Roll Number',
                hint: 'Roll Number (1604 - year - branch - roll)',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Sign-in',
                      )),
                ],
              ),
              const SizedBox(
                height: 7,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (name.text == '' ||
                        email.text == '' ||
                        password.text == '' ||
                        branch == null ||
                        year == null ||
                        roll.text == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fill all fields')));
                    } else {
                      try {
                        await auth.createUserWithEmailAndPassword(
                            email: email.text, password: password.text);
                        final docRef =
                            db.collection('Users').doc(auth.currentUser?.uid);
                        docRef.set({
                          'Name': name.text,
                          'Email': email.text,
                          'Branch': branch,
                          'Roll': roll.text,
                          'Year': year,
                        });
                        FirebaseAuth.instance.currentUser
                            ?.updateDisplayName(name.text);
                        if (auth.currentUser != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('RegisterOlded')));
                          Navigator.pushReplacementNamed(context, '/user-home');
                          // final SharedPreferences preferences =
                          //     await SharedPreferences.getInstance();
                          // preferences.setString('email', email.text);
                          // preferences.setString('password', password.text);
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  style: const ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(Size(180, 60)),
                      backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.grey.shade200),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
