import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csi/services/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAboutScreen extends StatefulWidget {
  const UserAboutScreen({super.key});

  @override
  State<UserAboutScreen> createState() => _UserAboutScreenState();
}

class _UserAboutScreenState extends State<UserAboutScreen> {
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
                          padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(FirebaseAuth.instance.currentUser?.uid)
                                  .snapshots(),
                              builder: ((context, snapshot) {
                                if (snapshot.hasData) {
                                  return SizedBox(
                                    width: double.maxFinite,
                                    height: double.maxFinite,
                                    child: Stack(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          widthFactor: 10,
                                          heightFactor: 1,
                                          child: Card(
                                            elevation: 2,
                                            child: SizedBox(
                                              width: 300,
                                              height: 180,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Center(
                                                    child: Text(
                                                      snapshot.data!['Name'],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 170,
                                          left: 0,
                                          right: 0,
                                          child: Card(
                                            elevation: 4,
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 550,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(35.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Email',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!,
                                                      // TextStyle(
                                                      //     fontSize: 17,
                                                      //     fontWeight:
                                                      //         FontWeight.w800),
                                                    ),
                                                    Text(
                                                      snapshot.data!['Email'],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!,
                                                      // const TextStyle(
                                                      //     fontSize: 22,
                                                      //     fontWeight:
                                                      //         FontWeight
                                                      //             .w400),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Branch',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!,
                                                      //TextStyle(
                                                      // fontSize: 17,
                                                      // fontWeight:
                                                      //     FontWeight.w800),
                                                    ),
                                                    Text(
                                                      snapshot.data!['Branch'],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!,
                                                      // const TextStyle(
                                                      //     fontSize: 22,
                                                      //     fontWeight:
                                                      //         FontWeight.w400),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Roll Number',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!,
                                                      // TextStyle(
                                                      //     fontSize: 17,
                                                      //     fontWeight:
                                                      //         FontWeight.w800),
                                                    ),
                                                    Text(
                                                      snapshot.data!['Roll'],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!,
                                                      // const TextStyle(
                                                      //     fontSize: 22,
                                                      //     fontWeight:
                                                      //         FontWeight.w400),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Year',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!,
                                                      // TextStyle(
                                                      //     fontSize: 17,
                                                      //     fontWeight:
                                                      //         FontWeight.w800),
                                                    ),
                                                    Text(
                                                      snapshot.data!['Year'],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!,
                                                      // const TextStyle(
                                                      //     fontSize: 22,
                                                      //     fontWeight:
                                                      //         FontWeight.w400),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'College',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!,
                                                      // TextStyle(
                                                      //     fontSize: 17,
                                                      //     fontWeight:
                                                      //         FontWeight.w800),
                                                    ),
                                                    Text(
                                                      snapshot.data!['College'],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!,
                                                      // const TextStyle(
                                                      //     fontSize: 20,
                                                      //     fontWeight:
                                                      //         FontWeight.w400),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                } else {
                                  const Icon(Icons.watch_later_outlined);
                                  const Text("No Events");
                                }
                                return const Center(
                                    child: CircularProgressIndicator());
                              })),
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
}
