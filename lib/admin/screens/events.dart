// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csi/admin/screens/attendance.dart';
import 'package:csi/admin/screens/registrations.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  int index = 1;
  String? theme;
  List<String> events = [];
  List<String> queryevents = [];
  @override
  void initState() {
    loadEvents();
    super.initState();
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
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height,
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
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Events')
                                .snapshots(),
                            builder: ((context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  // scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: ((context, index) {
                                    final DocumentSnapshot docSnap =
                                        snapshot.data!.docs[index];

                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: GestureDetector(
                                        onLongPressStart: (details) {
                                          final RenderBox overlay =
                                              Overlay.of(context)
                                                      .context
                                                      .findRenderObject()
                                                  as RenderBox;
                                          final position =
                                              details.globalPosition;

                                          final relativePosition = Offset(
                                            position.dx -
                                                overlay.size.width / 10.0,
                                            position.dy,
                                          );
                                          showMenu(
                                            context: context,
                                            position: RelativeRect.fromLTRB(
                                              relativePosition.dx - 100,
                                              relativePosition.dy,
                                              relativePosition.dx - 100,
                                              0,
                                            ),
                                            items: <PopupMenuEntry>[
                                              PopupMenuItem(
                                                value: 'item1',
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.0),
                                                      child: Icon(
                                                        Icons.list_alt,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Registrations',
                                                      style: TextStyle(),
                                                    ),
                                                  ],
                                                ),
                                                onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Registrations(
                                                              name: docSnap[
                                                                  'Name'],
                                                            ))),
                                              ),
                                              PopupMenuItem(
                                                value: 'item2',
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.0),
                                                      child: Icon(
                                                        Icons
                                                            .assignment_turned_in_rounded,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Attendance',
                                                      style: TextStyle(),
                                                    ),
                                                  ],
                                                ),
                                                onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Attendance(
                                                              name: docSnap[
                                                                  'Name'],
                                                            ))),
                                              ),
                                              PopupMenuItem(
                                                  value: 'item3',
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    5.0),
                                                        child: Icon(
                                                            Icons.delete,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .error),
                                                      ),
                                                      Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .error),
                                                      ),
                                                    ],
                                                  ),
                                                  onTap: () => showDialog(
                                                      context: context,
                                                      builder:
                                                          (context) =>
                                                              AlertDialog(
                                                                title: Text(
                                                                    'Do you want to Delete ${docSnap['Name']}?'),
                                                                content: const Text(
                                                                    'This can\'t be undone!'),
                                                                actions: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () async {
                                                                            Navigator.pop(context);
                                                                            try {
                                                                              await FirebaseFirestore.instance.collection('Events').doc(docSnap['Name']).delete();
                                                                              Reference storageRef = FirebaseStorage.instance.refFromURL(docSnap['url']);

                                                                              await storageRef.delete();
                                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event deleted successfully')));
                                                                            } catch (error) {
                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting document: $error')));
                                                                            }
                                                                          },
                                                                          child:
                                                                              const Text('Yes')),
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              const Text('No')),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ))),
                                            ],
                                          );
                                        },
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Registrations(
                                                      name: docSnap['Name'],
                                                    ))),
                                        child: Card(
                                          child: SizedBox(
                                            height: 200,
                                            width: 325,
                                            child: ListView(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.start,
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
                                                                    child: Hero(
                                                                      tag:
                                                                          'poster',
                                                                      child: Image
                                                                          .network(
                                                                        docSnap[
                                                                            'url'],
                                                                        fit: BoxFit
                                                                            .fitWidth,
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
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                    );
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: Image.network(
                                                      docSnap['url'],
                                                      height: 200,
                                                      width: 135,
                                                      fit: BoxFit.fill,
                                                      loadingBuilder: (BuildContext
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
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 5, 0, 5),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(docSnap['Name'],
                                                          style:
                                                              Theme.of(context)
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
                                                        docSnap['Date'],
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!,
                                                        // const TextStyle(
                                                        //     fontSize: 16,
                                                        //     fontWeight:
                                                        //         FontWeight
                                                        //             .w600),
                                                      ),
                                                      Text(
                                                        docSnap['Time'],
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!,
                                                        // const TextStyle(
                                                        //     fontSize: 16,
                                                        //     fontWeight:
                                                        //         FontWeight
                                                        //             .w600),
                                                      ),
                                                      Text(
                                                        docSnap['location'],
                                                        style: Theme.of(context)
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
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                          ),
                        ),
                        buildFloatingSearchBar(),
                      ],
                    ),
                  ))),
        ),
      ),
    );
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
      onFocusChanged: (isFocused) {
        queryevents = events;
      },
      automaticallyImplyBackButton: false,
      onQueryChanged: (query) {
        List<String> matchQuery = [];
        for (var name in events) {
          if (name.toLowerCase().contains(query.toLowerCase())) {
            matchQuery.add(name);
          }
        }
        setState(() {
          queryevents = matchQuery;
        });
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction.searchToClear(
          showIfClosed: true,
        ),
      ],
      builder: (context, transition) {
        return Material(
          color: Theme.of(context).cardColor.withOpacity(0.75),
          elevation: 4.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: queryevents.map((doc) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Registrations(
                                name: doc,
                              ))),
                  title: Center(child: Text(doc)),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
