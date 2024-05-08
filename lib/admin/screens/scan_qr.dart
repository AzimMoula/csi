// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class ScanQR extends StatefulWidget {
  const ScanQR({Key? key}) : super(key: key);

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  String? code;
  String? name;
  String? status;
  // final String save;

  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore firestore=FirebaseFirestore.instance;
    
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                  context: context,
                  onCode: (code) {
                    setState(() {
                      this.code = code;
                      name =code!.split("\n").first;
                      status =code.split("\n")[4];

                       {
                        
                        FirebaseFirestore.instance
                        .collection("Event-Registrations")
                        .doc("AI-FINITY")
                        .collection("Registered-Users")
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .set({
                                  'Name' : code.split("\n").first,
                                  'Roll' : code.split("\n")[1],
                                  'Year' : code.split("\n")[2],
                                  'Branch' : code.split("\n")[3],
                                  'Status' : code.split("\n")[4],
                        });
}
                    });
                  },
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 100, horizontal: 40),
                child: Text("Open Scanner"),
              ),
            ),
            const SizedBox(
              height: 80,
            ), // Add spacing between the button and the text
            Text(
              name ?? "",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              status ?? "",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    ));

  }
}
