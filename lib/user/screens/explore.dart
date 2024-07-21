import 'package:csi/services/provider.dart';
import 'package:csi/user/screens/about_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  // List<List> Provider.of<CSIProvider>(context, listen: false).exploreEvents = [];

  @override
  void initState() {
    // loadEvents();
    if (Provider.of<CSIProvider>(context, listen: false).exploreEvents.isEmpty
        // &&
        // Provider.of<CSIProvider>(context, listen: false).isLoadedExplore ==
        //     false
        ) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<CSIProvider>(context, listen: false).loadExploreEvents();
      });
    }
    super.initState();
  }

  // Future<List<List>> loadEvents() async {
  //   List<List> temp2 = [];
  //   final docSnap1 =
  //       await FirebaseFirestore.instance.collection('Events').get();
  //   for (final doc in docSnap1.docs) {
  //     final docSnap2 = await FirebaseFirestore.instance
  //         .collection('Events')
  //         .doc(doc.id)
  //         .get();
  //     if (docSnap2.exists) {
  //       String temp = doc['Date'];
  //       DateTime eventDate = DateTime(
  //         int.parse(temp.split('/').last),
  //         int.parse(temp.split('/')[1]),
  //         int.parse(temp.split('/').first),
  //       );

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
  //     Provider.of<CSIProvider>(context, listen: false).exploreEvents = temp2;
  //   });
  //   return temp2;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(17, 12, 49, 1),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius:
                      const BorderRadius.only(topLeft: Radius.circular(50))),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
                  child: RefreshIndicator(
                      onRefresh: () =>
                          Provider.of<CSIProvider>(context, listen: false)
                              .loadExploreEvents(),
                      child:
                          // FutureBuilder(
                          //     future:
                          //         Provider.of<CSIProvider>(context, listen: false)
                          //             .loadExploreEvents(),
                          //     builder: (context, snapshot) {
                          //       if (snapshot.hasData) {
                          //         return
                          Consumer<CSIProvider>(
                              builder: (context, csiProvider, child) {
                        // if (
                        //     // csiProvider.isLoadingExplore &&
                        //     csiProvider.isLoadedExplore == false) {
                        //   return Center(child: CircularProgressIndicator());
                        // }
                        // ignore: prefer_is_empty
                        return Provider.of<CSIProvider>(context, listen: false)
                                    .exploreEvents
                                    .length >
                                0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 5),
                                    child: Text('Upcoming:',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w600)),
                                  ),
                                  ListView.builder(
                                      // scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: Provider.of<CSIProvider>(
                                              context,
                                              listen: false)
                                          .exploreEvents
                                          .length,
                                      itemBuilder: ((context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(5.0),
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
                                                      .exploreEvents[index][0],
                                                  date: Provider.of<
                                                              CSIProvider>(
                                                          context,
                                                          listen: false)
                                                      .exploreEvents[index][1],
                                                  time: Provider.of<
                                                              CSIProvider>(
                                                          context,
                                                          listen: false)
                                                      .exploreEvents[index][2],
                                                  location: Provider.of<
                                                              CSIProvider>(
                                                          context,
                                                          listen: false)
                                                      .exploreEvents[index][3],
                                                  url: Provider.of<CSIProvider>(
                                                          context,
                                                          listen: false)
                                                      .exploreEvents[index][4],
                                                  description: Provider.of<
                                                              CSIProvider>(
                                                          context,
                                                          listen: false)
                                                      .exploreEvents[index][5],
                                                ),
                                              ),
                                            ),
                                            child: Card(
                                              child: SizedBox(
                                                height: 200,
                                                width: 325,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                      onLongPress: () {
                                                        showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          showDragHandle: true,
                                                          context: context,
                                                          builder: ((context) =>
                                                              FractionallySizedBox(
                                                                heightFactor:
                                                                    0.8,
                                                                child: Expanded(
                                                                  child:
                                                                      InteractiveViewer(
                                                                    maxScale: 5,
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              21.5),
                                                                      child: Image
                                                                          .network(
                                                                        Provider.of<CSIProvider>(context,
                                                                                listen: false)
                                                                            .exploreEvents[index][4],
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        loadingBuilder: (BuildContext context,
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
                                                                                Alignment.center,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                        );
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child: Image.network(
                                                          Provider.of<CSIProvider>(
                                                                      context,
                                                                      listen: false)
                                                                  .exploreEvents[
                                                              index][4],
                                                          height: 200,
                                                          width: 135,
                                                          fit: BoxFit.fill,
                                                          loadingBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  Widget child,
                                                                  ImageChunkEvent?
                                                                      loadingProgress) {
                                                            if (loadingProgress ==
                                                                null) {
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
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          20, 5, 0, 5),
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
                                                                      .exploreEvents[
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
                                                                    .exploreEvents[
                                                                index][1],
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
                                                                    .exploreEvents[
                                                                index][2],
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
                                                                    .exploreEvents[
                                                                index][3],
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
                                      }
                                          // else if (count == 0) {
                                          //   count++;
                                          //   return Padding(
                                          //     padding: const EdgeInsets.all(5.0),
                                          //     child: Card(
                                          //       child: SizedBox(
                                          //           height: 200,
                                          //           width: 325,
                                          //           child: Column(
                                          //             mainAxisAlignment:
                                          //                 MainAxisAlignment.center,
                                          //             children: [
                                          //               const Icon(
                                          //                 Icons.watch_later_outlined,
                                          //                 size: 55,
                                          //               ),
                                          //               const SizedBox(
                                          //                 height: 10,
                                          //               ),
                                          //               Text("No Upcoming Events",
                                          //                   style: Theme.of(context)
                                          //                       .textTheme
                                          //                       .titleLarge!
                                          //                   // TextStyle(
                                          //                   //   fontSize: Theme.of(context)
                                          //                   //       .textTheme
                                          //                   //       .titleLarge!
                                          //                   //       .fontSize,
                                          //                   // ),
                                          //                   )
                                          //             ],
                                          //           )),
                                          //     ),
                                          //   );
                                          // }
                                          ))
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Center(
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      SizedBox(
                                        height: 150,
                                        width: 345,
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
                                    ],
                                  ),
                                ),
                              );
                      })
                      //   return const Center(
                      //       child: CircularProgressIndicator());
                      // }),
                      )
                  //                   Padding(
                  //   padding: const EdgeInsets.all(5.0),
                  //   child: Card(
                  //     child: SizedBox(
                  //         height: 200,
                  //         width: 325,
                  //         child: Column(
                  //           mainAxisAlignment:
                  //               MainAxisAlignment.center,
                  //           children: [
                  //             const Icon(
                  //               Icons.watch_later_outlined,
                  //               size: 55,
                  //             ),
                  //             const SizedBox(
                  //               height: 10,
                  //             ),
                  //             Text("No Upcoming Events",
                  //                 style: Theme.of(context)
                  //                     .textTheme
                  //                     .titleLarge!
                  //                 // TextStyle(
                  //                 //   fontSize: Theme.of(context)
                  //                 //       .textTheme
                  //                 //       .titleLarge!
                  //                 //       .fontSize,
                  //                 // ),
                  //                 )
                  //           ],
                  //         )),
                  //   ),
                  // )

                  // StreamBuilder(
                  //   stream: FirebaseFirestore.instance
                  //       .collection('Events')
                  //       .snapshots(),
                  //   builder: ((context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       int count = 0;
                  //       return Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                  //             child: Text('Upcoming:',
                  //                 style: Theme.of(context)
                  //                     .textTheme
                  //                     .titleLarge!
                  //                     .copyWith(fontWeight: FontWeight.w600)),
                  //           ),
                  //           ListView.builder(
                  //               // scrollDirection: Axis.vertical,
                  //               shrinkWrap: true,
                  //               itemCount: snapshot.data!.docs.length,
                  //               itemBuilder: ((context, index) {
                  //                 final DocumentSnapshot docSnap =
                  //                     snapshot.data!.docs[index];
                  //                 String temp = docSnap['Date'];
                  //                 DateTime eventDate = DateTime(
                  //                   int.parse(temp.split('/').last),
                  //                   int.parse(temp.split('/')[1]),
                  //                   int.parse(temp.split('/').first),
                  //                 );
                  //                 if (eventDate.isAfter(DateTime.now())) {
                  //                   count++;
                  //                   return Padding(
                  //                     padding: const EdgeInsets.all(5.0),
                  //                     child: GestureDetector(
                  //                       onTap: () => Navigator.push(
                  //                         context,
                  //                         MaterialPageRoute(
                  //                           builder: (context) => AboutEvent(
                  //                             name: docSnap['Name'],
                  //                             date: docSnap['Date'],
                  //                             time: docSnap['Time'],
                  //                             location: docSnap['location'],
                  //                             url: docSnap['url'],
                  //                             description: docSnap['Description'],
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       child: Card(
                  //                         child: SizedBox(
                  //                           height: 200,
                  //                           width: 325,
                  //                           child: Row(
                  //                             mainAxisAlignment:
                  //                                 MainAxisAlignment.start,
                  //                             children: [
                  //                               GestureDetector(
                  //                                 onLongPress: () {
                  //                                   showModalBottomSheet(
                  //                                     isScrollControlled: true,
                  //                                     showDragHandle: true,
                  //                                     context: context,
                  //                                     builder: ((context) =>
                  //                                         FractionallySizedBox(
                  //                                           heightFactor: 0.8,
                  //                                           child: Expanded(
                  //                                             child:
                  //                                                 InteractiveViewer(
                  //                                               maxScale: 5,
                  //                                               child: ClipRRect(
                  //                                                 borderRadius:
                  //                                                     BorderRadius
                  //                                                         .circular(
                  //                                                             21.5),
                  //                                                 child: Image
                  //                                                     .network(
                  //                                                   docSnap[
                  //                                                       'url'],
                  //                                                   fit: BoxFit
                  //                                                       .fill,
                  //                                                   loadingBuilder: (BuildContext
                  //                                                           context,
                  //                                                       Widget
                  //                                                           child,
                  //                                                       ImageChunkEvent?
                  //                                                           loadingProgress) {
                  //                                                     if (loadingProgress ==
                  //                                                         null) {
                  //                                                       return child;
                  //                                                     }
                  //                                                     return Align(
                  //                                                       alignment:
                  //                                                           Alignment
                  //                                                               .center,
                  //                                                       child:
                  //                                                           CircularProgressIndicator(
                  //                                                         value: loadingProgress.expectedTotalBytes !=
                  //                                                                 null
                  //                                                             ? loadingProgress.cumulativeBytesLoaded /
                  //                                                                 loadingProgress.expectedTotalBytes!
                  //                                                             : null,
                  //                                                       ),
                  //                                                     );
                  //                                                   },
                  //                                                 ),
                  //                                               ),
                  //                                             ),
                  //                                           ),
                  //                                         )),
                  //                                   );
                  //                                 },
                  //                                 child: ClipRRect(
                  //                                   borderRadius:
                  //                                       BorderRadius.circular(12),
                  //                                   child: Image.network(
                  //                                     docSnap['url'],
                  //                                     height: 200,
                  //                                     width: 135,
                  //                                     fit: BoxFit.fill,
                  //                                     loadingBuilder: (BuildContext
                  //                                             context,
                  //                                         Widget child,
                  //                                         ImageChunkEvent?
                  //                                             loadingProgress) {
                  //                                       if (loadingProgress ==
                  //                                           null) {
                  //                                         return child;
                  //                                       }
                  //                                       return Center(
                  //                                         child:
                  //                                             CircularProgressIndicator(
                  //                                           value: loadingProgress
                  //                                                       .expectedTotalBytes !=
                  //                                                   null
                  //                                               ? loadingProgress
                  //                                                       .cumulativeBytesLoaded /
                  //                                                   loadingProgress
                  //                                                       .expectedTotalBytes!
                  //                                               : null,
                  //                                         ),
                  //                                       );
                  //                                     },
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                               Padding(
                  //                                 padding:
                  //                                     const EdgeInsets.fromLTRB(
                  //                                         20, 5, 0, 5),
                  //                                 child: Column(
                  //                                   mainAxisAlignment:
                  //                                       MainAxisAlignment
                  //                                           .spaceEvenly,
                  //                                   crossAxisAlignment:
                  //                                       CrossAxisAlignment.start,
                  //                                   children: [
                  //                                     Text(docSnap['Name'],
                  //                                         style: Theme.of(context)
                  //                                             .textTheme
                  //                                             .titleMedium!
                  //                                             .copyWith(
                  //                                               // fontSize:
                  //                                               //     20,
                  //                                               fontWeight:
                  //                                                   FontWeight
                  //                                                       .bold,
                  //                                             )
                  //                                         //     const TextStyle(
                  //                                         //   fontSize: 20,
                  //                                         //   fontWeight:
                  //                                         //       FontWeight
                  //                                         //           .bold,
                  //                                         // ),
                  //                                         ),
                  //                                     Text(
                  //                                       docSnap['Date'],
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
                  //                                       docSnap['Time'],
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
                  //                                       docSnap['location'],
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
                  //                 }
                  //                 // else if (count == 0) {
                  //                 //   count++;
                  //                 //   return Padding(
                  //                 //     padding: const EdgeInsets.all(5.0),
                  //                 //     child: Card(
                  //                 //       child: SizedBox(
                  //                 //           height: 200,
                  //                 //           width: 325,
                  //                 //           child: Column(
                  //                 //             mainAxisAlignment:
                  //                 //                 MainAxisAlignment.center,
                  //                 //             children: [
                  //                 //               const Icon(
                  //                 //                 Icons.watch_later_outlined,
                  //                 //                 size: 55,
                  //                 //               ),
                  //                 //               const SizedBox(
                  //                 //                 height: 10,
                  //                 //               ),
                  //                 //               Text("No Upcoming Events",
                  //                 //                   style: Theme.of(context)
                  //                 //                       .textTheme
                  //                 //                       .titleLarge!
                  //                 //                   // TextStyle(
                  //                 //                   //   fontSize: Theme.of(context)
                  //                 //                   //       .textTheme
                  //                 //                   //       .titleLarge!
                  //                 //                   //       .fontSize,
                  //                 //                   // ),
                  //                 //                   )
                  //                 //             ],
                  //                 //           )),
                  //                 //     ),
                  //                 //   );
                  //                 // }
                  //                 else {
                  //                   return const SizedBox();
                  //                 }
                  //               })),
                  //         ],
                  //       );
                  //     } else {
                  //       return const Center(child: CircularProgressIndicator());
                  //     }
                  //   }),
                  // ),
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/all-events'),
        child: const Icon(Icons.calendar_month),
      ),
    );
  }
}
