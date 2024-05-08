import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csi/admin/screens/registrations.dart';
import 'package:csi/admin/screens/scan_qr.dart';
import 'package:csi/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

class AdminHomeScreen extends StatefulWidget {
  final int index;

  const AdminHomeScreen({super.key, required this.index});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int index = 0;
  String? theme;
  List<String> events = [];
  List<String> queryevents = [];
  @override
  void initState() {
    index = widget.index;
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
    List<Widget> adminWidgetList = [
      const Text('Home'),
      const ScanQR(),
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
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
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Registrations(
                                            name: docSnap['Name'],
                                          ))),
                              child: Card(
                                shadowColor: Colors.blue.shade700,
                                elevation: 8,
                                child: SizedBox(
                                  height: 200,
                                  width: 100,
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
                                                  )));
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
                                          Text(docSnap['Name'],
                                              style: const TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          Text(docSnap['Date'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                          Text(docSnap['Time'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                          Text(docSnap['location'],
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }));
                  } else {
                    const Icon(Icons.watch_later_outlined);
                    const Text("No Events");
                  }
                  return const Center(child: CircularProgressIndicator());
                })),
          ),
          buildFloatingSearchBar(),
        ],
      ),
      const Text('Memberships'),
    ];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
                  });
                  MyApp.themeNotifier.value =
                      theme == 'light' ? ThemeMode.dark : ThemeMode.light;
                }
              },
              icon: Icon(theme == 'dark' ? Icons.dark_mode : Icons.light_mode),
            ),
            IconButton(
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
                                        final SharedPreferences preferences =
                                            await SharedPreferences
                                                .getInstance();
                                        await FirebaseAuth.instance.signOut();
                                        // ignore: use_build_context_synchronously
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
                  // final SharedPreferences preferences =
                  //     await SharedPreferences.getInstance();
                  // await FirebaseAuth.instance.signOut();
                  // Navigator.of(context).pushNamed('/sign-in');
                  // preferences.remove('email');
                  // preferences.remove('password');
                },
                icon: const Icon(Icons.logout)),
          ],
          automaticallyImplyLeading: false,
          title: const Text('Admin View'),
          centerTitle: true,
        ),
        body: Center(child: adminWidgetList[index]),
        bottomNavigationBar: BottomNavigationBar(
            elevation: 10,
            backgroundColor: Colors.blue,
            currentIndex: index,
            // showSelectedLabels: false,
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
                  icon: Icon(Icons.qr_code_2), label: 'Scan'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.table_chart), label: 'Registration'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.card_membership_rounded),
                  label: 'Membership'),
            ]),
        floatingActionButton: FloatingActionButton(
            child: const Icon(CupertinoIcons.calendar_badge_plus),
            onPressed: () {
              Navigator.of(context).pushNamed('/create-event');
            }),
      ),
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search...',
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
      onSubmitted: (query) {
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
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
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
          ),
        );
      },
    );
  }
}
