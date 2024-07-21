import 'package:csi/admin/admin_home.dart';
import 'package:csi/services/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({Key? key}) : super(key: key);

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> with WidgetsBindingObserver {
  int index = 1;
  String? theme;
  String? name;
  String? uid;
  String? event;
  String? status;
  Barcode? _barcode;
  bool approved = false;
  late MobileScannerController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = MobileScannerController();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      controller.stop();
    } else if (state == AppLifecycleState.resumed) {
      controller.start();
    }
  }

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        '',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    setState(() {
      name = value.displayValue!.split("\n").first;
      status = value.displayValue!.split("\n")[4];
      uid = value.displayValue!.split("\n")[5];
      event = value.displayValue!.split("\n").last;
    });

    return ListTile(
      title: Text(
        name ?? 'No display value.',
        overflow: TextOverflow.fade,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        status ?? 'No display value.',
        overflow: TextOverflow.fade,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: ElevatedButton(
          onPressed: approved
              ? () {}
              : () async {
                  await FirebaseFirestore.instance
                      .collection("Event-Registrations")
                      .doc(event)
                      .collection("Attended-Users")
                      .doc(uid)
                      .set({
                    'Name': value.displayValue!.split("\n").first,
                    'Roll': value.displayValue!.split("\n")[1],
                    'Year': value.displayValue!.split("\n")[2],
                    'Branch': value.displayValue!.split("\n")[3],
                    'Status': value.displayValue!.split("\n")[4],
                  });
                  setState(() {
                    approved = true;
                  });
                },
          style: approved
              ? const ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(Colors.transparent))
              : Theme.of(context).elevatedButtonTheme.style,
          child: approved ? const Icon(Icons.check) : const Text('Approve')),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Stack(
              children: [
                MobileScanner(
                  controller: controller,
                  onDetect: _handleBarcode,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    height: 100,
                    color: Colors.black.withOpacity(0.4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: Center(child: _buildBarcode(_barcode))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: ClipPath(
                clipper: ReverseBorderRadiusClipper(50.0),
                child: Container(
                  height: 50,
                  width: 50,
                  color: const Color.fromRGBO(17, 12, 49, 1),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromRGBO(17, 12, 49, 1),
                Color.fromRGBO(17, 12, 49, 1),
                Colors.transparent,
                Colors.transparent,
              ])),
              child: Container(
                  height: 100.5,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(17, 12, 49, 1),
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(50))),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  icon: Icon(Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Icons.dark_mode
                                      : Icons.light_mode),
                                ),
                                IconButton(
                                    color: Colors.white,
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: FittedBox(
                                                      child: Text(
                                                    'Do you want to Logout?',
                                                    style: Theme.of(context)
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
                                                          onPressed: () async {
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
                                                            preferences.remove(
                                                                'email');
                                                            preferences.remove(
                                                                'password');
                                                          },
                                                          child: const Text(
                                                              'Yes')),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text('No')),
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
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 10,
          // backgroundColor: Colors.blue,
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
              if (index != 1) {
                Navigator.of(context).removeRoute(ModalRoute.of(context)!);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminHomeScreen(
                              index: index,
                            )));
              } else {
                Navigator.of(context).removeRoute(ModalRoute.of(context)!);
              }
            });
          },
          selectedLabelStyle: GoogleFonts.poppins(),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.qr_code_2), label: 'Scan'),
            BottomNavigationBarItem(
                icon: Icon(Icons.table_chart), label: 'Events'),
            BottomNavigationBarItem(
                icon: Icon(Icons.card_membership_rounded), label: 'Membership'),
            BottomNavigationBarItem(
                icon: Icon(Icons.event_repeat), label: 'Customize Event'),
          ]),
    ));
  }
}

class ReverseBorderRadiusClipper extends CustomClipper<Path> {
  final double radius;

  ReverseBorderRadiusClipper(this.radius);

  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(radius, 0)
      ..lineTo(0, 0)
      ..lineTo(0, size.height)
      ..arcToPoint(
        Offset(radius, 0),
        clockwise: true,
        radius: Radius.circular(radius),
      );

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
