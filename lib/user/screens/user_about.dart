import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAboutScreen extends StatelessWidget {
  const UserAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            highlightColor: Colors.transparent,
            icon: const Icon(
              Icons.chevron_left,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: const Text('About'),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: Stack(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        widthFactor: 10,
                        heightFactor: 1,
                        child: Card(
                          elevation: 2,
                          child: SizedBox(
                            width: 300,
                            height: 250,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Center(
                                  child: Text(
                                    snapshot.data!['Name'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 220,
                        left: 0,
                        right: 0,
                        child: Card(
                          elevation: 4,
                          child: SizedBox(
                            width: 200,
                            height: 550,
                            child: Padding(
                              padding: const EdgeInsets.all(35.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  FittedBox(
                                    child: Text(
                                      snapshot.data!['Email'],
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Branch',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    snapshot.data!['Branch'],
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Roll Number',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    snapshot.data!['Roll'],
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Year',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    snapshot.data!['Year'],
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                const Icon(Icons.watch_later_outlined);
                const Text("No Events");
              }
              return const Center(child: CircularProgressIndicator());
            })),
      ),
    );
  }
}
