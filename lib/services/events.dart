import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventsProvider with ChangeNotifier {
  List<List> _homeEvents = [];
  List<List> _exploreEvents = [];
  List<List> _yourEvents = [];
  bool _isLoadingHome = true;
  bool _isLoadingExplore = true;
  bool _isLoadingEvents = true;

  List<List> get homeEvents => _homeEvents;
  List<List> get exploreEvents => _exploreEvents;
  List<List> get yourEvents => _yourEvents;
  bool get isLoadingHome => _isLoadingHome;
  bool get isLoadingExplore => _isLoadingExplore;
  bool get isLoadingEvents => _isLoadingEvents;

  Future<void> loadHomeEvents(bool member) async {
    _isLoadingHome = true;
    notifyListeners();

    List<List> temp2 = [];
    final docSnap1 =
        await FirebaseFirestore.instance.collection('Events').get();
    for (final doc in docSnap1.docs) {
      final docSnap2 = await FirebaseFirestore.instance
          .collection('Event-Registrations')
          .doc(doc.id)
          .collection('Registered-Users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      if (docSnap2.exists) {
        String temp = doc['Date'];
        DateTime eventDate = DateTime(
          int.parse(temp.split('/').last),
          int.parse(temp.split('/')[1]),
          int.parse(temp.split('/').first),
        );
        Future<String> paymentDone() async {
          final value = await FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .get()
              .then((value) {
            return '${value.data()?['Name']}\n${value.data()?['Roll']}\n${value.data()?['Year']}\n${value.data()?['Branch']}\n${member ? 'Already a member' : 'Paid'}\n${FirebaseAuth.instance.currentUser?.uid}\n${doc['Name']}';
          });
          return value;
        }

        paymentDone();
        if ((eventDate.isAtSameMomentAs(DateTime.now()) ||
            eventDate.isAfter(DateTime.now()))) {
          temp2.add([
            doc['Name'],
            doc['Date'],
            doc['Time'],
            doc['location'],
            doc['url'],
            doc['Description'],
          ]);
        }
      }
    }

    _homeEvents = temp2;
    _isLoadingHome = false;
    notifyListeners();
  }

  Future<void> loadExploreEvents() async {
    _isLoadingExplore = true;
    notifyListeners();

    List<List> temp2 = [];
    final docSnap1 =
        await FirebaseFirestore.instance.collection('Events').get();
    for (final doc in docSnap1.docs) {
      final docSnap2 = await FirebaseFirestore.instance
          .collection('Events')
          .doc(doc.id)
          .get();
      if (docSnap2.exists) {
        String temp = doc['Date'];
        DateTime eventDate = DateTime(
          int.parse(temp.split('/').last),
          int.parse(temp.split('/')[1]),
          int.parse(temp.split('/').first),
        );

        if ((eventDate.isAtSameMomentAs(DateTime.now()) ||
            eventDate.isAfter(DateTime.now()))) {
          temp2.add([
            doc['Name'],
            doc['Date'],
            doc['Time'],
            doc['location'],
            doc['url'],
            doc['Description'],
          ]);
        }
      }
    }

    _exploreEvents = temp2;
    _isLoadingExplore = false;
    notifyListeners();
  }

  Future<void> loadYourEvents() async {
    _isLoadingEvents = true;
    notifyListeners();

    List<String> temp1 = [];
    List<List> temp2 = [];
    final docSnap1 =
        await FirebaseFirestore.instance.collection('Events').get();
    for (final doc in docSnap1.docs) {
      final docSnap2 = await FirebaseFirestore.instance
          .collection('Event-Registrations')
          .doc(doc.id)
          .collection('Registered-Users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      if (docSnap2.exists) {
        temp1.add(doc.id);
        temp2.add([
          doc['Name'],
          doc['Date'],
          doc['Time'],
          doc['location'],
          doc['url'],
          doc['Description'],
        ]);
      }
    }

    _yourEvents = temp2;
    _isLoadingEvents = false;
    notifyListeners();
  }
}
