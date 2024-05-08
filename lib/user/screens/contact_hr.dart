import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactHR extends StatefulWidget {
  const ContactHR({Key? key});

  @override
  _ContactHRState createState() => _ContactHRState();
}

class _ContactHRState extends State<ContactHR> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Contact HR'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(2.0),
          child: FutureBuilder(
            future: Future.wait([_getHRData('Abdul Rasheed'), _getHRData('HR2')]),
            builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              var data1 = snapshot.data![0];
              var data2 = snapshot.data![1];
              return Column(
                children: [
                  _buildContactCard(data1),
                  _buildContactCard(data2),
                  const SizedBox(height: 10.0),
                  const Text(
                    "We are committed to providing prompt assistance and will respond to your query as soon as possible",
                    textAlign: TextAlign.center,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () => _openDialer(data['Ph']),
      child: Card(
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.phone,
                size: 70,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data['Name'],
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 255, 255, 255),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        data['Ph'],
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        data['Designation'],
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Color.fromARGB(255, 130, 130, 130),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _getHRData(String docId) async {
    var docSnapshot = await FirebaseFirestore.instance.collection("HR-Contact").doc(docId).get();
    return docSnapshot.data() as Map<String, dynamic>;
  }

  // void _copyToClipboard(String text, BuildContext context) {
  //   Clipboard.setData(ClipboardData(text: text));
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Copied to clipboard'),
  //     ),
  //   );
  // }

  void _openDialer(String phoneNumber) async {
    // ignore: no_leading_underscores_for_local_identifiers
    final Uri _phoneLaunchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      await launchUrl(_phoneLaunchUri);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open dialer'),
        ),
      );
    }
  }
}
