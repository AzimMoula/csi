import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csi/services/provider.dart';
import 'package:csi/user/screens/about_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YourEvents extends StatefulWidget {
  const YourEvents({super.key});

  @override
  State<YourEvents> createState() => _YourEventsState();
}

class _YourEventsState extends State<YourEvents> {
  List<String> events = [];
  List<String> queryEvents = [];
  // List<List> pEvents = [];
  @override
  void initState() {
    // loadEvents();
    if (Provider.of<CSIProvider>(context, listen: false).yourEvents.isEmpty) {
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   Provider.of<CSIProvider>(context, listen: false).loadYourEvents();
      // });
    }
    events = Provider.of<CSIProvider>(context, listen: false).events;
    queryEvents = Provider.of<CSIProvider>(context, listen: false).queryEvents;
    super.initState();
  }

  // Future<void> loadEvents() async {
  //   List<String> temp1 = [];
  //   List<List> temp2 = [];
  //   final docSnap1 =
  //       await FirebaseFirestore.instance.collection('Events').get();
  //   for (final doc in docSnap1.docs) {
  //     final docSnap2 = await FirebaseFirestore.instance
  //         .collection('Event-Registrations')
  //         .doc(doc.id)
  //         .collection('Registered-Users')
  //         .doc(FirebaseAuth.instance.currentUser?.uid)
  //         .get();
  //     if (docSnap2.exists) {
  //       temp1.add(doc.id);
  //       temp2.add([
  //         doc['Name'],
  //         doc['Date'],
  //         doc['Time'],
  //         doc['location'],
  //         doc['url'],
  //         doc['Description'],
  //       ]);
  //     }
  //   }
  //   setState(() {
  //     events = temp1;
  //     queryevents = temp1;
  //     pEvents = temp2;
  //   });
  // }

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
                          padding: const EdgeInsets.fromLTRB(15, 20, 10, 0),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 55.0),
                                child: RefreshIndicator(
                                    onRefresh: Provider.of<CSIProvider>(context,
                                            listen: false)
                                        .loadYourEvents,
                                    child:
                                        // FutureBuilder(
                                        //   future: loadEvents(),
                                        //   builder: (context, snapshot) {
                                        //     return
                                        Consumer<CSIProvider>(
                                      builder: (context, csiProvider, child) {
                                        // if (csiProvider.isLoadingEvents) {
                                        //   return Center(
                                        //       child:
                                        //           CircularProgressIndicator());
                                        //   // ignore: prefer_is_empty
                                        // }
                                        // ignore: prefer_is_empty
                                        return Provider.of<CSIProvider>(context,
                                                        listen: false)
                                                    .yourEvents
                                                    .length >
                                                0
                                            ? ListView.builder(
                                                itemCount:
                                                    Provider.of<CSIProvider>(
                                                            context,
                                                            listen: false)
                                                        .events
                                                        .length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              AboutEvent(
                                                            name: Provider.of<
                                                                        CSIProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .yourEvents[index][0],
                                                            date: Provider.of<
                                                                        CSIProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .yourEvents[index][1],
                                                            time: Provider.of<
                                                                        CSIProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .yourEvents[index][2],
                                                            location: Provider.of<
                                                                        CSIProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .yourEvents[index][3],
                                                            url: Provider.of<
                                                                        CSIProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .yourEvents[index][4],
                                                            description: Provider.of<
                                                                        CSIProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .yourEvents[index][5],
                                                          ),
                                                        ),
                                                      ),
                                                      child: Card(
                                                        child: SizedBox(
                                                          height: 200,
                                                          width: 325,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              GestureDetector(
                                                                onLongPress:
                                                                    () {
                                                                  showModalBottomSheet(
                                                                    isScrollControlled:
                                                                        true,
                                                                    showDragHandle:
                                                                        true,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        ((context) =>
                                                                            FractionallySizedBox(
                                                                              heightFactor: 0.8,
                                                                              child: SingleChildScrollView(
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    InteractiveViewer(
                                                                                      maxScale: 5,
                                                                                      child: Image.network(
                                                                                        Provider.of<CSIProvider>(context, listen: false).yourEvents[index][4],
                                                                                        fit: BoxFit.fitWidth,
                                                                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                                                          if (loadingProgress == null) {
                                                                                            return child;
                                                                                          }
                                                                                          return Align(
                                                                                            alignment: Alignment.center,
                                                                                            child: CircularProgressIndicator(
                                                                                              value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
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
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  child: Image
                                                                      .network(
                                                                    Provider.of<CSIProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .yourEvents[index][4],
                                                                    height: 200,
                                                                    width: 135,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    loadingBuilder: (BuildContext
                                                                            context,
                                                                        Widget
                                                                            child,
                                                                        ImageChunkEvent?
                                                                            loadingProgress) {
                                                                      if (loadingProgress ==
                                                                          null) {
                                                                        return child;
                                                                      }
                                                                      return Center(
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          value: loadingProgress.expectedTotalBytes != null
                                                                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                              : null,
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        20,
                                                                        5,
                                                                        0,
                                                                        5),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        Provider.of<CSIProvider>(context, listen: false).yourEvents[index]
                                                                            [0],
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .titleMedium!
                                                                            .copyWith(
                                                                              // fontSize:
                                                                              //     20,
                                                                              fontWeight: FontWeight.bold,
                                                                            )
                                                                        //     const TextStyle(
                                                                        //   fontSize: 20,
                                                                        //   fontWeight:
                                                                        //       FontWeight
                                                                        //           .bold,
                                                                        // ),
                                                                        ),
                                                                    Text(
                                                                      Provider.of<CSIProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .yourEvents[index][1],
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium!,
                                                                      // const TextStyle(
                                                                      //     fontSize: 16,
                                                                      //     fontWeight:
                                                                      //         FontWeight
                                                                      //             .w600),
                                                                    ),
                                                                    Text(
                                                                      Provider.of<CSIProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .yourEvents[index][2],
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium!,
                                                                      // const TextStyle(
                                                                      //     fontSize: 16,
                                                                      //     fontWeight:
                                                                      //         FontWeight
                                                                      //             .w600),
                                                                    ),
                                                                    Text(
                                                                      Provider.of<CSIProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .yourEvents[index][3],
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium!,
                                                                      // const TextStyle(
                                                                      //     fontSize: 17,
                                                                      //     fontWeight:
                                                                      //         FontWeight
                                                                      //             .w600),
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
                                                },
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: Center(
                                                  child: SizedBox(
                                                    height: 150,
                                                    width: 345,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .watch_later_outlined,
                                                          size: 55,
                                                        ),
                                                        Text(
                                                          "No Events",
                                                          style: TextStyle(
                                                            fontSize: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headlineSmall!
                                                                .fontSize,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                      },
                                    )),
                              ),
                              // StreamBuilder(
                              //   stream: FirebaseFirestore.instance
                              //       .collection('Events')
                              //       .snapshots(),
                              //   builder: ((context, snapshot) {
                              //     if (snapshot.hasData) {
                              //       return ListView.builder(
                              //         itemCount: snapshot.data!.docs.length,
                              //         itemBuilder: ((context, index) {
                              //           final DocumentSnapshot docSnap =
                              //               snapshot.data!.docs[index];
                              //           return FutureBuilder(
                              //               future: FirebaseFirestore
                              //                   .instance
                              //                   .collection(
                              //                       'Event-Registrations')
                              //                   .doc(docSnap['Name'])
                              //                   .collection(
                              //                       'Registered-Users')
                              //                   .doc(FirebaseAuth.instance
                              //                       .currentUser?.uid)
                              //                   .get(),
                              //               builder: (context, snapshot) {
                              //                 bool userRegistered =
                              //                     snapshot.hasData &&
                              //                         snapshot.data!.exists;
                              //                 if (userRegistered) {
                              //                   return Padding(
                              //                     padding:
                              //                         const EdgeInsets.all(
                              //                             5.0),
                              //                     child: GestureDetector(
                              //                       onTap: () =>
                              //                           Navigator.push(
                              //                         context,
                              //                         MaterialPageRoute(
                              //                           builder:
                              //                               (context) =>
                              //                                   AboutEvent(
                              //                             name: docSnap[
                              //                                 'Name'],
                              //                             date: docSnap[
                              //                                 'Date'],
                              //                             time: docSnap[
                              //                                 'Time'],
                              //                             location: docSnap[
                              //                                 'location'],
                              //                             url: docSnap[
                              //                                 'url'],
                              //                             description: docSnap[
                              //                                 'Description'],
                              //                           ),
                              //                         ),
                              //                       ),
                              //                       child: Card(
                              //                         child: SizedBox(
                              //                           height: 200,
                              //                           width: 325,
                              //                           child: Row(
                              //                             mainAxisAlignment:
                              //                                 MainAxisAlignment
                              //                                     .start,
                              //                             children: [
                              //                               GestureDetector(
                              //                                 onLongPress:
                              //                                     () {
                              //                                   showModalBottomSheet(
                              //                                     isScrollControlled:
                              //                                         true,
                              //                                     showDragHandle:
                              //                                         true,
                              //                                     context:
                              //                                         context,
                              //                                     builder:
                              //                                         ((context) =>
                              //                                             FractionallySizedBox(
                              //                                               heightFactor: 0.8,
                              //                                               child: SingleChildScrollView(
                              //                                                 child: Column(
                              //                                                   mainAxisAlignment: MainAxisAlignment.center,
                              //                                                   children: [
                              //                                                     InteractiveViewer(
                              //                                                       maxScale: 5,
                              //                                                       child: Image.network(
                              //                                                         docSnap['url'],
                              //                                                         fit: BoxFit.fitWidth,
                              //                                                         loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              //                                                           if (loadingProgress == null) {
                              //                                                             return child;
                              //                                                           }
                              //                                                           return Align(
                              //                                                             alignment: Alignment.center,
                              //                                                             child: CircularProgressIndicator(
                              //                                                               value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                              //                                                             ),
                              //                                                           );
                              //                                                         },
                              //                                                       ),
                              //                                                     ),
                              //                                                   ],
                              //                                                 ),
                              //                                               ),
                              //                                             )),
                              //                                   );
                              //                                 },
                              //                                 child:
                              //                                     ClipRRect(
                              //                                   borderRadius:
                              //                                       BorderRadius.circular(
                              //                                           12),
                              //                                   child: Image
                              //                                       .network(
                              //                                     docSnap[
                              //                                         'url'],
                              //                                     height:
                              //                                         200,
                              //                                     width:
                              //                                         135,
                              //                                     fit: BoxFit
                              //                                         .fill,
                              //                                     loadingBuilder: (BuildContext context,
                              //                                         Widget
                              //                                             child,
                              //                                         ImageChunkEvent?
                              //                                             loadingProgress) {
                              //                                       if (loadingProgress ==
                              //                                           null) {
                              //                                         return child;
                              //                                       }
                              //                                       return Center(
                              //                                         child:
                              //                                             CircularProgressIndicator(
                              //                                           value: loadingProgress.expectedTotalBytes != null
                              //                                               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              //                                               : null,
                              //                                         ),
                              //                                       );
                              //                                     },
                              //                                   ),
                              //                                 ),
                              //                               ),
                              //                               Padding(
                              //                                 padding:
                              //                                     const EdgeInsets
                              //                                         .fromLTRB(
                              //                                         20,
                              //                                         5,
                              //                                         0,
                              //                                         5),
                              //                                 child: Column(
                              //                                   mainAxisAlignment:
                              //                                       MainAxisAlignment
                              //                                           .spaceEvenly,
                              //                                   crossAxisAlignment:
                              //                                       CrossAxisAlignment
                              //                                           .start,
                              //                                   children: [
                              //                                     Text(
                              //                                         docSnap[
                              //                                             'Name'],
                              //                                         style: Theme.of(context)
                              //                                             .textTheme
                              //                                             .titleMedium!
                              //                                             .copyWith(
                              //                                               // fontSize:
                              //                                               //     20,
                              //                                               fontWeight: FontWeight.bold,
                              //                                             )
                              //                                         //     const TextStyle(
                              //                                         //   fontSize: 20,
                              //                                         //   fontWeight:
                              //                                         //       FontWeight
                              //                                         //           .bold,
                              //                                         // ),
                              //                                         ),
                              //                                     Text(
                              //                                       docSnap[
                              //                                           'Date'],
                              //                                       style: Theme.of(context)
                              //                                           .textTheme
                              //                                           .titleMedium!,
                              //                                       // const TextStyle(
                              //                                       //     fontSize: 16,
                              //                                       //     fontWeight:
                              //                                       //         FontWeight
                              //                                       //             .w600),
                              //                                     ),
                              //                                     Text(
                              //                                       docSnap[
                              //                                           'Time'],
                              //                                       style: Theme.of(context)
                              //                                           .textTheme
                              //                                           .titleMedium!,
                              //                                       // const TextStyle(
                              //                                       //     fontSize: 16,
                              //                                       //     fontWeight:
                              //                                       //         FontWeight
                              //                                       //             .w600),
                              //                                     ),
                              //                                     Text(
                              //                                       docSnap[
                              //                                           'location'],
                              //                                       style: Theme.of(context)
                              //                                           .textTheme
                              //                                           .titleMedium!,
                              //                                       // const TextStyle(
                              //                                       //     fontSize: 17,
                              //                                       //     fontWeight:
                              //                                       //         FontWeight
                              //                                       //             .w600),
                              //                                     ),
                              //                                   ],
                              //                                 ),
                              //                               ),
                              //                             ],
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   );
                              //                 } else {
                              //                   return const SizedBox(); // Return an empty SizedBox if the condition is not met
                              //                 }
                              //               });
                              //         }),
                              //       );
                              //     } else {
                              //       return const Center(
                              //           child: CircularProgressIndicator());
                              //     }
                              //   }),
                              // )),
                              buildFloatingSearchBar()
                            ],
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

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search...',
      borderRadius: BorderRadius.circular(15),
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      clearQueryOnClose: true,
      automaticallyImplyBackButton: false,
      onFocusChanged: (isFocused) {
        queryEvents = events;
      },
      onQueryChanged: (query) {
        List<String> matchQuery = [];
        for (var name in events) {
          if (name.toLowerCase().contains(query.toLowerCase())) {
            matchQuery.add(name);
          }
        }
        setState(() {
          queryEvents = matchQuery;
        });
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction.searchToClear(
          showIfClosed: true,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Theme.of(context).cardColor.withOpacity(0.75),
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: queryEvents.map((doc) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListTile(
                    onTap: () async {
                      final docSnap = await FirebaseFirestore.instance
                          .collection('Events')
                          .doc(doc)
                          .get();
                      if (!context.mounted) {
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutEvent(
                            name: doc,
                            date: docSnap['Date'],
                            time: docSnap['Time'],
                            location: docSnap['location'],
                            url: docSnap['url'],
                            description: docSnap['Description'],
                          ),
                        ),
                      );
                    },
                    title: Center(child: Text(doc)),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
