import 'package:csi/admin/admin_home.dart';
import 'package:csi/admin/screens/create_event.dart';
import 'package:csi/auth/intro.dart';
import 'package:csi/auth/register1.dart';
import 'package:csi/auth/register2.dart';
import 'package:csi/auth/sign_in.dart';
import 'package:csi/services/fcm.dart';
import 'package:csi/user/screens/contact_hr.dart';
import 'package:csi/user/screens/developers.dart';
import 'package:csi/user/screens/your_events.dart';
import 'package:csi/user/screens/user_about.dart';
import 'package:csi/user/user_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FCM().initNotifications();
  // await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(themeCheck() == 'light' ? ThemeMode.light : ThemeMode.dark);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            // Remove the debug bannerz
            debugShowCheckedModeBanner: false,
            title: 'CSI App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            darkTheme: ThemeData.dark(),
            themeMode: currentMode,
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.email == 'admin@csi.com') {
                    return const AdminHomeScreen(
                      index: 0,
                    );
                  } else {
                    return const UserHomeScreen(
                      index: 0,
                    );
                  }
                  // User is logged in, navigate to the home page or another screen.
                } else {
                  // User is not logged in, show the login form or onboarding screen.
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
              '/user-home': (context) => const UserHomeScreen(
                    index: 0,
                  ),
              '/user-about': (context) => const UserAboutScreen(),
              '/developers': (context) => const AboutDevelopersScreen(),
              '/contact-hr': (context) => const ContactHR(),
              // '/about-event': (context) => const AboutEvent(),
              // '/event-register': (context) => const EventRegister(),
              '/your-events': (context) => const YourEvents(),
              '/register1': (context) => const Register1(),
              '/register2': (context) => const Register2(),
              '/sign-in': (context) => const SignIn()
            },
          );
        });
  }
}

themeCheck() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if (preferences.getString('theme') == null) {
    preferences.setString('theme', 'light');
  } else {
    return preferences.getString('theme');
  }
}
