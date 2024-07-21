import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csi/services/provider.dart';
import 'package:csi/user/user_zoom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
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
  int? price;
  bool free = false;
  bool member = false;
  final db = FirebaseFirestore.instance;
  final _razorpay = Razorpay();
  bool? status;

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Successful: ${response.paymentId!}')));
    final docSnap = await db
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    await db
        .collection('Event-Registrations')
        .doc(widget.eventName)
        .collection('Registered-Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({
      'Name': docSnap['Name'],
      'Roll': docSnap['Roll'],
      'Year': docSnap['Year'],
      'Branch': docSnap['Branch'],
      'Status': member ? 'Already a member' : 'Paid',
      'uid': FirebaseAuth.instance.currentUser?.uid,
    });
    await db
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      setState(() {
        name =
            '${value.data()?['Name']}\n${value.data()?['Roll']}\n${value.data()?['Year']}\n${value.data()?['Branch']}\n${member ? 'Already a member' : 'Paid'}\n${FirebaseAuth.instance.currentUser?.uid}\n${widget.eventName}';
      });
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
    bool val1 = await db
        .collection('Event-Registrations')
        .doc(widget.eventName)
        .collection('Registered-Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      return value.exists ? true : false;
    });
    bool val2 = await db
        .collection('CSI-Members')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      return value.exists ? true : false;
    });
    DocumentSnapshot val3 =
        await db.collection('Events').doc(widget.eventName).get();

    setState(() {
      status = val1;
      member = val2;
      if (status!) paymentDone();
      price = int.parse(val3['Price']);
    });
  }

  void openCheckout(bool free) async {
    if (free) {
      final docSnap = await db
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      await db
          .collection('Event-Registrations')
          .doc(widget.eventName)
          .collection('Registered-Users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({
        'Name': docSnap['Name'],
        'Roll': docSnap['Roll'],
        'Year': docSnap['Year'],
        'Branch': docSnap['Branch'],
        'Status': member ? 'Already a member' : 'Paid',
        'uid': FirebaseAuth.instance.currentUser?.uid,
      });
      await db
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get()
          .then((value) {
        setState(() {
          name =
              '${value.data()?['Name']}\n${value.data()?['Roll']}\n${value.data()?['Year']}\n${value.data()?['Branch']}\n${member ? 'Already a member' : 'Paid'}\n${FirebaseAuth.instance.currentUser?.uid}\n${widget.eventName}';
        });
      });
      setState(() {
        status = true;
      });
    } else {
      final docSnap = await db
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      var options = {
        'key': 'rzp_test_ZQQNhUKlZCaiRD',
        'amount': price! * 100,
        'name': 'CSI',
        'description': widget.eventName,
        'prefill': {'contact': docSnap['Phone'], 'email': docSnap['Email']},
        'external': ['paytm']
      };
      try {
        _razorpay.open(options);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void paymentDone() async {
    await db
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      setState(() {
        name =
            '${value.data()?['Name']}\n${value.data()?['Roll']}\n${value.data()?['Year']}\n${value.data()?['Branch']}\n${member ? 'Already a member' : 'Paid'}\n${FirebaseAuth.instance.currentUser?.uid}\n${widget.eventName}';
      });
    });
    setState(() {
      status = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height,
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Container(
                    color: const Color.fromRGBO(17, 12, 49, 1),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(50))),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SingleChildScrollView(
                            child: status != null
                                ? status == true
                                    ? SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height -
                                                (4 *
                                                    (AppBar()
                                                        .preferredSize
                                                        .height)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Card(
                                              elevation: 25,
                                              child: Container(
                                                height: 250,
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: PrettyQrView.data(
                                                    data: '$name',
                                                    decoration:
                                                        PrettyQrDecoration(
                                                      shape:
                                                          PrettyQrSmoothSymbol(
                                                        color: Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.light
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                      // image:
                                                      //     PrettyQrDecorationImage(
                                                      //   fit: BoxFit.scaleDown,
                                                      //   position:
                                                      //       PrettyQrDecorationImagePosition
                                                      //           .embedded,
                                                      //   image: AssetImage(Theme.of(
                                                      //                   context)
                                                      //               .brightness ==
                                                      //           Brightness
                                                      //               .dark
                                                      //       ? 'assets/CSI-MJCET black.png'
                                                      //       : 'assets/CSI-MJCET white.png'),
                                                      // ),
                                                    ),
                                                  ),
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.2,
                                              child: Card(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      35.0),
                                                  child: Column(
                                                    children: [
                                                      Text(widget.eventName!,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleLarge!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)
                                                          // const TextStyle(
                                                          //     fontWeight:
                                                          //         FontWeight.w800,
                                                          //     fontSize: 40),
                                                          ),
                                                      const SizedBox(
                                                        height: 35,
                                                      ),
                                                      Text(
                                                        member || price == 0
                                                            ? 'Free'
                                                            : '₹$price',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineMedium!,
                                                      ),
                                                      const SizedBox(
                                                        height: 45,
                                                      ),
                                                      ElevatedButton(
                                                          onPressed: () async {
                                                            member || price == 0
                                                                ? openCheckout(
                                                                    true)
                                                                : openCheckout(
                                                                    false);
                                                          },
                                                          style: const ButtonStyle(
                                                              minimumSize:
                                                                  WidgetStatePropertyAll(
                                                                      Size(150,
                                                                          50)),
                                                              backgroundColor:
                                                                  WidgetStatePropertyAll(
                                                                      Colors
                                                                          .blue)),
                                                          child: Text(
                                                            member || price == 0
                                                                ? 'Join'
                                                                : 'Pay',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade200),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 120,
                                          ),
                                          Center(
                                              child: Text(
                                            'Register to get a QR',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!,
                                          )),
                                        ],
                                      )
                                : const Center(
                                    child: CircularProgressIndicator()),
                          ),
                        ))),
              ),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  const Color.fromRGBO(17, 12, 49, 1),
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor,
                ])),
                child: Container(
                    height: 100.5,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(17, 12, 49, 1),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(50))),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const BackButton(
                                color: Colors.white,
                              ),
                              Image.asset(
                                  fit: BoxFit.scaleDown,
                                  height: 50,
                                  width: 50,
                                  'assets/CSI-MJCET white.png'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    color: Colors.white,
                                    onPressed: () async {
                                      Provider.of<CSIProvider>(context,
                                              listen: false)
                                          .toggleTheme();
                                      // SharedPreferences preferences =
                                      //     await SharedPreferences.getInstance();
                                      // if (preferences.getString('theme') ==
                                      //     null) {
                                      //   preferences.setString('theme', 'light');
                                      // } else {
                                      //   final String? temp =
                                      //       preferences.getString('theme');
                                      //   preferences.setString('theme',
                                      //       temp == 'light' ? 'dark' : 'light');
                                      //   setState(() {
                                      //     theme =
                                      //         preferences.getString('theme');
                                      //   });
                                      //   MyApp.CSIProvider.value =
                                      //       theme == 'light'
                                      //           ? ThemeMode.dark
                                      //           : ThemeMode.light;
                                      // }
                                    },
                                    icon: Icon(Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Icons.dark_mode
                                        : Icons.light_mode),
                                  ),
                                  IconButton(
                                      color: Colors.white,
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: FittedBox(
                                                        child: Text(
                                                      'Do you want to Logout?',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!,
                                                    )),
                                                  ),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              final SharedPreferences
                                                                  preferences =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              await FirebaseAuth
                                                                  .instance
                                                                  .signOut();
                                                              if (!context
                                                                  .mounted) {
                                                                return;
                                                              }
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.of(
                                                                      context)
                                                                  .pushReplacementNamed(
                                                                      '/sign-in');
                                                              preferences
                                                                  .remove(
                                                                      'email');
                                                              preferences.remove(
                                                                  'password');
                                                            },
                                                            child: const Text(
                                                                'Yes')),
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'No')),
                                                      ],
                                                    ),
                                                  ],
                                                ));
                                      },
                                      icon: const Icon(Icons.logout))
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ),
            ])),
        bottomNavigationBar: BottomNavigationBar(
            elevation: 10,
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
                          builder: (context) => UserZoomDrawer(
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
                  icon: Icon(Icons.card_membership_rounded),
                  label: 'Membership'),
            ]),
      ),
    );
  }
}
