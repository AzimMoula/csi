import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CSIProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  final String _themeKey = 'themeMode';
  bool _isInitialized = false;

  CSIProvider() {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isInitialized => _isInitialized;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveThemeMode(_themeMode);
    notifyListeners();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? ThemeMode.system.index;
    _themeMode = ThemeMode.values[themeIndex];
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, themeMode.index);
  }

  bool member = false;

  List<List> _homeEvents = [];
  List<List> _exploreEvents = [];
  List<List> _yourEvents = [];
  List<String> _events = [];
  List<String> _queryEvents = [];
  bool _isLoadingHome = true;
  bool _isLoadingExplore = true;
  bool _isLoadingEvents = true;
  bool _isLoadedHome = false;
  bool _isLoadedExplore = false;
  bool _isLoadedEvents = false;
  List<List> get homeEvents => _homeEvents;
  List<List> get exploreEvents => _exploreEvents;
  List<List> get yourEvents => _yourEvents;
  List<String> get events => _events;
  List<String> get queryEvents => _queryEvents;
  bool get isLoadingHome => _isLoadingHome;
  bool get isLoadingExplore => _isLoadingExplore;
  bool get isLoadingEvents => _isLoadingEvents;
  bool get isLoadedHome => _isLoadedHome;
  bool get isLoadedExplore => _isLoadedExplore;
  bool get isLoadedEvents => _isLoadedEvents;

  Future<void> loadHomeEvents() async {
    _isLoadingHome = true;
    notifyListeners();
    bool val = await FirebaseFirestore.instance
        .collection('CSI-Members')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      return value.exists ? true : false;
    });
    member = val;

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
    _isLoadedHome = false;
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
    _isLoadedExplore = false;
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

    _events = temp1;
    _queryEvents = temp1;
    _yourEvents = temp2;
    _isLoadingEvents = false;
    _isLoadedEvents = true;
    notifyListeners();
  }
}
