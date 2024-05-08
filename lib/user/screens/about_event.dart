// ignore_for_file: use_build_context_synchronously
// import 'dart:ffi';

import 'package:csi/main.dart';
import 'package:csi/user/screens/event_register.dart';
import 'package:csi/user/user_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutEvent extends StatefulWidget {
  const AboutEvent({
    super.key,
    required this.name,
    required this.date,
    required this.time,
    required this.location,
    required this.url,
  });

  final String? name;
  final String? date;
  final String? time;
  final String? location;
  final String? url;

  @override
  State<AboutEvent> createState() => _AboutEventState();
}

class _AboutEventState extends State<AboutEvent> {
  int index = 1;
  bool? toggle = false;
  String? theme;

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
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.chevron_left)),
          title: const Text('User View'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                if (preferences.getString('theme') == null) {
                  preferences.setString('theme', 'light');
                } else {
                  preferences.setString(
                      'theme',
                      preferences.getString('theme') == 'light'
                          ? 'dark'
                          : 'light');
                  setState(() {
                    theme = preferences.getString('theme');
                    toggle = (theme == 'light' ? false : true);
                  });
                  MyApp.themeNotifier.value =
                      theme == 'light' ? ThemeMode.dark : ThemeMode.light;
                }
              },
              icon: Icon(theme == 'dark' ? Icons.dark_mode : Icons.light_mode),
            ),
            IconButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: FittedBox(
                                  child: const Text('Do you want to Logout?')),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        // final SharedPreferences preferences =
                                        //     await SharedPreferences.getInstance();
                                        await FirebaseAuth.instance.signOut();
                                        Navigator.of(context)
                                            .pushNamed('/sign-in');
                                        // preferences.remove('email');
                                        // preferences.remove('password');
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
                icon: const Icon(Icons.logout))
          ]),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: SizedBox(
              height: 575,
              child: Hero(
                tag: 'poster',
                child: Image.network(
                  widget.url!,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: LinearProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 350,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 500,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.name!,
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Date',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              widget.date!,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Time',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700)),
                            Text(widget.time!,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Location',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700)),
                          Text(widget.location!,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    ElevatedButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    EventRegister(eventName: widget.name))),
                        // Navigator.pushNamed(context, '/event-register'),
                        style: const ButtonStyle(
                            minimumSize:
                                MaterialStatePropertyAll(Size(150, 50)),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue)),
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.grey.shade200),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 10,
          backgroundColor: Colors.blue,
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
                icon: Icon(CupertinoIcons.chat_bubble_fill), label: 'Chats'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
          ]),
    );
  }
}
