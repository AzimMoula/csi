import 'package:csi/services/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactHR extends StatefulWidget {
  const ContactHR({super.key});

  @override
  State<ContactHR> createState() => _ContactHRState();
}

class _ContactHRState extends State<ContactHR> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height,
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Container(
                      color: const Color.fromRGBO(17, 12, 49, 1),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(50))),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: FutureBuilder(
                            future: Future.wait([
                              _getHRData('HR1'),
                              _getHRData('HR2'),
                              _getHRData('HR3')
                            ]),
                            builder: (context,
                                AsyncSnapshot<List<Map<String, dynamic>>>
                                    snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
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
                              var data3 = snapshot.data![2];
                              return Column(
                                children: [
                                  _buildContactCard(data1),
                                  _buildContactCard(data2),
                                  _buildContactCard(data3),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    "We are committed to providing prompt assistance and will respond to your query as soon as possible",
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.titleSmall!,
                                    textScaler: const TextScaler.linear(0.9),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        icon: Icon(
                                            Theme.of(context).brightness ==
                                                    Brightness.light
                                                ? Icons.dark_mode
                                                : Icons.light_mode),
                                      ),
                                      IconButton(
                                          color: Colors.white,
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: FittedBox(
                                                            child: Text(
                                                          'Do you want to Logout?',
                                                          style:
                                                              Theme.of(context)
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
                                                                  preferences
                                                                      .remove(
                                                                          'password');
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Yes')),
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
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
                ]))));
  }

  Widget _buildContactCard(Map<String, dynamic> data) {
    // return Padding(
    //   padding: const EdgeInsets.symmetric(vertical: 5.0),
    //   child: ListTile(
    //     onTap: () => _openDialer(data['Phone']),
    //     onLongPress: () => _copyToClipboard(data['Phone']),
    //     leading: const Icon(
    //       Icons.phone,
    //       size: 25,
    //     ),
    //     title: Text(
    //       data['Name'],
    //       style: const TextStyle(
    //         fontSize: 14.0,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     subtitle: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         const SizedBox(height: 8.0),
    //         Text(
    //           data['Phone'],
    //           style: const TextStyle(
    //             fontSize: 12.0,
    //           ),
    //         ),
    //         const SizedBox(height: 4.0),
    //         Text(
    //           data['Designation'],
    //           style: const TextStyle(
    //             fontSize: 12.0,
    //             color: Color.fromARGB(255, 130, 130, 130),
    //           ),
    //         ),
    //       ],
    //     ),
    //     isThreeLine: true,
    //   ),
    // );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: () => _openDialer(data['Phone']),
        onLongPress: () => _copyToClipboard(data['Phone']),
        child: Card(
          child: SizedBox(
            height: 110,
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 10, 0),
                  child: Icon(
                    Icons.phone,
                    size: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data['Name'],
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                        // const TextStyle(
                        //   fontSize: 14.0,
                        //   fontWeight: FontWeight.bold,
                        // ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        data['Phone'],
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            // color: const Color.fromARGB(255, 130, 130, 130),
                            ),
                        // const TextStyle(
                        //   fontSize: 12.0,
                        // ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        data['Designation'],
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            // color: const Color.fromARGB(255, 130, 130, 130),
                            ),
                        // const TextStyle(
                        //   fontSize: 12.0,
                        //   color: Color.fromARGB(255, 130, 130, 130),
                        // ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _getHRData(String docId) async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection("HR-Contact")
        .doc(docId)
        .get();
    return docSnapshot.data() as Map<String, dynamic>;
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
      ),
    );
  }

  void _openDialer(String phoneNumber) async {
    final Uri phoneLaunchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      await launchUrl(phoneLaunchUri);
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
