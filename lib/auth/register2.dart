// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Register2 extends StatefulWidget {
  const Register2({super.key, this.name, this.email, this.password});

  final String? name;
  final String? email;
  final String? password;
  @override
  State<Register2> createState() => _Register2State();
}

class _Register2State extends State<Register2> {
  bool obscured = true;
  bool terms = false;
  bool privacy = false;
  final TextEditingController roll = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController college = TextEditingController();
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
    TextStyle? titleStyle = Theme.of(context).textTheme.titleMedium;
    TextStyle? bodyStyle =
        Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12);
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
                height: 220,
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
              Padding(
                  padding: const EdgeInsets.only(top: 170),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(50)),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(25, 35, 25, 10),
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
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 15, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text('Branch'),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromRGBO(233, 233, 242, 1),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                            .textTheme
                                            .labelMedium,
                                        iconEnabledColor: Colors.black,
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
                                padding:
                                    const EdgeInsets.fromLTRB(15, 12, 15, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text('Year'),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromRGBO(233, 233, 242, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      height: 53,
                                      width: double.maxFinite,
                                      child: DropdownButtonFormField(
                                        selectedItemBuilder:
                                            (BuildContext context) {
                                          return years
                                              .map<Widget>((String item) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                            .textTheme
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
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 12, 15, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text('Roll Number'),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromRGBO(233, 233, 242, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      height: 53,
                                      width: double.maxFinite,
                                      child: TextFormField(
                                        style: const TextStyle(
                                            color: Colors.black),
                                        controller: roll,
                                        obscureText: false,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(signed: true),
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
                                padding:
                                    const EdgeInsets.fromLTRB(15, 12, 15, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text('Phone Number'),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromRGBO(233, 233, 242, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      height: 53,
                                      width: double.maxFinite,
                                      child: TextFormField(
                                        style: const TextStyle(
                                            color: Colors.black),
                                        controller: phone,
                                        obscureText: false,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          // hintText: 'Phone Number',
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
                                    const EdgeInsets.fromLTRB(15, 12, 15, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text('College Name'),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromRGBO(233, 233, 242, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      height: 53,
                                      width: double.maxFinite,
                                      child: TextFormField(
                                        style: const TextStyle(
                                            color: Colors.black),
                                        controller: college,
                                        obscureText: false,
                                        keyboardType:
                                            TextInputType.streetAddress,
                                        decoration: InputDecoration(
                                          // hintText: 'College Name',
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
                                            const WidgetStatePropertyAll(
                                                Colors.transparent),
                                        activeColor:
                                            const Color.fromRGBO(17, 12, 49, 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        value: terms & privacy,
                                        onChanged: (value) {
                                          setState(() {
                                            // terms = value!;
                                            if (!value! == false) {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (context) =>
                                                          Dialog.fullscreen(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    10,
                                                                    15,
                                                                    10,
                                                                    13),
                                                            child: ListView(
                                                              children: [
                                                                Text(
                                                                  'Terms and Conditions',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headlineMedium!
                                                                      .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                ),
                                                                Text(
                                                                    '\nIntroduction',
                                                                    style:
                                                                        titleStyle),
                                                                Text(
                                                                  'Welcome to CSI - MJCET. By using our app, you agree to these Terms and Conditions. Please read them carefully.',
                                                                  style:
                                                                      bodyStyle,
                                                                ),
                                                                const Text(
                                                                    '\nUse of the App'),
                                                                Text(
                                                                  'You must use the app only for lawful purposes and in accordance with these Terms and Conditions.',
                                                                  style:
                                                                      bodyStyle,
                                                                ),
                                                                const Text(
                                                                    '\nUser Accounts'),
                                                                Text(
                                                                  'You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.',
                                                                  style:
                                                                      bodyStyle,
                                                                ),
                                                                const Text(
                                                                    '\nPayments'),
                                                                Text(
                                                                  'Payments for events are processed through Razorpay. By making a payment, you agree to Razorpay\'s terms and conditions.',
                                                                  style:
                                                                      bodyStyle,
                                                                ),
                                                                const Text(
                                                                    '\nIntellectual Property'),
                                                                Text(
                                                                  'All content, features, and functionality of the app are and will remain the exclusive property of CSI - MJCET.',
                                                                  style:
                                                                      bodyStyle,
                                                                ),
                                                                const Text(
                                                                    '\nTermination'),
                                                                Text(
                                                                  'We may terminate or suspend your access to the app immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.',
                                                                  style:
                                                                      bodyStyle,
                                                                ),
                                                                const Text(
                                                                    '\nLimitation of Liability'),
                                                                Text(
                                                                  'In no event shall CSI - MJCET, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses.',
                                                                  style:
                                                                      bodyStyle,
                                                                ),
                                                                const Text(
                                                                    '\nGoverning Law'),
                                                                Text(
                                                                  'These Terms shall be governed and construed in accordance with the laws of India, without regard to its conflict of law provisions.',
                                                                  style:
                                                                      bodyStyle,
                                                                ),
                                                                const Text(
                                                                    '\nChanges to These Terms'),
                                                                Text(
                                                                  'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days\' notice prior to any new terms taking effect.',
                                                                  style:
                                                                      bodyStyle,
                                                                ),
                                                                const Text(
                                                                    '\nContact Us'),
                                                                RichText(
                                                                    text: TextSpan(
                                                                        children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'If you have any questions about these Terms, please contact us at ',
                                                                        style:
                                                                            bodyStyle,
                                                                      ),
                                                                      TextSpan(
                                                                          text:
                                                                              'csi@mjcollege.ac.in\n',
                                                                          style:
                                                                              bodyStyle.copyWith(color: const Color.fromRGBO(57, 52, 159, 1)),
                                                                          recognizer: TapGestureRecognizer()
                                                                            ..onTap = () {
                                                                              launchUrlString('mailto:csi@mjcollege.ac.in?subject=&body=');
                                                                            }),
                                                                    ])),
                                                                const SizedBox(
                                                                    height: 5),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    terms =
                                                                        true;
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder: (context) =>
                                                                            Dialog.fullscreen(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.fromLTRB(10, 15, 10, 13),
                                                                                // child: Stack(children: [
                                                                                child: ListView(
                                                                                  children: [
                                                                                    Text(
                                                                                      'Privacy Policy',
                                                                                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    Text(
                                                                                      '\nIntroduction',
                                                                                      style: titleStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      'Welcome to CSI - MJCET. We value your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and disclose your information.',
                                                                                      style: bodyStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      '\nInformation We Collect',
                                                                                      style: titleStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      'We collect the following personal information from you:',
                                                                                      style: bodyStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      '\nName',
                                                                                      style: bodyStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      'Branch',
                                                                                      style: bodyStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      'Year',
                                                                                      style: bodyStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      'College',
                                                                                      style: bodyStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      '\nHow We Use Your Information',
                                                                                      style: titleStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      'We use the information we collect to:',
                                                                                      style: bodyStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      '\nManage your account',
                                                                                      style: bodyStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      'Facilitate event registrations and payments',
                                                                                      style: bodyStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      'Communicate with you about upcoming events and updates',
                                                                                      style: bodyStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      '\nHow We Share Your Information',
                                                                                      style: titleStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      'We do not sell, trade, or otherwise transfer your personal information to outside parties, except as required to provide the services through Razorpay for payment processing.',
                                                                                      style: bodyStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      '\nSecurity of Your Information',
                                                                                      style: titleStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      'We implement a variety of security measures to maintain the safety of your personal information. However, no method of transmission over the Internet or method of electronic storage is 100% secure, so we cannot guarantee its absolute security.',
                                                                                      style: bodyStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      '\nYour Consent',
                                                                                      style: titleStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      'By using our app, you consent to our Privacy Policy.',
                                                                                      style: bodyStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      '\nChanges to Our Privacy Policy',
                                                                                      style: titleStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.',
                                                                                      style: bodyStyle,
                                                                                    ),
                                                                                    Text(
                                                                                      '\nContact Us',
                                                                                      style: titleStyle,
                                                                                    ),
                                                                                    RichText(
                                                                                        text: TextSpan(children: [
                                                                                      TextSpan(
                                                                                        text: 'If you have any questions about this Privacy Policy, please contact us at ',
                                                                                        style: bodyStyle,
                                                                                      ),
                                                                                      TextSpan(
                                                                                          text: 'csi@mjcollege.ac.in\n',
                                                                                          style: bodyStyle.copyWith(color: const Color.fromRGBO(57, 52, 159, 1)),
                                                                                          recognizer: TapGestureRecognizer()
                                                                                            ..onTap = () {
                                                                                              launchUrlString('mailto:csi@mjcollege.ac.in?subject=&body=');
                                                                                            }),
                                                                                    ])),
                                                                                    const SizedBox(height: 5),
                                                                                    ElevatedButton(
                                                                                      onPressed: () {
                                                                                        privacy = true;
                                                                                        Navigator.pop(context);
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      style: const ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)))), minimumSize: WidgetStatePropertyAll(Size(double.maxFinite, 50)), backgroundColor: WidgetStatePropertyAll(Color.fromRGBO(17, 12, 49, 1))),
                                                                                      child: Text(
                                                                                        'Accept and Continue',
                                                                                        style: TextStyle(color: Colors.grey.shade200),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                // Align(
                                                                                //   alignment: Alignment.bottomCenter,
                                                                                //   child: ElevatedButton(
                                                                                //     onPressed: () {
                                                                                //       privacy = true;
                                                                                //       Navigator.pop(context);
                                                                                //       Navigator.pop(context);
                                                                                //     },
                                                                                //     style: const ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)))), minimumSize: WidgetStatePropertyAll(Size(double.maxFinite, 50)), backgroundColor: WidgetStatePropertyAll(Color.fromRGBO(17, 12, 49, 1))),
                                                                                //     child: Text(
                                                                                //       'Accept and Continue',
                                                                                //       style: TextStyle(color: Colors.grey.shade200),
                                                                                //     ),
                                                                                //   ),
                                                                                // )
                                                                                // ]),
                                                                              ),
                                                                            ));
                                                                  },
                                                                  style: const ButtonStyle(
                                                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              15)))),
                                                                      minimumSize: WidgetStatePropertyAll(Size(
                                                                          double
                                                                              .maxFinite,
                                                                          50)),
                                                                      backgroundColor:
                                                                          WidgetStatePropertyAll(Color.fromRGBO(
                                                                              17,
                                                                              12,
                                                                              49,
                                                                              1))),
                                                                  child: Text(
                                                                    'Accept and Continue',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade200),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )));
                                            } else {
                                              terms = false;
                                              privacy = false;
                                            }
                                          });
                                        }),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'I agree to the ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(fontSize: 11),
                                          ),
                                          TextSpan(
                                            text: 'Terms & conditions',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: const Color.fromRGBO(
                                                        156, 163, 200, 1),
                                                    fontSize: 11),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (context) =>
                                                            Dialog.fullscreen(
                                                                child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      10,
                                                                      15,
                                                                      10,
                                                                      13),
                                                              child: ListView(
                                                                children: [
                                                                  Text(
                                                                    'Terms and Conditions',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headlineMedium!
                                                                        .copyWith(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                      '\nIntroduction',
                                                                      style:
                                                                          titleStyle),
                                                                  Text(
                                                                    'Welcome to CSI - MJCET. By using our app, you agree to these Terms and Conditions. Please read them carefully.',
                                                                    style:
                                                                        bodyStyle,
                                                                  ),
                                                                  const Text(
                                                                      '\nUse of the App'),
                                                                  Text(
                                                                    'You must use the app only for lawful purposes and in accordance with these Terms and Conditions.',
                                                                    style:
                                                                        bodyStyle,
                                                                  ),
                                                                  const Text(
                                                                      '\nUser Accounts'),
                                                                  Text(
                                                                    'You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.',
                                                                    style:
                                                                        bodyStyle,
                                                                  ),
                                                                  const Text(
                                                                      '\nPayments'),
                                                                  Text(
                                                                    'Payments for events are processed through Razorpay. By making a payment, you agree to Razorpay\'s terms and conditions.',
                                                                    style:
                                                                        bodyStyle,
                                                                  ),
                                                                  const Text(
                                                                      '\nIntellectual Property'),
                                                                  Text(
                                                                    'All content, features, and functionality of the app are and will remain the exclusive property of CSI - MJCET.',
                                                                    style:
                                                                        bodyStyle,
                                                                  ),
                                                                  const Text(
                                                                      '\nTermination'),
                                                                  Text(
                                                                    'We may terminate or suspend your access to the app immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.',
                                                                    style:
                                                                        bodyStyle,
                                                                  ),
                                                                  const Text(
                                                                      '\nLimitation of Liability'),
                                                                  Text(
                                                                    'In no event shall CSI - MJCET, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses.',
                                                                    style:
                                                                        bodyStyle,
                                                                  ),
                                                                  const Text(
                                                                      '\nGoverning Law'),
                                                                  Text(
                                                                    'These Terms shall be governed and construed in accordance with the laws of India, without regard to its conflict of law provisions.',
                                                                    style:
                                                                        bodyStyle,
                                                                  ),
                                                                  const Text(
                                                                      '\nChanges to These Terms'),
                                                                  Text(
                                                                    'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days\' notice prior to any new terms taking effect.',
                                                                    style:
                                                                        bodyStyle,
                                                                  ),
                                                                  const Text(
                                                                      '\nContact Us'),
                                                                  RichText(
                                                                      text: TextSpan(
                                                                          children: [
                                                                        TextSpan(
                                                                          text:
                                                                              'If you have any questions about these Terms, please contact us at ',
                                                                          style:
                                                                              bodyStyle,
                                                                        ),
                                                                        TextSpan(
                                                                            text:
                                                                                'csi@mjcollege.ac.in\n',
                                                                            style:
                                                                                bodyStyle.copyWith(color: const Color.fromRGBO(57, 52, 159, 1)),
                                                                            recognizer: TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                launchUrlString('mailto:csi@mjcollege.ac.in?subject=&body=');
                                                                              }),
                                                                      ])),
                                                                  const SizedBox(
                                                                      height:
                                                                          5),
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      terms =
                                                                          true;
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    style: const ButtonStyle(
                                                                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.all(Radius.circular(
                                                                                15)))),
                                                                        minimumSize: WidgetStatePropertyAll(Size(
                                                                            double
                                                                                .maxFinite,
                                                                            50)),
                                                                        backgroundColor: WidgetStatePropertyAll(Color.fromRGBO(
                                                                            17,
                                                                            12,
                                                                            49,
                                                                            1))),
                                                                    child: Text(
                                                                      'Accept and Continue',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade200),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            )));
                                              },
                                          ),
                                          TextSpan(
                                            text: '\nand ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(fontSize: 11),
                                          ),
                                          TextSpan(
                                            text: 'Privacy Policy',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: const Color.fromRGBO(
                                                        156, 163, 200, 1),
                                                    fontSize: 11),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (context) =>
                                                            Dialog.fullscreen(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        10,
                                                                        15,
                                                                        10,
                                                                        13),
                                                                child: ListView(
                                                                  children: [
                                                                    Text(
                                                                      'Privacy Policy',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headlineMedium!
                                                                          .copyWith(
                                                                              fontWeight: FontWeight.bold),
                                                                    ),
                                                                    Text(
                                                                      '\nIntroduction',
                                                                      style:
                                                                          titleStyle,
                                                                    ),
                                                                    Text(
                                                                      'Welcome to CSI - MJCET. We value your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and disclose your information.',
                                                                      style:
                                                                          bodyStyle,
                                                                    ),
                                                                    Text(
                                                                      '\nInformation We Collect',
                                                                      style:
                                                                          titleStyle,
                                                                    ),
                                                                    Text(
                                                                      'We collect the following personal information from you:',
                                                                      style:
                                                                          bodyStyle,
                                                                    ),
                                                                    Text(
                                                                      '\nName',
                                                                      style:
                                                                          bodyStyle,
                                                                    ),
                                                                    Text(
                                                                      'Branch',
                                                                      style:
                                                                          bodyStyle,
                                                                    ),
                                                                    Text(
                                                                      'Year',
                                                                      style:
                                                                          bodyStyle,
                                                                    ),
                                                                    Text(
                                                                      'College',
                                                                      style:
                                                                          bodyStyle,
                                                                    ),
                                                                    Text(
                                                                      '\nHow We Use Your Information',
                                                                      style:
                                                                          titleStyle,
                                                                    ),
                                                                    Text(
                                                                      'We use the information we collect to:',
                                                                      style:
                                                                          bodyStyle,
                                                                    ),
                                                                    Text(
                                                                      '\nManage your account',
                                                                      style:
                                                                          bodyStyle,
                                                                    ),
                                                                    Text(
                                                                      'Facilitate event registrations and payments',
                                                                      style:
                                                                          bodyStyle,
                                                                    ),
                                                                    Text(
                                                                      'Communicate with you about upcoming events and updates',
                                                                      style:
                                                                          bodyStyle,
                                                                    ),
                                                                    Text(
                                                                      '\nHow We Share Your Information',
                                                                      style:
                                                                          titleStyle,
                                                                    ),
                                                                    Text(
                                                                      'We do not sell, trade, or otherwise transfer your personal information to outside parties, except as required to provide the services through Razorpay for payment processing.',
                                                                      style:
                                                                          bodyStyle,
                                                                    ),
                                                                    Text(
                                                                      '\nSecurity of Your Information',
                                                                      style:
                                                                          titleStyle,
                                                                    ),
                                                                    Text(
                                                                      'We implement a variety of security measures to maintain the safety of your personal information. However, no method of transmission over the Internet or method of electronic storage is 100% secure, so we cannot guarantee its absolute security.',
                                                                      style:
                                                                          bodyStyle,
                                                                    ),
                                                                    Text(
                                                                      '\nYour Consent',
                                                                      style:
                                                                          titleStyle,
                                                                    ),
                                                                    Text(
                                                                      'By using our app, you consent to our Privacy Policy.',
                                                                      style:
                                                                          bodyStyle,
                                                                    ),
                                                                    Text(
                                                                      '\nChanges to Our Privacy Policy',
                                                                      style:
                                                                          titleStyle,
                                                                    ),
                                                                    Text(
                                                                      'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.',
                                                                      style:
                                                                          bodyStyle,
                                                                    ),
                                                                    Text(
                                                                      '\nContact Us',
                                                                      style:
                                                                          titleStyle,
                                                                    ),
                                                                    RichText(
                                                                        text: TextSpan(
                                                                            children: [
                                                                          TextSpan(
                                                                            text:
                                                                                'If you have any questions about this Privacy Policy, please contact us at ',
                                                                            style:
                                                                                bodyStyle,
                                                                          ),
                                                                          TextSpan(
                                                                              text: 'csi@mjcollege.ac.in\n',
                                                                              style: bodyStyle.copyWith(color: const Color.fromRGBO(57, 52, 159, 1)),
                                                                              recognizer: TapGestureRecognizer()
                                                                                ..onTap = () {
                                                                                  launchUrlString('mailto:csi@mjcollege.ac.in?subject=&body=');
                                                                                }),
                                                                        ])),
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        privacy =
                                                                            true;
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      style: const ButtonStyle(
                                                                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(
                                                                                  15)))),
                                                                          minimumSize: WidgetStatePropertyAll(Size(
                                                                              double
                                                                                  .maxFinite,
                                                                              50)),
                                                                          backgroundColor: WidgetStatePropertyAll(Color.fromRGBO(
                                                                              17,
                                                                              12,
                                                                              49,
                                                                              1))),
                                                                      child:
                                                                          Text(
                                                                        'Accept and Continue',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.grey.shade200),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ));
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                    // const Text(
                                    //   'I agree to the Terms & conditions\nand Privacy Policy',
                                    //   style: TextStyle(fontSize: 11),
                                    // )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (branch == null ||
                                      year == null ||
                                      roll.text.isEmpty ||
                                      phone.text.isEmpty ||
                                      college.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Fill all fields')));
                                  } else {
                                    await auth.createUserWithEmailAndPassword(
                                        email: widget.email!,
                                        password: widget.password!);
                                    await auth.signInWithEmailAndPassword(
                                        email: widget.email!,
                                        password: widget.password!);
                                    final docRef = db
                                        .collection('Users')
                                        .doc(auth.currentUser?.uid);
                                    docRef.set({
                                      'Name': widget.name,
                                      'Email': widget.email,
                                    });
                                    FirebaseAuth.instance.currentUser
                                        ?.updateDisplayName(widget.name);
                                    if (terms & privacy) {
                                      try {
                                        final docRef = db
                                            .collection('Users')
                                            .doc(auth.currentUser?.uid);
                                        docRef.update({
                                          'Branch': branch,
                                          'Roll': roll.text,
                                          'Year': year,
                                          'Phone': '91${phone.text}',
                                          'College': college.text
                                        });
                                        if (auth.currentUser != null) {
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(const SnackBar(
                                          //         content: Text('Registered')));
                                          Navigator.of(context).popUntil(
                                              (route) => route.isFirst);
                                          Navigator.pushReplacementNamed(
                                              context, '/onboarding');
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(e.toString())));
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Accept the Terms and Conditions')));
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
                                  'Sign Up',
                                  style: TextStyle(color: Colors.grey.shade200),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
