// ignore_for_file: unused_local_variable, prefer_const_declarations, non_constant_identifier_names, use_build_context_synchronously

import 'package:csi/auth/register1.dart';
import 'package:csi/global/widgets/text_field.dart';
import 'package:csi/services/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class SignInOld extends StatefulWidget {
  const SignInOld({super.key});

  @override
  State<SignInOld> createState() => _SignInOldState();
}

class _SignInOldState extends State<SignInOld> {
  bool obscured = true;
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();
  int attempts = 0;

  String? theme;

  // @override
  // void initState() {
  //   // check();
  //   super.initState();
  // }

  // Future check() async {
  //   final auth = FirebaseAuth.instance;
  //   final SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String? email = preferences.getString('email');
  //   String? password = preferences.getString('password');
  //   if (email == null || password == null) {
  //     return const SignInOld();
  //   } else {
  //     await auth.signInOldWithEmailAndPassword(email: email, password: password);
  //     if (email == 'admin@csi.com') {
  //       Navigator.of(context).pushReplacementNamed('/admin-home');
  //     } else {
  //       Navigator.of(context).pushReplacementNamed('/user-home');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final userID = auth.currentUser?.uid;
    final db = FirebaseFirestore.instance;
    final admin_email = 'admin@csi.com';
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("CSI"),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
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
          padding: const EdgeInsets.all(15.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  const Text(
                    'Sign-in',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
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
                        obscureText: obscured,
                        keyboardType: TextInputType.visiblePassword,
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
                  if (attempts > 1)
                    TextButton(
                        onPressed: () async {
                          try {
                            await auth
                                .sendPasswordResetEmail(email: email.text)
                                .then((value) => ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Password Reset email sent'))));
                          } on FirebaseAuthException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.message.toString())));
                          }
                        },
                        child: const Text('Forgot Password')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Register1()));
                          },
                          child: const Text(
                            'Register',
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        // final SharedPreferences preferences =
                        //     await SharedPreferences.getInstance();
                        if (email.text == admin_email) {
                          try {
                            await auth.signInWithEmailAndPassword(
                                email: email.text, password: password.text);
                            Navigator.of(context)
                                .pushReplacementNamed('/admin-home');
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child:
                                            Text('Welcome back ${email.text}'),
                                      ),
                                    ));
                            // preferences.setString('email', email.text);
                            // preferences.setString('password', password.text);
                          } on FirebaseAuthException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.message.toString())));
                          }
                        } else {
                          try {
                            await auth.signInWithEmailAndPassword(
                                email: email.text, password: password.text);
                            Navigator.of(context)
                                .pushReplacementNamed('/user-home');
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('Users')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser?.uid)
                                                .snapshots(),
                                            builder: ((context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
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
                                        // Text('Welcome back ${email.text}'),
                                      ),
                                    ));
                            // preferences.setString('email', email.text);
                            // preferences.setString('password', password.text);
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              attempts++;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.message.toString())));
                          }
                        }
                        if (auth.currentUser != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Signed In')));
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
        ),
      ),
    ));
  }
}
