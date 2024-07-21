import 'package:cached_network_image/cached_network_image.dart';
import 'package:csi/services/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutDevelopersScreen extends StatefulWidget {
  const AboutDevelopersScreen({Key? key}) : super(key: key);

  @override
  State<AboutDevelopersScreen> createState() => _AboutDevelopersScreenState();
}

class _AboutDevelopersScreenState extends State<AboutDevelopersScreen> {
  String? theme;
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
                              _getDevData('Taufeeq'),
                              _getDevData('Habeeb'),
                              _getDevData('Azim'),
                              _getDevData('Abdullah'),
                              _getDevData('Rehmath'),
                              _getDevData('Iqra'),
                              _getDevData('Amatul')
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
                              var data4 = snapshot.data![3];
                              var data5 = snapshot.data![4];
                              var data6 = snapshot.data![5];
                              var data7 = snapshot.data![6];

                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const Card(
                                      child: SizedBox(
                                        width: double.maxFinite,
                                        height: 250,
                                      ),
                                    ),
                                    _buildContactCard(data1),
                                    _buildContactCard(data2),
                                    _buildContactCard(data3),
                                    _buildContactCard(data4),
                                    _buildContactCard(data5),
                                    _buildContactCard(data6),
                                    _buildContactCard(data7),
                                  ],
                                ),
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
    return Card(
      child: SizedBox(
        height: 160,
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: data['Image'],
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return ClipOval(
                      child: Container(
                        width: 120,
                        height: 120,
                        color: Theme.of(context).cardColor,
                      ),
                    );
                  },
                  // loadingBuilder: (BuildContext context, Widget child,
                  //     ImageChunkEvent? loadingProgress) {
                  //   if (loadingProgress == null) {
                  //     return child;
                  //   }
                  //   return Center(
                  //     child: CircularProgressIndicator(
                  //       value: loadingProgress.expectedTotalBytes != null
                  //           ? loadingProgress.cumulativeBytesLoaded /
                  //               loadingProgress.expectedTotalBytes!
                  //           : null,
                  //     ),
                  //   );
                  // },
                ),
              ),
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
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                      // const TextStyle(
                      //   fontSize: 24.0,
                      //   fontWeight: FontWeight.bold,
                      //   // color: Color.fromARGB(221, 255, 255, 255),
                      // ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      data['Designation'],
                      style: Theme.of(context).textTheme.titleSmall!,
                      // const TextStyle(
                      //   fontSize: 18.0,
                      //   color: Color.fromARGB(255, 130, 130, 130),
                      // ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _getDevData(String docId) async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection("Developers")
        .doc(docId)
        .get();
    return docSnapshot.data() as Map<String, dynamic>;
  }
}
