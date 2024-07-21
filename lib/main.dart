import 'package:csi/admin/admin_home.dart';
import 'package:csi/admin/screens/create_event.dart';
import 'package:csi/auth/intro.dart';
import 'package:csi/auth/onboarding.dart';
import 'package:csi/auth/register1.dart';
import 'package:csi/auth/sign_in.dart';
import 'package:csi/global/theme.dart';
import 'package:csi/services/fcm.dart';
import 'package:csi/services/provider.dart';
import 'package:csi/user/screens/all_events.dart';
import 'package:csi/user/screens/contact_hr.dart';
import 'package:csi/user/screens/developers.dart';
import 'package:csi/user/screens/your_events.dart';
import 'package:csi/user/screens/user_about.dart';
import 'package:csi/user/user_zoom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FCM().initNotifications();

  try {
    await dotenv.load(fileName: "assets/.env");
  } catch (e) {
    debugPrint('Error loading .env file: $e');
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => CSIProvider(),
      child: MyApp(),
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static ValueNotifier<ThemeMode> csiProvider = ValueNotifier(ThemeMode.light);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CSIProvider>(context, listen: false).loadHomeEvents();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CSIProvider>(context, listen: false).loadExploreEvents();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CSIProvider>(context, listen: false).loadYourEvents();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CSIProvider>(
      builder: (context, csiProvider, child) {
        if (!csiProvider.isInitialized) {
          return CircularProgressIndicator();
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CSI App',
          theme: MaterialTheme(context).light(),
          darkTheme: MaterialTheme(context).dark(),
          themeMode: csiProvider.themeMode,
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.email == 'admin@csi.com') {
                  return const AdminHomeScreen(
                    index: 0,
                  );
                } else {
                  return const UserZoomDrawer(
                    index: 0,
                  );
                }
              } else {
                return const Intro();
              }
            },
          ),
          routes: {
            '/create-event': (context) => const CreateEventScreen(),
            '/intro': (context) => const Intro(),
            '/admin-home': (context) => const AdminHomeScreen(
                  index: 0,
                ),
            '/user-home': (context) => const UserZoomDrawer(
                  index: 0,
                ),
            '/user-about': (context) => const UserAboutScreen(),
            '/all-events': (context) => const AllEvents(),
            '/developers': (context) => const AboutDevelopersScreen(),
            '/contact-hr': (context) => const ContactHR(),
            // '/about-event': (context) => const AboutEvent(),
            // '/event-register': (context) => const EventRegister(),
            '/your-events': (context) => const YourEvents(),
            '/onboarding': (context) => const OnBoardingPage(),
            '/register1': (context) => const Register1(),
            // '/register2': (context) => const Register2(),
            '/sign-in': (context) => const SignIn()
          },
        );
      },
    );
  }
}
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   static ValueNotifier<ThemeMode> csiProvider =
//       ValueNotifier(ThemeMode.light);
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     setState(() {
//       getTheme();
//     });
//     return ValueListenableBuilder<ThemeMode>(
//         valueListenable: MyApp.csiProvider,
//         builder: (context, ThemeMode currentMode, __) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             title: 'CSI App',
//             theme: MaterialTheme(context).light(),
//             darkTheme: MaterialTheme(context).dark(),
//             themeMode: currentMode,
//             home: StreamBuilder(
//               stream: FirebaseAuth.instance.authStateChanges(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   if (snapshot.data!.email == 'admin@csi.com') {
//                     return const AdminHomeScreen(
//                       index: 0,
//                     );
//                   } else {
//                     return const UserZoomDrawer(
//                       index: 0,
//                     );
//                   }
//                 } else {
//                   return const Intro();
//                 }
//               },
//             ),
//             routes: {
//               '/create-event': (context) => const CreateEventScreen(),
//               '/intro': (context) => const Intro(),
//               '/admin-home': (context) => const AdminHomeScreen(
//                     index: 0,
//                   ),
//               '/user-home': (context) => const UserZoomDrawer(
//                     index: 0,
//                   ),
//               '/user-about': (context) => const UserAboutScreen(),
//               '/all-events': (context) => const AllEvents(),
//               '/developers': (context) => const AboutDevelopersScreen(),
//               '/contact-hr': (context) => const ContactHR(),
//               // '/about-event': (context) => const AboutEvent(),
//               // '/event-register': (context) => const EventRegister(),
//               '/your-events': (context) => const YourEvents(),
//               '/onboarding': (context) => const OnBoardingPage(),
//               '/register1': (context) => const Register1(),
//               // '/register2': (context) => const Register2(),
//               '/sign-in': (context) => const SignIn()
//             },
//           );
//         });
//   }

//   getTheme() async {
//     final temp = await themeCheck();
//     final ThemeMode theme = temp == 'light' ? ThemeMode.dark : ThemeMode.light;
//     setState(() {
//       MyApp.csiProvider = ValueNotifier(theme);
//     });
//   }

//   themeCheck() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     if (preferences.getString('theme') == null) {
//       preferences.setString('theme', 'light');
//     }
//     return preferences.getString('theme');
//   }
// }
