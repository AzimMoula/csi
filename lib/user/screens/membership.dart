import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csi/services/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Membership extends StatefulWidget {
  const Membership({super.key});

  @override
  State<Membership> createState() => _MembershipState();
}

class _MembershipState extends State<Membership> {
  int index = 1;
  bool? toggle = false;
  String? theme;
  bool? member;
  final db = FirebaseFirestore.instance;
  final _razorpay = Razorpay();

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Successful: ${response.paymentId!}')));

    final docSnap = await db
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    await db
        .collection('CSI-Members')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({
      'Name': docSnap['Name'],
      'Roll': docSnap['Roll'],
      'Year': docSnap['Year'],
      'Branch': docSnap['Branch'],
    });
    setState(() {
      member = true;
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
        .collection('CSI-Members')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      return value.exists ? true : false;
    });
    setState(() {
      member = val;
    });
  }

  void openCheckout() async {
    final docSnap = await db
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    var options = {
      'key': 'rzp_test_ZQQNhUKlZCaiRD',
      'amount': 200,
      'name': 'CSI',
      'description': 'Membership',
      'prefill': {'contact': docSnap['Phone'], 'email': docSnap['Email']},
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
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: const Color.fromRGBO(17, 12, 49, 1),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(50))),
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Card(
                        child: Padding(
                            padding: const EdgeInsets.all(35.0),
                            child: !Provider.of<CSIProvider>(context,
                                        listen: false)
                                    .member
                                ? Column(
                                    children: [
                                      const FittedBox(
                                        child: Text(
                                          'Membership',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 40),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      Text(
                                        '₹350',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!,
                                      ),
                                      const SizedBox(
                                        height: 45,
                                      ),
                                      ElevatedButton(
                                          onPressed: () async {
                                            launchUrlString(
                                                'https://forms.gle/jAVgMWqVRhKZJEya9');
                                            // openCheckout();
                                          },
                                          style: const ButtonStyle(
                                              minimumSize:
                                                  WidgetStatePropertyAll(
                                                      Size(150, 50)),
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                      Colors.blue)),
                                          child: Text(
                                            'Join',
                                            style: TextStyle(
                                                color: Colors.grey.shade200),
                                          )),
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 100.0),
                                    child: FittedBox(
                                      child: Text('You are already a member',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                          // TextStyle(
                                          //     fontWeight: FontWeight.w500,
                                          //     fontSize: 20),
                                          ),
                                    ),
                                  )),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('You can join CSI to:',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.w600, fontSize: 25)
                              // TextStyle(
                              //     fontWeight: FontWeight.w600, fontSize: 25),
                              ),
                          Text(
                              '\u2022 Get Free access to CSI events through out India.',
                              style: Theme.of(context).textTheme.titleMedium!
                              // TextStyle(
                              //     fontWeight: FontWeight.w400, fontSize: 18),
                              ),
                          Text(
                              '\u2022 Get access to Exclusive Resources by CSI.',
                              style: Theme.of(context).textTheme.titleMedium!
                              // TextStyle(
                              //     fontWeight: FontWeight.w400, fontSize: 18),
                              ),
                          Text(
                              '\u2022 Get an official CSI ID card from Chennai.',
                              style: Theme.of(context).textTheme.titleMedium!
                              // TextStyle(
                              //     fontWeight: FontWeight.w400, fontSize: 18),
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
