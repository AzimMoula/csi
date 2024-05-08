// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csi/main.dart';
import 'package:csi/user/screens/about_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHomeScreen extends StatefulWidget {
  final int index;

  const UserHomeScreen({super.key, required this.index});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

List<Widget> widgetList = [
  Padding(
      padding: const EdgeInsets.all(15.0),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Events').snapshots(),
        builder: ((context, snapshot) {
          int count = 0;
          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: ((context, index) {
                final DocumentSnapshot docSnap = snapshot.data!.docs[index];
                String temp = docSnap['Date'];
                DateTime eventDate = DateTime(
                  int.parse(temp.split('/').last),
                  int.parse(temp.split('/')[1]),
                  int.parse(temp.split('/').first),
                );
                return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('Event-Registrations')
                        .doc(docSnap['Name'])
                        .collection('Registered-Users')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .get(),
                    builder: (context, snapshot) {
                      bool userRegistered =
                          snapshot.hasData && snapshot.data!.exists;
                      if (eventDate.isAfter(DateTime.now()) &&
                          !userRegistered) {
                        count++;
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AboutEvent(
                                  name: docSnap['Name'],
                                  date: docSnap['Date'],
                                  time: docSnap['Time'],
                                  location: docSnap['location'],
                                  url: docSnap['url'],
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'Upcoming:',
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .fontSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Card(
                                  child: SizedBox(
                                    height: 200,
                                    width: count == 1 ? 360 : 310,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                          onLongPress: () {
                                            showModalBottomSheet(
                                              isScrollControlled: true,
                                              showDragHandle: true,
                                              context: context,
                                              builder: ((context) =>
                                                  FractionallySizedBox(
                                                    heightFactor: 0.8,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          InteractiveViewer(
                                                            maxScale: 5,
                                                            child:
                                                                Image.network(
                                                              docSnap['url'],
                                                              fit: BoxFit
                                                                  .fitWidth,
                                                              loadingBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      ImageChunkEvent?
                                                                          loadingProgress) {
                                                                if (loadingProgress ==
                                                                    null) {
                                                                  return child;
                                                                }
                                                                return Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    value: loadingProgress.expectedTotalBytes !=
                                                                            null
                                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                                            loadingProgress.expectedTotalBytes!
                                                                        : null,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(21.5),
                                            child: Hero(
                                              tag: 'poster',
                                              child: Image.network(
                                                docSnap['url'],
                                                fit: BoxFit.fitWidth,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
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
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              docSnap['Name'],
                                              style: const TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              docSnap['Date'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              docSnap['Time'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              docSnap['location'],
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox(); // Return an empty SizedBox if the condition is not met
                      }
                    });
              }),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }),
      )),
  Padding(
    padding: const EdgeInsets.all(15.0),
    child: StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Events').snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            // scrollDirection: Axis.vertical,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: ((context, index) {
              final DocumentSnapshot docSnap = snapshot.data!.docs[index];
              String temp = docSnap['Date'];
              DateTime eventDate = DateTime(
                int.parse(temp.split('/').last),
                int.parse(temp.split('/')[1]),
                int.parse(temp.split('/').first),
              );
              if (eventDate.isAfter(DateTime.now())) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutEvent(
                          name: docSnap['Name'],
                          date: docSnap['Date'],
                          time: docSnap['Time'],
                          location: docSnap['location'],
                          url: docSnap['url'],
                        ),
                      ),
                    ),
                    child: Card(
                      child: SizedBox(
                        height: 200,
                        width: 325,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onLongPress: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  showDragHandle: true,
                                  context: context,
                                  builder: ((context) => FractionallySizedBox(
                                        heightFactor: 0.8,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InteractiveViewer(
                                                maxScale: 5,
                                                child: Hero(
                                                  tag: 'poster',
                                                  child: Image.network(
                                                    docSnap['url'],
                                                    fit: BoxFit.fitWidth,
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child:
                                                            CircularProgressIndicator(
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
                                            ],
                                          ),
                                        ),
                                      )),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(21.5),
                                child: Image.network(
                                  docSnap['url'],
                                  fit: BoxFit.fitWidth,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  docSnap['Name'],
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  docSnap['Date'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  docSnap['Time'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  docSnap['location'],
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox(); // Return an empty SizedBox if the condition is not met
              }
            }),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    ),
  ),
  // StreamBuilder(
  //     stream: FirebaseFirestore.instance.collection('Events').snapshots(),
  //     builder: ((context, snapshot) {
  //       if (snapshot.hasData) {
  //         return ListView.builder(
  //             itemCount: snapshot.data!.docs.length,
  //             itemBuilder: ((context, index) {
  //               final DocumentSnapshot docSnap = snapshot.data!.docs[index];
  //               return Padding(
  //                 padding: const EdgeInsets.all(5.0),
  //                 child: GestureDetector(
  //                   onTap: () => Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (context) => AboutEvent(
  //                                 name: docSnap['Name'],
  //                                 date: docSnap['Date'],
  //                                 time: docSnap['Time'],
  //                                 location: docSnap['location'],
  //                                 url: docSnap['url'],
  //                               ))),
  //                   // onLongPress: () {
  //                   //   showModalBottomSheet(
  //                   //       isScrollControlled: true,
  //                   //       showDragHandle: true,
  //                   //       context: context,
  //                   //       builder: ((context) => FractionallySizedBox(
  //                   //             heightFactor: 0.8,
  //                   //             child: SingleChildScrollView(
  //                   //               child: Column(
  //                   //                 mainAxisAlignment: MainAxisAlignment.center,
  //                   //                 children: [
  //                   //                   Image.network(
  //                   //                     docSnap['url'],
  //                   //                     fit: BoxFit.fitWidth,
  //                   //                     loadingBuilder: (BuildContext context,
  //                   //                         Widget child,
  //                   //                         ImageChunkEvent? loadingProgress) {
  //                   //                       if (loadingProgress == null) {
  //                   //                         return child;
  //                   //                       }
  //                   //                       return Align(
  //                   //                         alignment: Alignment.center,
  //                   //                         child: CircularProgressIndicator(
  //                   //                           value: loadingProgress
  //                   //                                       .expectedTotalBytes !=
  //                   //                                   null
  //                   //                               ? loadingProgress
  //                   //                                       .cumulativeBytesLoaded /
  //                   //                                   loadingProgress
  //                   //                                       .expectedTotalBytes!
  //                   //                               : null,
  //                   //                         ),
  //                   //                       );
  //                   //                     },
  //                   //                   ),
  //                   //                 ],
  //                   //               ),
  //                   //             ),
  //                   //           )));
  //                   // },
  //                   child: Card(
  //                     shadowColor: Colors.blue.shade700,
  //                     elevation: 8,
  //                     child: SizedBox(
  //                       height: 200,
  //                       width: 100,
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                         children: [
  //                           GestureDetector(
  //                             onLongPress: () {
  //                               showModalBottomSheet(
  //                                   isScrollControlled: true,
  //                                   showDragHandle: true,
  //                                   context: context,
  //                                   builder: ((context) => FractionallySizedBox(
  //                                         heightFactor: 0.8,
  //                                         child: SingleChildScrollView(
  //                                           child: Column(
  //                                             mainAxisAlignment:
  //                                                 MainAxisAlignment.center,
  //                                             children: [
  //                                               InteractiveViewer(
  //                                                 maxScale: 5,
  //                                                 child: Image.network(
  //                                                   docSnap['url'],
  //                                                   fit: BoxFit.fitWidth,
  //                                                   loadingBuilder: (BuildContext
  //                                                           context,
  //                                                       Widget child,
  //                                                       ImageChunkEvent?
  //                                                           loadingProgress) {
  //                                                     if (loadingProgress ==
  //                                                         null) {
  //                                                       return child;
  //                                                     }
  //                                                     return Align(
  //                                                       alignment:
  //                                                           Alignment.center,
  //                                                       child:
  //                                                           CircularProgressIndicator(
  //                                                         value: loadingProgress
  //                                                                     .expectedTotalBytes !=
  //                                                                 null
  //                                                             ? loadingProgress
  //                                                                     .cumulativeBytesLoaded /
  //                                                                 loadingProgress
  //                                                                     .expectedTotalBytes!
  //                                                             : null,
  //                                                       ),
  //                                                     );
  //                                                   },
  //                                                 ),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                       )));
  //                             },
  //                             child: Card(
  //                               color: Colors.transparent,
  //                               child: ClipRRect(
  //                                 borderRadius: BorderRadius.circular(21.5),
  //                                 child: Image.network(
  //                                   docSnap['url'],
  //                                   fit: BoxFit.fitWidth,
  //                                   loadingBuilder: (BuildContext context,
  //                                       Widget child,
  //                                       ImageChunkEvent? loadingProgress) {
  //                                     if (loadingProgress == null) {
  //                                       return child;
  //                                     }
  //                                     return Center(
  //                                       child: CircularProgressIndicator(
  //                                         value: loadingProgress
  //                                                     .expectedTotalBytes !=
  //                                                 null
  //                                             ? loadingProgress
  //                                                     .cumulativeBytesLoaded /
  //                                                 loadingProgress
  //                                                     .expectedTotalBytes!
  //                                             : null,
  //                                       ),
  //                                     );
  //                                   },
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           Column(
  //                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                             mainAxisSize: MainAxisSize.max,
  //                             children: [
  //                               Text(docSnap['Name'],
  //                                   style: const TextStyle(
  //                                       decoration: TextDecoration.underline,
  //                                       fontSize: 20,
  //                                       fontWeight: FontWeight.bold)),
  //                               Text(docSnap['Date'],
  //                                   style: const TextStyle(
  //                                       fontSize: 16,
  //                                       fontWeight: FontWeight.w600)),
  //                               Text(docSnap['Time'],
  //                                   style: const TextStyle(
  //                                       fontSize: 16,
  //                                       fontWeight: FontWeight.w600)),
  //                               Text(docSnap['location'],
  //                                   style: const TextStyle(
  //                                       fontSize: 17,
  //                                       fontWeight: FontWeight.w600)),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             }));
  //       } else {
  //         const Icon(Icons.watch_later_outlined);
  //         const Text("No Events");
  //       }
  //       return const Center(child: CircularProgressIndicator());
  //     })),
  const Text('Membership'),
  const Text('Settings'),
];

class _UserHomeScreenState extends State<UserHomeScreen>
    with TickerProviderStateMixin {
  int index = 0;
  bool? toggle = false;
  String? theme;

  @override
  void initState() {
    super.initState();
    index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
            AppBar(title: const Text('User View'), centerTitle: true, actions: [
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
                          title: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: FittedBox(
                                child: Text('Do you want to Logout?')),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      final SharedPreferences preferences =
                                          await SharedPreferences.getInstance();
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.pop(context);
                                      Navigator.of(context)
                                          .pushReplacementNamed('/sign-in');
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
              icon: const Icon(Icons.logout))
        ]),
        body: Center(child: widgetList[index]),
        drawerEnableOpenDragGesture: true,
        drawer: Drawer(
          elevation: 10,
          child: ListView(
            children: [
              const DrawerHeader(
                  child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 40,
                ),
              )),
              ListTile(
                title: const Text('About'),
                onTap: () => Navigator.pushNamed(context, '/user-about'),
              ),
              ListTile(
                title: const Text('Developers'),
                onTap: () => Navigator.pushNamed(context, '/developers'),
              ),
              ListTile(
                title: const Text('Contact HR'),
                onTap: () => Navigator.pushNamed(context, '/contact-hr'),
              ),
              ListTile(
                title: const Text('Your Events'),
                onTap: () => Navigator.pushNamed(context, '/your-events'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                        minimumSize: const MaterialStatePropertyAll(
                            Size.fromHeight(50))),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: FittedBox(
                                      child: Text('Do you want to Logout?')),
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () async {
                                            final SharedPreferences
                                                preferences =
                                                await SharedPreferences
                                                    .getInstance();
                                            await FirebaseAuth.instance
                                                .signOut();
                                            Navigator.pop(context);
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    '/sign-in');
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
                    child: const Text('Logout')),
              )
              //   Padding(
              //     padding: const EdgeInsets.all(15.0),
              //     child: Row(
              //       children: [
              //         GestureDetector(
              //             onTap: () async {
              //               SharedPreferences preferences =
              //                   await SharedPreferences.getInstance();
              //               if (preferences.getString('theme') == null) {
              //                 preferences.setString('theme', 'light');
              //               } else {
              //                 preferences.setString('theme', 'light');
              //                 setState(() {
              //                   theme = preferences.getString('theme');
              //                   toggle = true;
              //                 });
              //                 MyApp.themeNotifier.value = ThemeMode.light;
              //               }
              //             },
              //             child: const Icon(Icons.light_mode)),
              //         Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //           child: CupertinoSwitch(
              //               value: !toggle!,
              //               activeColor: Theme.of(context).canvasColor,
              //               dragStartBehavior: DragStartBehavior.start,
              //               onChanged: (value) async {
              //                 SharedPreferences preferences =
              //                     await SharedPreferences.getInstance();
              //                 if (preferences.getString('theme') == null) {
              //                   preferences.setString('theme', 'light');
              //                 } else {
              //                   preferences.setString(
              //                       'theme',
              //                       preferences.getString('theme') == 'light'
              //                           ? 'dark'
              //                           : 'light');
              //                   setState(() {
              //                     theme = preferences.getString('theme');
              //                     toggle = theme == 'light' ? false : true;
              //                   });
              //                   MyApp.themeNotifier.value = theme == 'light'
              //                       ? ThemeMode.dark
              //                       : ThemeMode.light;
              //                 }
              //               }),
              //         ),
              //         GestureDetector(
              //             onTap: () async {
              //               SharedPreferences preferences =
              //                   await SharedPreferences.getInstance();
              //               if (preferences.getString('theme') == null) {
              //                 preferences.setString('theme', 'dark');
              //               } else {
              //                 preferences.setString('theme', 'dark');
              //                 setState(() {
              //                   theme = preferences.getString('theme');
              //                   toggle = false;
              //                 });
              //                 MyApp.themeNotifier.value = ThemeMode.dark;
              //               }
              //             },
              //             child: const Icon(Icons.dark_mode)),
              //       ],
              //     ),
              //   )
            ],
          ),
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
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.explore), label: 'Explore'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.card_membership_rounded),
                  label: 'Membership'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings'),
            ]),
      ),
    );
  }
}
