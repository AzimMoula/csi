import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csi/services/provider.dart';
import 'package:csi/user/screens/explore.dart';
import 'package:csi/user/screens/home.dart';
import 'package:csi/user/screens/membership.dart';
import 'package:csi/user/user_zoom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHomeScreen extends StatefulWidget {
  final int index;
  // final ZoomDrawerController? zoomController;
  const UserHomeScreen({
    super.key,
    required this.index,
    //  this.zoomController
  });

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen>
    with TickerProviderStateMixin {
  int index = 0;
  String? theme;
  String? name;
  String? randomGreeting;
  List<String> greetings = [
    "Hello",
    "Bonjour",
    "Hola",
    "Ciao",
  ];
  @override
  void initState() {
    super.initState();
    index = widget.index;
    randomGreeting = getRandomGreeting(greetings);
    getName();
  }

  List<Widget> widgetList = [
    const UserHome(),
    const Explore(),
    const Membership(),
  ];
  String getRandomGreeting(List<String> strings) {
    final random = Random();
    int index = random.nextInt(strings.length);
    return strings[index];
  }

  Future getName() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      setState(() {
        name = value.data()?['Name'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    child: widgetList[index],
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
                                    iconColor:
                                        WidgetStatePropertyAll(Colors.white)),
                                onPressed: () =>
                                    UserZoomDrawer.drawerController.toggle!(),
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
                                                      ),
                                                    ),
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
                                  Text('$name',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
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
            currentIndex: index,
            showUnselectedLabels: true,
            selectedItemColor: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.grey,
            unselectedItemColor: Colors.blue.shade800,
            onTap: (value) {
              setState(() {
                index = value;
              });
            },
            selectedLabelStyle: GoogleFonts.poppins(),
            unselectedLabelStyle: GoogleFonts.plusJakartaSans(),
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
