// ignore_for_file: use_build_context_synchronously, dead_code, deprecated_member_use
// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csi/admin/admin_home.dart';
import 'package:csi/main.dart';
import 'package:csi/user/user_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class EventRegister extends StatefulWidget {
  const EventRegister({super.key, required this.eventName});

  final String? eventName;
  @override
  State<EventRegister> createState() => _EventRegisterState();
}

class _EventRegisterState extends State<EventRegister> {
  int index = 1;
  bool? toggle = false;
  String? theme;
  String? name;
  bool member = false;
  final db = FirebaseFirestore.instance;
  final _razorpay = Razorpay();
  bool? status;

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Successful: ${response.paymentId!}')));
    await db
        .collection('Users')
        .doc(FirebaseAuth
            .instance.currentUser?.uid)
        .get()
        .then((value) {
      setState(() {
        name = value.data()?['Name'];
      });
    });
    final docSnap = await db
        .collection('Users')
        .doc(FirebaseAuth
            .instance.currentUser?.uid)
        .get();
    await db
        .collection(
            'Event-Registrations')
        .doc(widget.eventName)
        .collection('Registered-Users')
        .doc(FirebaseAuth
            .instance.currentUser?.uid)
        .set({
      'Name': docSnap['Name'],
      'Roll': docSnap['Roll'],
    });
    setState(() {
      status = true;
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Failure: ${response.message!}')));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('External Wallet: ${response.walletName!}')));
  }

  @override
  void initState() {
    super.initState();
    getstatus();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void getstatus() async {
    bool val = await db
        .collection('Event-Registrations')
        .doc(widget.eventName)
        .collection('Registered-Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      return value.exists ? true : false;
    });
    setState(() {
      status = val;
    });
  }

  void openCheckout() async {
    final docSnap = await db
        .collection('Users')
        .doc(FirebaseAuth
            .instance.currentUser?.uid)
        .get();
    var options = {
      'key': 'rzp_test_ZQQNhUKlZCaiRD',
      'amount': 5000,
      'name': 'CSI',
      // 'order_id': 'order_qwerty',
      'description': 'Membership',
      // 'timeout': 60,
      'prefill': {'contact': '911234567890', 'email': docSnap['Email']},
      'external': ['paytm']
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    // List<Widget> _widgetList = [
    //   widgetList[0],

    //   const Text('data'),
    //   const Text('data'),
    // ];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.chevron_left)),
            title: const Text('User View'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  if (preferences.getString('theme') == null) {
                    preferences.setString('theme', 'light');
                  } else {
                    preferences.setString(
                        'theme',
                        preferences.getString('theme') == 'light'
                            ? 'dark'
                            : 'light');
                    setState(() {
                      theme = preferences.getString('theme');
                      toggle = (theme == 'light' ? false : true);
                    });
                    MyApp.themeNotifier.value =
                        theme == 'light' ? ThemeMode.dark : ThemeMode.light;
                  }
                },
                icon:
                    Icon(theme == 'dark' ? Icons.dark_mode : Icons.light_mode),
              ),
              IconButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text('Do you want to Logout?')),
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          // final SharedPreferences preferences =
                                          //     await SharedPreferences.getInstance();
                                          await FirebaseAuth.instance.signOut();
                                          Navigator.of(context)
                                              .pushNamed('/sign-in');
                                          // preferences.remove('email');
                                          // preferences.remove('password');
                                        },
                                        child: const Text('Yes')),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('No')),
                                  ],
                                ),
                              ],
                            ));
                  },
                  icon: const Icon(Icons.logout))
            ]),
        body: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: status != null
                ? status == true
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height -
                            (4 * (AppBar().preferredSize.height)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 250,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColorLight,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: PrettyQrView.data(
                                  data:
                                      '$name paid for ${widget.eventName} ${!member ? 'by razorpay' : ''}',
                                  // decoration: const PrettyQrDecoration(
                                  // shape: PrettyQrRoundedSymbol(
                                  //     borderRadius: BorderRadius.all(Radius.zero)),
                                  // image: PrettyQrDecorationImage(
                                  //   scale: 1,
                                  //   fit: BoxFit.cover,
                                  //   position:
                                  //       PrettyQrDecorationImagePosition.background,
                                  //   image: NetworkImage(
                                  //       'https://firebasestorage.googleapis.com/v0/b/csi-app-5d154.appspot.com/o/posters%2FEvent.jpg?alt=media&token=5d20eba8-e07c-4d20-ad59-3790083bf16a'),
                                  // ),
                                  // ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(35.0),
                                  child: Column(
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          widget.eventName!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 40),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      Text(
                                        member ? 'Free' : '₹50',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!,
                                      ),
                                      const SizedBox(
                                        height: 45,
                                      ),
                                      ElevatedButton(
                                          onPressed: () async {
                                            openCheckout();
                                          },
                                          style: const ButtonStyle(
                                              minimumSize:
                                                  MaterialStatePropertyAll(
                                                      Size(150, 50)),
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.blue)),
                                          child: Text(
                                            member ? 'Join' : 'Pay',
                                            style: TextStyle(
                                                color: Colors.grey.shade200),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          const Center(child: Text('Register to get a QR')),
                        ],
                      )
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            elevation: 10,
            backgroundColor: Colors.blue,
            currentIndex: index,
            showUnselectedLabels: true,
            selectedItemColor: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.grey,
            unselectedItemColor: Colors.blue.shade800,
            onTap: (value) {
              setState(() {
                index = value;
                if (index != 1) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserHomeScreen(
                                index: index,
                              )));
                } else {
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.explore), label: 'Explore'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.chat_bubble_fill), label: 'Chats'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings'),
            ]),
      ),
    );
  }
}
