// ignore_for_file: use_build_context_synchronously
// import 'dart:ffi';

import 'package:csi/services/provider.dart';
import 'package:csi/user/screens/event_register.dart';
import 'package:csi/user/user_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutEvent extends StatefulWidget {
  const AboutEvent({
    super.key,
    required this.name,
    required this.date,
    required this.time,
    required this.location,
    required this.url,
    this.index,
    required this.description,
  });

  final String? name;
  final String? date;
  final String? time;
  final String? location;
  final String? url;
  final int? index;
  final String? description;

  @override
  State<AboutEvent> createState() => _AboutEventState();
}

class _AboutEventState extends State<AboutEvent> {
  int index = 1;
  String? theme;
  @override
  void initState() {
    super.initState();
    index = widget.index ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    // List<Widget> _widgetList = [
    //   widgetList[0],

    // CustomScrollView(
    //   controller: ScrollController(initialScrollOffset: 300),
    //   slivers: <Widget>[
    //     SliverAppBar(
    //         automaticallyImplyLeading: false,
    //         expandedHeight: 575.0,
    //         flexibleSpace: Stack(
    //           children: [
    //             widget.url != null
    //                 ? Positioned(
    //                     left: 0,
    //                     right: 0,
    //                     child: Image.network(
    //                       widget.url!,
    //                       width: double.maxFinite,
    //                       height: 575,
    //                       fit: BoxFit.scaleDown,
    //                     ),
    //                   )
    //                 : const LinearProgressIndicator(),
    //           ],
    //         )),
    //     SliverList(
    //       // itemExtent: 50.0,
    //       delegate: SliverChildBuilderDelegate(
    //         childCount: 1,
    //         (BuildContext context, int index) {
    //           return Container(
    //             alignment: Alignment.center,
    //             clipBehavior: Clip.hardEdge,
    //             decoration: BoxDecoration(
    //                 color: Colors.transparent,
    //                 borderRadius: const BorderRadius.only(
    //                   topLeft: Radius.circular(20),
    //                   topRight: Radius.circular(20),
    //                 ),
    //                 border: Border.all(width: 5, color: Colors.transparent)),
    //             // color: Colors.lightBlue[100 * (index % 9)],
    //             child: Padding(
    //               padding: const EdgeInsets.all(25.0),
    //               child: Column(
    //                 children: [
    //                   Align(
    //                     alignment: Alignment.topLeft,
    //                     child: Text(
    //                       widget.name!,
    //                       style: Theme.of(context)
    //                           .textTheme
    //                           .headlineLarge!
    //                           .copyWith(fontWeight: FontWeight.w800),
    //                     ),
    //                   ),
    //                   const SizedBox(
    //                     height: 45,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           const Text(
    //                             'Date',
    //                             style: TextStyle(
    //                                 fontSize: 15,
    //                                 fontWeight: FontWeight.w700),
    //                           ),
    //                           Text(
    //                             widget.date!,
    //                             style: const TextStyle(
    //                                 fontSize: 20,
    //                                 fontWeight: FontWeight.w400),
    //                           ),
    //                         ],
    //                       ),
    //                       Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           const Text('Time',
    //                               style: TextStyle(
    //                                   fontSize: 15,
    //                                   fontWeight: FontWeight.w700)),
    //                           Text(widget.time!,
    //                               style: const TextStyle(
    //                                   fontSize: 20,
    //                                   fontWeight: FontWeight.w400)),
    //                         ],
    //                       ),
    //                     ],
    //                   ),
    //                   const SizedBox(
    //                     height: 45,
    //                   ),
    //                   Align(
    //                     alignment: Alignment.centerLeft,
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         const Text('Location',
    //                             style: TextStyle(
    //                                 fontSize: 15,
    //                                 fontWeight: FontWeight.w700)),
    //                         Text(widget.location!,
    //                             style: const TextStyle(
    //                                 fontSize: 20,
    //                                 fontWeight: FontWeight.w400)),
    //                       ],
    //                     ),
    //                   ),
    //                   const SizedBox(
    //                     height: 30,
    //                   ),
    //                   ElevatedButton(
    //                       onPressed: () {},
    //                       style: const ButtonStyle(
    //                           minimumSize:
    //                               MaterialStatePropertyAll(Size(150, 50)),
    //                           backgroundColor:
    //                               MaterialStatePropertyAll(Colors.blue)),
    //                       child: Text(
    //                         'Register',
    //                         style: TextStyle(color: Colors.grey.shade200),
    //                       )),
    //                 ],
    //               ),
    //             ),
    //           );
    //         },
    //       ),
    //     ),
    //   ],
    // ),

    //   Stack(
    //     children: [
    //       Positioned(
    //         left: 0,
    //         right: 0,
    //         child: SizedBox(
    //           height: 575,
    //           child: Image.network(
    //             widget.url!,
    //             loadingBuilder: (BuildContext context, Widget child,
    //                 ImageChunkEvent? loadingProgress) {
    //               if (loadingProgress == null) {
    //                 return child;
    //               }
    //               return Center(
    //                 child: LinearProgressIndicator(
    //                   value: loadingProgress.expectedTotalBytes != null
    //                       ? loadingProgress.cumulativeBytesLoaded /
    //                           loadingProgress.expectedTotalBytes!
    //                       : null,
    //                 ),
    //               );
    //             },
    //           ),
    //         ),
    //       ),
    //       Positioned(
    //         top: 350,
    //         child: Container(
    //           width: MediaQuery.of(context).size.width,
    //           height: 500,
    //           decoration: BoxDecoration(
    //               color: Theme.of(context).scaffoldBackgroundColor,
    //               borderRadius: const BorderRadius.only(
    //                 topLeft: Radius.circular(20),
    //                 topRight: Radius.circular(20),
    //               )),
    //           child: Padding(
    //             padding: const EdgeInsets.all(25.0),
    //             child: Column(
    //               children: [
    //                 Align(
    //                   alignment: Alignment.topLeft,
    //                   child: Text(
    //                     widget.name!,
    //                     style: Theme.of(context)
    //                         .textTheme
    //                         .headlineLarge!
    //                         .copyWith(fontWeight: FontWeight.w800),
    //                   ),
    //                 ),
    //                 const SizedBox(
    //                   height: 40,
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         const Text(
    //                           'Date',
    //                           style: TextStyle(
    //                               fontSize: 15, fontWeight: FontWeight.w700),
    //                         ),
    //                         Text(
    //                           widget.date!,
    //                           style: const TextStyle(
    //                               fontSize: 20, fontWeight: FontWeight.w400),
    //                         ),
    //                       ],
    //                     ),
    //                     Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         const Text('Time',
    //                             style: TextStyle(
    //                                 fontSize: 15, fontWeight: FontWeight.w700)),
    //                         Text(widget.time!,
    //                             style: const TextStyle(
    //                                 fontSize: 20, fontWeight: FontWeight.w400)),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //                 const SizedBox(
    //                   height: 35,
    //                 ),
    //                 Align(
    //                   alignment: Alignment.centerLeft,
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       const Text('Location',
    //                           style: TextStyle(
    //                               fontSize: 15, fontWeight: FontWeight.w700)),
    //                       Text(widget.location!,
    //                           style: const TextStyle(
    //                               fontSize: 20, fontWeight: FontWeight.w400)),
    //                     ],
    //                   ),
    //                 ),
    //                 const SizedBox(
    //                   height: 35,
    //                 ),
    //                 ElevatedButton(
    //                     onPressed: () => Navigator.push(
    //                         context,
    //                         CupertinoPageRoute(
    //                             builder: (_) =>
    //                                 EventRegister(eventName: widget.name))),
    //                     // Navigator.pushNamed(context, '/event-register'),
    //                     style: const ButtonStyle(
    //                         minimumSize:
    //                             MaterialStatePropertyAll(Size(150, 50)),
    //                         backgroundColor:
    //                             MaterialStatePropertyAll(Colors.blue)),
    //                     child: Text(
    //                       'Register',
    //                       style: TextStyle(color: Colors.grey.shade200),
    //                     )),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),

    //   Column(
    //     children: [
    //       Stack(
    //         children: [
    //           Image.network(
    //             widget.url!,
    //             loadingBuilder: (BuildContext context, Widget child,
    //                 ImageChunkEvent? loadingProgress) {
    //               if (loadingProgress == null) {
    //                 return child;
    //               }
    //               return Center(
    //                 child: CircularProgressIndicator(
    //                   value: loadingProgress.expectedTotalBytes != null
    //                       ? loadingProgress.cumulativeBytesLoaded /
    //                           loadingProgress.expectedTotalBytes!
    //                       : null,
    //                 ),
    //               );
    //             },
    //           ),
    //           IconButton(
    //             highlightColor: Colors.transparent,
    //             style: const ButtonStyle(
    //                 backgroundColor: MaterialStatePropertyAll(Colors.white10),
    //                 shape: MaterialStatePropertyAll(RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.all(Radius.circular(25))))),
    //             icon: Icon(
    //               Icons.chevron_left,
    //               size: 50,
    //               color: Colors.grey.shade600,
    //             ),
    //             onPressed: () {
    //               Navigator.pop(context);
    //             },
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    //   // const Text('data'),
    //   const Text('data')
    // ];
    DateTime date = DateTime(
      int.parse(widget.date!.split('/').last),
      int.parse(widget.date!.split('/')[1]),
      int.parse(widget.date!.split('/').first),
    );
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height,
            child: Stack(children: [
              Positioned(
                  top: 0,
                  child: Container(
                      color: const Color.fromRGBO(17, 12, 49, 1),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(50))),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 35,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 575,
                                  child: Image.network(
                                    fit: BoxFit.fill,
                                    widget.url!,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                        child: LinearProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 360.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: MediaQuery.of(context).size.height,
                                  // height: 500,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              widget.name!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Date',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!,
                                                    // TextStyle(
                                                    //     fontSize: 15,
                                                    //     fontWeight:
                                                    //         FontWeight.w700),
                                                  ),
                                                  Text(
                                                    widget.date!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!,
                                                    // const TextStyle(
                                                    //     fontSize: 20,
                                                    //     fontWeight:
                                                    //         FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Time',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!,
                                                      // TextStyle(
                                                      //     fontSize: 15,
                                                      //     fontWeight:
                                                      //         FontWeight.w700),
                                                    ),
                                                    Text(
                                                      widget.time!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!,
                                                      // const TextStyle(
                                                      //     fontSize: 20,
                                                      //     fontWeight:
                                                      //         FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Location',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!,
                                                  // TextStyle(
                                                  //     fontSize: 15,
                                                  //     fontWeight:
                                                  //         FontWeight.w700),
                                                ),
                                                Text(
                                                  widget.location!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!,
                                                  // const TextStyle(
                                                  //     fontSize: 20,
                                                  //     fontWeight:
                                                  //         FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Description',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!,
                                                  // TextStyle(
                                                  //     fontSize: 15,
                                                  //     fontWeight:
                                                  //         FontWeight.w700),
                                                ),
                                                Text(
                                                  widget.description ?? '',
                                                  // 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!,
                                                  // const TextStyle(
                                                  //     fontSize: 20,
                                                  //     fontWeight:
                                                  //         FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          if (!date.isBefore(DateTime.now()))
                                            ElevatedButton(
                                                onPressed: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EventRegister(
                                                                eventName: widget
                                                                    .name))),
                                                style: const ButtonStyle(
                                                    minimumSize:
                                                        WidgetStatePropertyAll(
                                                            Size(150, 50)),
                                                    backgroundColor:
                                                        WidgetStatePropertyAll(
                                                            Colors.blue)),
                                                child: Text(
                                                  'Register',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade200),
                                                )),
                                          const SizedBox(
                                            height: 80,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 100.0),
                                child: ClipPath(
                                  clipper: ReverseBorderRadiusClipper(50.0),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    color: const Color.fromRGBO(17, 12, 49, 1),
                                  ),
                                ),
                              ),
                              Container(
                                  height: 100.5,
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(17, 12, 49, 1),
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(50))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  color: Colors.white,
                                                  onPressed: () async {
                                                    Provider.of<CSIProvider>(
                                                            context,
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
                                                  icon: Icon(Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? Icons.dark_mode
                                                      : Icons.light_mode),
                                                ),
                                                IconButton(
                                                    color: Colors.white,
                                                    onPressed: () async {
                                                      showDialog(
                                                          context: context,
                                                          builder:
                                                              (context) =>
                                                                  AlertDialog(
                                                                    title:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
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
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          ElevatedButton(
                                                                              onPressed: () async {
                                                                                final SharedPreferences preferences = await SharedPreferences.getInstance();
                                                                                await FirebaseAuth.instance.signOut();
                                                                                Navigator.pop(context);
                                                                                Navigator.of(context).pushReplacementNamed('/sign-in');
                                                                                preferences.remove('email');
                                                                                preferences.remove('password');
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
                                                    icon: const Icon(
                                                        Icons.logout))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ))))
            ])),
        bottomNavigationBar: BottomNavigationBar(
            elevation: 10,
            currentIndex: index,
            showUnselectedLabels: true,
            selectedItemColor: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.grey,
            unselectedItemColor: Colors.blue.shade800,
            selectedLabelStyle: GoogleFonts.poppins(),
            unselectedLabelStyle: GoogleFonts.plusJakartaSans(),
            onTap: (value) {
              setState(() {
                index = value;
                if (index != 1) {
                  Navigator.of(context).removeRoute(ModalRoute.of(context)!);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserHomeScreen(
                                index: index,
                              )));
                } else {
                  Navigator.of(context).removeRoute(ModalRoute.of(context)!);
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

class ReverseBorderRadiusClipper extends CustomClipper<Path> {
  final double radius;

  ReverseBorderRadiusClipper(this.radius);

  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(radius, 0)
      ..lineTo(0, 0)
      ..lineTo(0, size.height)
      ..arcToPoint(
        Offset(radius, 0),
        clockwise: true,
        radius: Radius.circular(radius),
      );

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
