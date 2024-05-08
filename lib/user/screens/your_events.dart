import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csi/user/screens/about_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YourEvents extends StatelessWidget {
  const YourEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Your Events'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('Events').snapshots(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      final DocumentSnapshot docSnap =
                          snapshot.data!.docs[index];

                      return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('Event-Registrations')
                              .doc(docSnap['Name'])
                              .collection('Registered-Users')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .get(),
                          builder: (context, snapshot) {
                            int count = 0;
                            bool userRegistered =
                                snapshot.hasData && snapshot.data!.exists;
                            if (userRegistered) {
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
                                  child: Card(
                                    child: SizedBox(
                                      height: 200,
                                      width: 325,
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
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                docSnap['Time'],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                docSnap['location'],
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w600),
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
                          });
                    }),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
            )),
      ),
    );
  }
}
