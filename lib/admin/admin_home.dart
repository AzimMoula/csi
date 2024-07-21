import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csi/admin/screens/customize_event.dart';
import 'package:csi/admin/screens/events.dart';
import 'package:csi/admin/screens/memberships.dart';
import 'package:csi/admin/screens/scan_qr.dart';
import 'package:csi/services/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomeScreen extends StatefulWidget {
  final int index;

  const AdminHomeScreen({super.key, required this.index});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int index = 0;
  String? theme;
  List<String> events = [];
  List<String> queryevents = [];
  String? randomGreeting;
  List<String> greetings = [
    "Hello",
    "Bonjour",
    "Hola",
    "Ciao",
  ];
  @override
  void initState() {
    index = widget.index;
    loadEvents();
    randomGreeting = getRandomGreeting(greetings);
    super.initState();
  }

  String getRandomGreeting(List<String> strings) {
    final random = Random();
    int index = random.nextInt(strings.length);
    return strings[index];
  }

  Future<void> loadEvents() async {
    final docSnap = await FirebaseFirestore.instance.collection('Events').get();
    setState(() {
      events = docSnap.docs.map((doc) {
        return doc.id;
      }).toList();
      queryevents = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> adminWidgetList = [
      const Center(child: Text('Home')),
      Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ScanQR(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 100, horizontal: 40),
              child: Text("Open Scanner"),
            ),
          ),
        ],
      )),
      const Events(),
      const Memberships(),
      const CustomizeEvent(),
    ];
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height,
            child: Stack(children: [
              Padding(
                padding: EdgeInsets.only(top: index == 0 ? 158 : 100),
                child: Container(
                  color: const Color.fromRGBO(17, 12, 49, 1),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50))),
                    child: adminWidgetList[index],
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
                    height: index == 0 ? 158.5 : 100.5,
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
                              DrawerButton(
                                style: const ButtonStyle(
                                    iconColor: WidgetStatePropertyAll(
                                        Colors.transparent)),
                                onPressed: () {},
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
                                    tooltip: 'Change Theme',
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
                                      tooltip: 'Logout',
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: const Padding(
                                                    padding:
                                                        EdgeInsets.all(12.0),
                                                    child: FittedBox(
                                                        child: Text(
                                                            'Do you want to Logout?')),
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
                          if (index == 0)
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('$randomGreeting',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              fontSize: 16, color: Colors.white)
                                      // const TextStyle(
                                      //     color: Colors.white,
                                      //     fontWeight: FontWeight.w500,
                                      //     fontSize: 17),
                                      ),
                                  Text('Admin',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              letterSpacing: 2,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.white)
                                      // const TextStyle(
                                      //     color: Colors.white,
                                      //     fontWeight: FontWeight.bold,
                                      //     fontSize: 20),
                                      ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    )),
              ),
            ])),
        bottomNavigationBar: BottomNavigationBar(
            elevation: 10,
            // backgroundColor: Colors.blue,
            currentIndex: index,
            // showSelectedLabels: false,
            showUnselectedLabels: true,
            selectedLabelStyle: GoogleFonts.poppins(),
            unselectedLabelStyle: GoogleFonts.plusJakartaSans(),
            selectedItemColor: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.grey,
            unselectedItemColor: Colors.blue.shade800,
            onTap: (value) {
              setState(() {
                index = value;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code_2), label: 'Scan'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.table_chart), label: 'Events'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.card_membership_rounded),
                  label: 'Membership'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.event_repeat), label: 'Customize Event'),
            ]),
        floatingActionButton: FloatingActionButton(
            child: const Icon(CupertinoIcons.calendar_badge_plus),
            onPressed: () {
              Navigator.of(context).pushNamed('/create-event');
            }),
      ),
    );
  }
}
