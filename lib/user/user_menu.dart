import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMenu extends StatelessWidget {
  const UserMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      child: ListView(
        children: [
          DrawerHeader(
            child: Text('Menu',
                style: GoogleFonts.plusJakartaSansTextTheme()
                    .displayMedium!
                    .copyWith(
                      fontSize: 40,
                      color: Theme.of(context).textTheme.displayMedium!.color,
                    )
                // TextStyle(
                //   fontSize: 40,
                // ),
                ),
            // decoration: const BoxDecoration(color: Colors.amberAccent),
          ),
          ListTile(
            title: Text('About', style: Theme.of(context).textTheme.titleMedium!
                // .copyWith(fontSize: 20)
                // TextStyle(fontSize: 20),
                ),
            onTap: () {
              Navigator.pushNamed(context, '/user-about');
            },
          ),
          ListTile(
            title: Text('Developers',
                style: Theme.of(context).textTheme.titleMedium!
                // TextStyle(fontSize: 20),
                ),
            onTap: () {
              Navigator.pushNamed(context, '/developers');
            },
          ),
          ListTile(
            title: Text('Contact HR',
                style: Theme.of(context).textTheme.titleMedium!
                // TextStyle(fontSize: 20),
                ),
            onTap: () {
              Navigator.pushNamed(context, '/contact-hr');
            },
          ),
          ListTile(
            title: Text('Your Events',
                style: Theme.of(context).textTheme.titleMedium!
                // TextStyle(fontSize: 20),
                ),
            onTap: () {
              Navigator.pushNamed(context, '/your-events');
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                backgroundColor:
                    const WidgetStatePropertyAll(Color.fromRGBO(17, 12, 49, 1)),
                minimumSize: WidgetStateProperty.all(
                  const Size.fromHeight(50),
                ),
              ),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: FittedBox(
                        child: Text('Do you want to Logout?'),
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              await FirebaseAuth.instance.signOut();
                              if (!context.mounted) return;
                              Navigator.pop(context);
                              Navigator.of(context)
                                  .pushReplacementNamed('/sign-in');
                              preferences.remove('email');
                              preferences.remove('password');
                            },
                            child: const Text('Yes'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
