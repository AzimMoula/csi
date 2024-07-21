import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csi/services/provider.dart';
import 'package:csi/user/screens/about_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  bool member = false;
  // int count = 0;
  // bool eventExists = false;
  // bool noCount = false;
  // List<String?> name = [];
  // List<List> pEvents = [];
  @override
  void initState() {
    // loadEvents();
    getMember();
    if (Provider.of<CSIProvider>(context, listen: false).homeEvents.isEmpty) {
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   Provider.of<CSIProvider>(context, listen: false).loadHomeEvents(member);
      // });
    }
    super.initState();
  }

  // Future<void> loadEvents() async {
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
  //       String temp = doc['Date'];
  //       DateTime eventDate = DateTime(
  //         int.parse(temp.split('/').last),
  //         int.parse(temp.split('/')[1]),
  //         int.parse(temp.split('/').first),
  //       );
  //       Future<String> paymentDone() async {
  //         final value = await FirebaseFirestore.instance
  //             .collection('Users')
  //             .doc(FirebaseAuth.instance.currentUser?.uid)
  //             .get()
  //             .then((value) {
  //           return '${value.data()?['Name']}\n${value.data()?['Roll']}\n${value.data()?['Year']}\n${value.data()?['Branch']}\n${member ? 'Already a member' : 'Paid'}\n${FirebaseAuth.instance.currentUser?.uid}\n${doc['Name']}';
  //         });
  //         return value;
  //       }

  //       paymentDone();
  //       if ((eventDate.isAtSameMomentAs(DateTime.now()) ||
  //           eventDate.isAfter(DateTime.now()))) {
  //         temp2.add([
  //           doc['Name'],
  //           doc['Date'],
  //           doc['Time'],
  //           doc['location'],
  //           doc['url'],
  //           doc['Description'],
  //         ]);
  //       }
  //     }
  //   }
  //   setState(() {
  //     pEvents = temp2;
  //   });
  // }

  Future<void> getMember() async {
    bool val = await FirebaseFirestore.instance
        .collection('CSI-Members')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      return value.exists ? true : false;
    });
    setState(() {
      member = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: const Color.fromRGBO(17, 12, 49, 1),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius:
                      const BorderRadius.only(topLeft: Radius.circular(50))),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: RefreshIndicator(
                    onRefresh: Provider.of<CSIProvider>(context, listen: false)
                        .loadHomeEvents,
                    child: ListView(
                      children: [
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 5),
                                child: Text('Upcoming:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontWeight: FontWeight.w600)),
                              ),
                              Consumer<CSIProvider>(
                                  builder: (context, csiProvider, child) {
                                // if (csiProvider.isLoadingHome) {
                                //   return Center(child: CircularProgressIndicator());
                                // }
                                // ignore: prefer_is_empty
                                return Provider.of<CSIProvider>(context,
                                                listen: false)
                                            .homeEvents
                                            .length >
                                        0
                                    ? ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: Provider.of<CSIProvider>(
                                                context,
                                                listen: false)
                                            .homeEvents
                                            .length,
                                        itemBuilder: ((context, index) {
                                          Future<String> paymentDone() async {
                                            final value =
                                                await FirebaseFirestore.instance
                                                    .collection('Users')
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser?.uid)
                                                    .get()
                                                    .then((value) {
                                              return '${value.data()?['Name']}\n${value.data()?['Roll']}\n${value.data()?['Year']}\n${value.data()?['Branch']}\n${member ? 'Already a member' : 'Paid'}\n${FirebaseAuth.instance.currentUser?.uid}\n${Provider.of<CSIProvider>(context, listen: false).homeEvents[index][0]}';
                                            });
                                            return value;
                                          }

                                          return Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: GestureDetector(
                                              onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AboutEvent(
                                                    name: Provider.of<
                                                                CSIProvider>(
                                                            context,
                                                            listen: false)
                                                        .homeEvents[index][0],
                                                    date: Provider.of<
                                                                CSIProvider>(
                                                            context,
                                                            listen: false)
                                                        .homeEvents[index][1],
                                                    time: Provider.of<
                                                                CSIProvider>(
                                                            context,
                                                            listen: false)
                                                        .homeEvents[index][2],
                                                    location: Provider.of<
                                                                CSIProvider>(
                                                            context,
                                                            listen: false)
                                                        .homeEvents[index][3],
                                                    url: Provider.of<
                                                                CSIProvider>(
                                                            context,
                                                            listen: false)
                                                        .homeEvents[index][4],
                                                    description: Provider.of<
                                                                CSIProvider>(
                                                            context,
                                                            listen: false)
                                                        .homeEvents[index][5],
                                                    index: 0,
                                                  ),
                                                ),
                                              ),
                                              child: Card(
                                                child: SizedBox(
                                                  height: 150,
                                                  // width: 250,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      GestureDetector(
                                                        onLongPress: () {
                                                          showModalBottomSheet(
                                                            isScrollControlled:
                                                                true,
                                                            showDragHandle:
                                                                true,
                                                            context: context,
                                                            builder: ((context) =>
                                                                FractionallySizedBox(
                                                                  heightFactor:
                                                                      0.8,
                                                                  widthFactor:
                                                                      1,
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        InteractiveViewer(
                                                                            maxScale:
                                                                                5,
                                                                            child:
                                                                                SizedBox(
                                                                              height: MediaQuery.of(context).size.height - (4 * (AppBar().preferredSize.height)),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Card(
                                                                                    elevation: 25,
                                                                                    child: Container(
                                                                                      height: 300,
                                                                                      width: 300,
                                                                                      decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, borderRadius: BorderRadius.circular(13)),
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(15.0),
                                                                                        child: FutureBuilder(
                                                                                            future: paymentDone(),
                                                                                            builder: (context, snapshot) {
                                                                                              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                                                                                return PrettyQrView.data(
                                                                                                    data: snapshot.data!,
                                                                                                    decoration: PrettyQrDecoration(
                                                                                                      shape: PrettyQrSmoothSymbol(
                                                                                                        color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                                                                                                      ),
                                                                                                      // image: PrettyQrDecorationImage(
                                                                                                      //   fit: BoxFit.scaleDown,
                                                                                                      //   position: PrettyQrDecorationImagePosition.embedded,
                                                                                                      //   image: AssetImage(Theme.of(context).brightness == Brightness.dark ? 'assets/CSI-MJCET black.png' : 'assets/CSI-MJCET white.png'),
                                                                                                      // ),
                                                                                                    ));
                                                                                              }
                                                                                              return const Center(
                                                                                                child: CircularProgressIndicator(),
                                                                                              );
                                                                                            }),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )),
                                                          );
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                height: 150,
                                                                decoration: BoxDecoration(
                                                                    color: Theme.of(context).brightness ==
                                                                            Brightness
                                                                                .dark
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            13)),
                                                                child: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            15.0),
                                                                    child: FutureBuilder(
                                                                        future: paymentDone(),
                                                                        builder: (context, snapshot) {
                                                                          if (snapshot.hasData &&
                                                                              snapshot.data!.isNotEmpty) {
                                                                            return PrettyQrView.data(
                                                                                data: snapshot.data!,
                                                                                decoration: PrettyQrDecoration(
                                                                                  shape: PrettyQrSmoothSymbol(
                                                                                    color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                                                                                  ),
                                                                                  // image: PrettyQrDecorationImage(
                                                                                  //   fit: BoxFit.scaleDown,
                                                                                  //   position: PrettyQrDecorationImagePosition.embedded,
                                                                                  //   image: AssetImage(Theme.of(context).brightness == Brightness.dark ? 'assets/CSI-MJCET black.png' : 'assets/CSI-MJCET white.png'),
                                                                                  // ),
                                                                                ));
                                                                          }
                                                                          return const Center(
                                                                            child:
                                                                                CircularProgressIndicator(),
                                                                          );
                                                                        })),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                20, 5, 20, 5),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                Provider.of<CSIProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .homeEvents[
                                                                    index][0],
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleMedium!
                                                                    .copyWith(
                                                                      // fontSize:
                                                                      //     20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
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
                                                                      listen:
                                                                          false)
                                                                  .homeEvents[index][1],
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
                                                                      listen:
                                                                          false)
                                                                  .homeEvents[index][2],
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
                                                                      listen:
                                                                          false)
                                                                  .homeEvents[index][3],
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
                                        }),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Card(
                                          child: SizedBox(
                                            height: 150,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.watch_later_outlined,
                                                  size: 55,
                                                ),
                                                Text(
                                                  "No Upcoming Events",
                                                  style: TextStyle(
                                                    fontSize: Theme.of(context)
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
                                // StreamBuilder(
                                //   stream: FirebaseFirestore.instance
                                //       .collection('Events')
                                //       .snapshots(),
                                //   builder: ((context, snapshot) {
                                //     if (snapshot.hasData) {
                                //       // noCount = false;
                                //       return Column(
                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                //         children: [
                                //           Padding(
                                //             padding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                                //             child: Text('Upcoming:',
                                //                 style: Theme.of(context)
                                //                     .textTheme
                                //                     .titleLarge!
                                //                     .copyWith(fontWeight: FontWeight.w600)),
                                //           ),
                                //           ListView.builder(
                                //             physics: const NeverScrollableScrollPhysics(),
                                //             shrinkWrap: true,
                                //             scrollDirection: Axis.vertical,
                                //             itemCount: snapshot.data!.docs.length,
                                //             itemBuilder: ((context, index) {
                                //               final DocumentSnapshot docSnap =
                                //                   snapshot.data!.docs[index];
                                //               String temp = docSnap['Date'];
                                //               DateTime eventDate = DateTime(
                                //                 int.parse(temp.split('/').last),
                                //                 int.parse(temp.split('/')[1]),
                                //                 int.parse(temp.split('/').first),
                                //               );

                                //               return FutureBuilder(
                                //                   future: FirebaseFirestore.instance
                                //                       .collection('Event-Registrations')
                                //                       .doc(docSnap['Name'])
                                //                       .collection('Registered-Users')
                                //                       .doc(FirebaseAuth
                                //                           .instance.currentUser?.uid)
                                //                       .get(),
                                //                   builder: (context, snapshot) {
                                //                     bool userRegistered = snapshot.hasData &&
                                //                         snapshot.data!.exists;

                                //                     Future<String> paymentDone() async {
                                //                       final value = await FirebaseFirestore
                                //                           .instance
                                //                           .collection('Users')
                                //                           .doc(FirebaseAuth
                                //                               .instance.currentUser?.uid)
                                //                           .get()
                                //                           .then((value) {
                                //                         return '${value.data()?['Name']}\n${value.data()?['Roll']}\n${value.data()?['Year']}\n${value.data()?['Branch']}\n${member ? 'Already a member' : 'Paid'}\n${FirebaseAuth.instance.currentUser?.uid}\n${docSnap['Name']}';
                                //                       });
                                //                       return value;
                                //                     }

                                //                     paymentDone();
                                //                     if ((eventDate.isAtSameMomentAs(
                                //                                 DateTime.now()) ||
                                //                             eventDate
                                //                                 .isAfter(DateTime.now())) &&
                                //                         userRegistered) {
                                //                       // noCount = false;
                                //                       eventExists = true;
                                //                       return Padding(
                                //                         padding: const EdgeInsets.all(0.0),
                                //                         child: GestureDetector(
                                //                           onTap: () => Navigator.push(
                                //                             context,
                                //                             MaterialPageRoute(
                                //                               builder: (context) =>
                                //                                   AboutEvent(
                                //                                 name: docSnap['Name'],
                                //                                 date: docSnap['Date'],
                                //                                 time: docSnap['Time'],
                                //                                 location: docSnap['location'],
                                //                                 url: docSnap['url'],
                                //                                 description:
                                //                                     docSnap['Description'],
                                //                                 index: 0,
                                //                               ),
                                //                             ),
                                //                           ),
                                //                           child: Card(
                                //                             child: SizedBox(
                                //                               height: 150,
                                //                               // width: 250,
                                //                               child: Row(
                                //                                 mainAxisAlignment:
                                //                                     MainAxisAlignment.start,
                                //                                 children: [
                                //                                   GestureDetector(
                                //                                     onLongPress: () {
                                //                                       showModalBottomSheet(
                                //                                         isScrollControlled:
                                //                                             true,
                                //                                         showDragHandle: true,
                                //                                         context: context,
                                //                                         builder: ((context) =>
                                //                                             FractionallySizedBox(
                                //                                               heightFactor:
                                //                                                   0.8,
                                //                                               widthFactor: 1,
                                //                                               child:
                                //                                                   SingleChildScrollView(
                                //                                                 child: Column(
                                //                                                   mainAxisAlignment:
                                //                                                       MainAxisAlignment
                                //                                                           .center,
                                //                                                   children: [
                                //                                                     InteractiveViewer(
                                //                                                         maxScale:
                                //                                                             5,
                                //                                                         child:
                                //                                                             SizedBox(
                                //                                                           height:
                                //                                                               MediaQuery.of(context).size.height - (4 * (AppBar().preferredSize.height)),
                                //                                                           child:
                                //                                                               Column(
                                //                                                             mainAxisAlignment: MainAxisAlignment.center,
                                //                                                             children: [
                                //                                                               Card(
                                //                                                                 elevation: 25,
                                //                                                                 child: Container(
                                //                                                                   height: 300,
                                //                                                                   width: 300,
                                //                                                                   decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, borderRadius: BorderRadius.circular(13)),
                                //                                                                   child: Padding(
                                //                                                                     padding: const EdgeInsets.all(15.0),
                                //                                                                     child: FutureBuilder(
                                //                                                                         future: paymentDone(),
                                //                                                                         builder: (context, snapshot) {
                                //                                                                           if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                //                                                                             return PrettyQrView.data(
                                //                                                                                 data: snapshot.data!,
                                //                                                                                 decoration: PrettyQrDecoration(
                                //                                                                                   shape: PrettyQrSmoothSymbol(
                                //                                                                                     color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                                //                                                                                   ),
                                //                                                                                   // image: PrettyQrDecorationImage(
                                //                                                                                   //   fit: BoxFit.scaleDown,
                                //                                                                                   //   position: PrettyQrDecorationImagePosition.embedded,
                                //                                                                                   //   image: AssetImage(Theme.of(context).brightness == Brightness.dark ? 'assets/CSI-MJCET black.png' : 'assets/CSI-MJCET white.png'),
                                //                                                                                   // ),
                                //                                                                                 ));
                                //                                                                           }
                                //                                                                           return const Center(
                                //                                                                             child: CircularProgressIndicator(),
                                //                                                                           );
                                //                                                                         }),
                                //                                                                   ),
                                //                                                                 ),
                                //                                                               ),
                                //                                                             ],
                                //                                                           ),
                                //                                                         )),
                                //                                                   ],
                                //                                                 ),
                                //                                               ),
                                //                                             )),
                                //                                       );
                                //                                     },
                                //                                     child: ClipRRect(
                                //                                       borderRadius:
                                //                                           BorderRadius
                                //                                               .circular(12),
                                //                                       child: Column(
                                //                                         mainAxisAlignment:
                                //                                             MainAxisAlignment
                                //                                                 .center,
                                //                                         children: [
                                //                                           Container(
                                //                                             height: 150,
                                //                                             decoration: BoxDecoration(
                                //                                                 color: Theme.of(context)
                                //                                                             .brightness ==
                                //                                                         Brightness
                                //                                                             .dark
                                //                                                     ? Colors
                                //                                                         .white
                                //                                                     : Colors
                                //                                                         .black,
                                //                                                 borderRadius:
                                //                                                     BorderRadius
                                //                                                         .circular(
                                //                                                             13)),
                                //                                             child: Padding(
                                //                                                 padding:
                                //                                                     const EdgeInsets
                                //                                                         .all(
                                //                                                         15.0),
                                //                                                 child:
                                //                                                     FutureBuilder(
                                //                                                         future:
                                //                                                             paymentDone(),
                                //                                                         builder:
                                //                                                             (context, snapshot) {
                                //                                                           if (snapshot.hasData &&
                                //                                                               snapshot.data!.isNotEmpty) {
                                //                                                             return PrettyQrView.data(
                                //                                                                 data: snapshot.data!,
                                //                                                                 decoration: PrettyQrDecoration(
                                //                                                                   shape: PrettyQrSmoothSymbol(
                                //                                                                     color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                                //                                                                   ),
                                //                                                                   // image: PrettyQrDecorationImage(
                                //                                                                   //   fit: BoxFit.scaleDown,
                                //                                                                   //   position: PrettyQrDecorationImagePosition.embedded,
                                //                                                                   //   image: AssetImage(Theme.of(context).brightness == Brightness.dark ? 'assets/CSI-MJCET black.png' : 'assets/CSI-MJCET white.png'),
                                //                                                                   // ),
                                //                                                                 ));
                                //                                                           }
                                //                                                           return const Center(
                                //                                                             child: CircularProgressIndicator(),
                                //                                                           );
                                //                                                         })),
                                //                                           ),
                                //                                         ],
                                //                                       ),
                                //                                     ),
                                //                                   ),
                                //                                   Padding(
                                //                                     padding: const EdgeInsets
                                //                                         .fromLTRB(
                                //                                         20, 5, 20, 5),
                                //                                     child: Column(
                                //                                       mainAxisAlignment:
                                //                                           MainAxisAlignment
                                //                                               .spaceEvenly,
                                //                                       crossAxisAlignment:
                                //                                           CrossAxisAlignment
                                //                                               .start,
                                //                                       children: [
                                //                                         Text(docSnap['Name'],
                                //                                             style: Theme.of(
                                //                                                     context)
                                //                                                 .textTheme
                                //                                                 .titleMedium!
                                //                                                 .copyWith(
                                //                                                   // fontSize:
                                //                                                   //     20,
                                //                                                   fontWeight:
                                //                                                       FontWeight
                                //                                                           .bold,
                                //                                                 )
                                //                                             //     const TextStyle(
                                //                                             //   fontSize: 20,
                                //                                             //   fontWeight:
                                //                                             //       FontWeight
                                //                                             //           .bold,
                                //                                             // ),
                                //                                             ),
                                //                                         Text(
                                //                                           docSnap['Date'],
                                //                                           style: Theme.of(
                                //                                                   context)
                                //                                               .textTheme
                                //                                               .titleMedium!,
                                //                                           // const TextStyle(
                                //                                           //     fontSize: 16,
                                //                                           //     fontWeight:
                                //                                           //         FontWeight
                                //                                           //             .w600),
                                //                                         ),
                                //                                         Text(
                                //                                           docSnap['Time'],
                                //                                           style: Theme.of(
                                //                                                   context)
                                //                                               .textTheme
                                //                                               .titleMedium!,
                                //                                           // const TextStyle(
                                //                                           //     fontSize: 16,
                                //                                           //     fontWeight:
                                //                                           //         FontWeight
                                //                                           //             .w600),
                                //                                         ),
                                //                                         Text(
                                //                                           docSnap['location'],
                                //                                           style: Theme.of(
                                //                                                   context)
                                //                                               .textTheme
                                //                                               .titleMedium!,
                                //                                           // const TextStyle(
                                //                                           //     fontSize: 17,
                                //                                           //     fontWeight:
                                //                                           //         FontWeight
                                //                                           //             .w600),
                                //                                         ),
                                //                                       ],
                                //                                     ),
                                //                                   ),
                                //                                 ],
                                //                               ),
                                //                             ),
                                //                           ),
                                //                         ),
                                //                       );
                                //                     } else if (!noCount && !eventExists) {
                                //                       noCount = true;
                                //                       return const SizedBox();
                                //                     } else {
                                //                       return const SizedBox();
                                //                     }
                                //                   });
                                //             }),
                                //           ),
                                //           // if (noCount && !eventExists)
                                //           //   Padding(
                                //           //     padding: const EdgeInsets.all(0.0),
                                //           //     child: Card(
                                //           //       child: SizedBox(
                                //           //         height: 150,
                                //           //         width: 345,
                                //           //         child: Column(
                                //           //           mainAxisAlignment:
                                //           //               MainAxisAlignment.center,
                                //           //           children: [
                                //           //             const Icon(
                                //           //               Icons.watch_later_outlined,
                                //           //               size: 55,
                                //           //             ),
                                //           //             Text(
                                //           //               "No Events",
                                //           //               style: TextStyle(
                                //           //                 fontSize: Theme.of(context)
                                //           //                     .textTheme
                                //           //                     .headlineSmall!
                                //           //                     .fontSize,
                                //           //               ),
                                //           //             ),
                                //           //           ],
                                //           //         ),
                                //           //       ),
                                //           //     ),
                                //           //   )
                                //         ],
                                //       );
                                //     } else {
                                //       return const Center(child: CircularProgressIndicator());
                                //     }
                                //   }),
                                // ),
                              }),
                            ])),
                        // SizedBox(
                        //   height: 168,
                        //   child: StreamBuilder(
                        //     stream: FirebaseFirestore.instance
                        //         .collection('Info-Cards')
                        //         .snapshots(),
                        //     builder: ((context, snapshot) {
                        //       if (snapshot.hasData) {
                        //         return ListView.builder(
                        //           scrollDirection: Axis.horizontal,
                        //           itemCount: snapshot.data!.docs.length,
                        //           itemBuilder: ((context, index) {
                        //             final DocumentSnapshot docSnap =
                        //                 snapshot.data!.docs[index];
                        //             return Padding(
                        //               padding: const EdgeInsets.all(5.0),
                        //               child: Card(
                        //                 child: SizedBox(
                        //                   height: 150,
                        //                   width: 310,
                        //                   child: Row(
                        //                     mainAxisAlignment: MainAxisAlignment.start,
                        //                     children: [
                        //                       ClipRRect(
                        //                         borderRadius: BorderRadius.circular(12),
                        //                         child: Column(
                        //                           mainAxisAlignment:
                        //                               MainAxisAlignment.center,
                        //                           children: [
                        //                             Container(
                        //                               height: 150,
                        //                               decoration: BoxDecoration(
                        //                                   color: Theme.of(context)
                        //                                               .brightness ==
                        //                                           Brightness.dark
                        //                                       ? Colors.white
                        //                                       : Colors.black,
                        //                                   borderRadius:
                        //                                       BorderRadius.circular(
                        //                                           13)),
                        //                             ),
                        //                           ],
                        //                         ),
                        //                       ),
                        //                       Padding(
                        //                         padding: const EdgeInsets.fromLTRB(
                        //                             25, 5, 20, 5),
                        //                         child: Column(
                        //                           mainAxisAlignment:
                        //                               MainAxisAlignment.spaceEvenly,
                        //                           crossAxisAlignment:
                        //                               CrossAxisAlignment.start,
                        //                           children: [
                        //                             Text(
                        //                               docSnap['Headline'],
                        //                               style: const TextStyle(
                        //                                 fontSize: 20,
                        //                                 fontWeight: FontWeight.bold,
                        //                               ),
                        //                             ),
                        //                             Text(
                        //                               docSnap['Content'],
                        //                               style: const TextStyle(
                        //                                   fontSize: 16,
                        //                                   fontWeight: FontWeight.w600),
                        //                             ),
                        //                           ],
                        //                         ),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 ),
                        //               ),
                        //             );
                        //           }),
                        //         );
                        //       } else {
                        //         return const Center(child: CircularProgressIndicator());
                        //       }
                        //     }),
                        //   ),
                        // ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Info-Cards')
                                .snapshots(),
                            builder: ((context, snapshot) {
                              if (snapshot.hasData) {
                                return SizedBox(
                                  height: 150,
                                  child: Swiper(
                                    itemBuilder: (context, index) {
                                      final DocumentSnapshot docSnap =
                                          snapshot.data!.docs[index];
                                      return Card(
                                        child: Container(
                                          height: 150,
                                          width: 310,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.fitWidth,
                                                  image:
                                                      CachedNetworkImageProvider(
                                                    docSnap['url'],
                                                  )
                                                  // Image.network(docSnap['url'])
                                                  //     .image
                                                  ),
                                              borderRadius:
                                                  BorderRadius.circular(13)),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                25, 5, 20, 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(docSnap['Headline'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                docSnap[
                                                                    'Color']))
                                                    // TextStyle(
                                                    //   fontSize: 20,
                                                    //   fontWeight: FontWeight.bold,
                                                    //   color: Color(docSnap['Color']),
                                                    // ),
                                                    ),
                                                Text(
                                                  docSnap['Content'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                          color: Color(docSnap[
                                                              'Color'])),
                                                  // TextStyle(
                                                  //   fontSize: 16,
                                                  //   fontWeight: FontWeight.w600,
                                                  //   color: Color(docSnap['Color']),
                                                  // ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    autoplay: true,
                                    autoplayDelay: 12000,
                                    itemCount: 3,
                                    pagination: const SwiperPagination(
                                        builder: SwiperPagination.rect),
                                    control: const SwiperControl(
                                      color: Colors.transparent,
                                      disableColor: Colors.transparent,
                                    ),
                                  ),
                                );
                              } else {
                                return const Card();
                              }
                            }))
                      ],
                    )),
              ),
            )));
  }
}
