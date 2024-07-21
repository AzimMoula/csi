// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:csi/services/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final db = FirebaseFirestore.instance;
  final TextEditingController name = TextEditingController();
  final TextEditingController venue = TextEditingController();
  final TextEditingController price = TextEditingController(text: '50');
  final TextEditingController description = TextEditingController();
  DateTime? date;
  TimeOfDay? time;
  bool submitted = false;
  String? url;
  String? theme;

  File? poster;
  UploadTask? uploadTask;

  Future pickImage(ImageSource source) async {
    if (name.text.isEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter name of event')));
      return;
    }
    try {
      final image =
          await ImagePicker().pickImage(source: source, imageQuality: 100);
      if (image == null) return;
      final extension = image.path.split('.').last;
      final newFile =
          File('${Directory.systemTemp.path}/${name.text}.$extension');
      await image.saveTo(newFile.path);
      setState(() {
        poster = newFile;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    Navigator.pop(context);
  }

  Future uploadImage() async {
    if (poster == null) return;

    try {
      final path = 'posters/${name.text}.${poster!.path.split('.').last}';
      final fbs = FirebaseStorage.instance.ref().child(path);

      setState(() {
        uploadTask = fbs.putFile(poster!);
      });
      final snapshot = await uploadTask!.whenComplete(() {});
      var temp = await snapshot.ref.getDownloadURL().whenComplete(() {});
      setState(() {
        url = temp;
        db.collection('Events').doc(name.text).set({
          'Name': name.text,
          'Date': '${date!.day}/${date!.month}/${date!.year}',
          'Time':
              '${time!.hourOfPeriod}:${time!.minute == 0 ? '00' : time!.minute} ${time!.hour < 12 ? 'AM' : 'PM'}',
          'location': venue.text,
          'url': url!,
          'Description': description.text,
          'Price': price.text,
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Upload Complete')));
      });
      await sendNotification('events');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() {
      uploadTask = null;
    });
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;
            return Align(
              alignment: Alignment.bottomCenter,
              child: LinearProgressIndicator(
                value: progress,
              ),
            );
          } else {
            return const Text('');
          }
        },
      );
  Future<String> getAccessToken() async {
    final Map<String, dynamic> config =
        jsonDecode(dotenv.env['GOOGLE_APPLICATION_CREDENTIALS']!);
    final serviceAccountCredentials =
        ServiceAccountCredentials.fromJson(config);

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    var client =
        await clientViaServiceAccount(serviceAccountCredentials, scopes);
    return client.credentials.accessToken.data;
  }

  Future<void> sendNotification(String topic) async {
    final fburl = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/csi-app-5d154/messages:send');
    final accessToken = await getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final body = {
      'message': {
        'topic': topic,
        'notification': {
          'title': 'New Event Added!',
          'body': 'Checkout ${name.text} on the CSI app.',
          'image': url!,
        },
        'android': {
          'priority': 'high',
          'notification': {
            'image': url!,
          }
        },
        'data': {
          'Name': name.text,
          'Date': '${date!.day}/${date!.month}/${date!.year}',
          'Time':
              '${time!.hourOfPeriod}:${time!.minute == 0 ? '00' : time!.minute} ${time!.hour < 12 ? 'AM' : 'PM'}',
          'location': venue.text,
          'url': url!,
          'Description': description.text,
        }
      }
    };

    final response = await http.post(
      fburl,
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      debugPrint('Notification sent successfully to topic: $topic');
    } else {
      debugPrint(
          'Failed to send notification to topic: $topic. Error: ${response.reasonPhrase}');
      debugPrint('Response body: ${response.body}');
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
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
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
                          padding: const EdgeInsets.fromLTRB(15, 15, 10, 0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    poster != null
                                        ? showModalBottomSheet(
                                            context: context,
                                            builder: (context) => Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    ListTile(
                                                        leading: const Icon(Icons
                                                            .image_search_rounded),
                                                        title: const Text(
                                                            'View Image'),
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              showDragHandle:
                                                                  true,
                                                              context: context,
                                                              builder:
                                                                  ((context) =>
                                                                      FractionallySizedBox(
                                                                        heightFactor:
                                                                            0.8,
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Image.file(poster!),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )));
                                                        }),
                                                    ListTile(
                                                        leading: const Icon(Icons
                                                            .camera_alt_rounded),
                                                        title: const Text(
                                                            'Camera'),
                                                        onTap: () {
                                                          pickImage(ImageSource
                                                              .camera);
                                                        }),
                                                    ListTile(
                                                        leading: const Icon(
                                                            Icons.image),
                                                        title: const Text(
                                                            'Gallery'),
                                                        onTap: () {}),
                                                  ],
                                                ))
                                        : showModalBottomSheet(
                                            context: context,
                                            builder: (context) => Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    ListTile(
                                                        leading: const Icon(Icons
                                                            .camera_alt_outlined),
                                                        title: const Text(
                                                            'Camera'),
                                                        onTap: () {
                                                          pickImage(ImageSource
                                                              .camera);
                                                        }),
                                                    ListTile(
                                                        leading: const Icon(
                                                            Icons.image),
                                                        title: const Text(
                                                            'Gallery'),
                                                        onTap: () {
                                                          pickImage(ImageSource
                                                              .gallery);
                                                        }),
                                                  ],
                                                ));
                                  },
                                  child: Container(
                                    width: 200,
                                    height: 250,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        color: const Color.fromRGBO(
                                            133, 133, 142, 1)),
                                    child: poster != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: Image.file(
                                              poster!,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.image_rounded,
                                            size: 35,
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 10, 20, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 10.0),
                                        child: Text('Event Name'),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                233, 233, 242, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        height: 50,
                                        width: double.maxFinite,
                                        child: TextField(
                                          style: const TextStyle(
                                              color: Colors.black),
                                          controller: name,
                                          obscureText: false,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                              // hintText: 'Email',
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              30, 0, 5, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 10.0),
                                                child: Text('Event Date'),
                                              ),
                                              Container(
                                                decoration: const BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        233, 233, 242, 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                                height: 50,
                                                // width: 165,
                                                child: TextButton(
                                                    style: ButtonStyle(
                                                        shape: WidgetStatePropertyAll(
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10))),
                                                        minimumSize:
                                                            const WidgetStatePropertyAll(
                                                                Size.fromHeight(
                                                                    60))),
                                                    onPressed: () =>
                                                        showDatePicker(
                                                          context: context,
                                                          initialDate: date ??
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime(
                                                                  DateTime.now()
                                                                          .year -
                                                                      2,
                                                                  DateTime.now()
                                                                      .month,
                                                                  DateTime.now()
                                                                      .day),
                                                          lastDate: DateTime(
                                                              DateTime.now()
                                                                  .year,
                                                              DateTime.now()
                                                                      .month +
                                                                  1,
                                                              DateTime.now()
                                                                  .day),
                                                        ).then((value) =>
                                                            setState(() {
                                                              date = value;
                                                            })),
                                                    child: date != null
                                                        ? Text(
                                                            '${date!.day}/${date!.month}/${date!.year}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                          )
                                                        : const Text('')),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 10.0),
                                                child: Text('Event Time'),
                                              ),
                                              Container(
                                                  decoration: const BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          233, 233, 242, 1),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(15))),
                                                  height: 50,
                                                  // width: 165,
                                                  child: TextButton(
                                                      style: ButtonStyle(
                                                          shape: WidgetStatePropertyAll(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          10))),
                                                          minimumSize:
                                                              const WidgetStatePropertyAll(
                                                                  Size.fromHeight(60))),
                                                      onPressed: () => showTimePicker(
                                                            context: context,
                                                            initialTime: time ??
                                                                TimeOfDay.now(),
                                                          ).then((value) => setState(() {
                                                                time = value;
                                                              })),
                                                      child: time != null
                                                          ? Text(
                                                              '${time!.hourOfPeriod}:${time!.minute == 0 ? '00' : time!.minute} ${time!.hour < 12 ? 'AM' : 'PM'}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            )
                                                          : const Text(''))),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 0, 20, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 10.0),
                                        child: Text('Event Location'),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                233, 233, 242, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        height: 50,
                                        width: double.maxFinite,
                                        child: TextField(
                                          style: const TextStyle(
                                              color: Colors.black),
                                          controller: venue,
                                          obscureText: false,
                                          keyboardType:
                                              TextInputType.streetAddress,
                                          decoration: InputDecoration(
                                              // hintText: 'Location',
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 0, 20, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 10.0),
                                        child: Text('Event Price'),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                233, 233, 242, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        height: 50,
                                        width: double.maxFinite,
                                        child: TextField(
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          controller: price,
                                          // maxLength: 3,
                                          obscureText: false,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              // hintText: 'Price',
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 0, 20, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 10.0),
                                        child: Text('Event Description'),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                233, 233, 242, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        height: 50,
                                        width: double.maxFinite,
                                        child: TextField(
                                          style: const TextStyle(
                                              color: Colors.black),
                                          controller: description,
                                          obscureText: false,
                                          keyboardType: TextInputType.multiline,
                                          decoration: InputDecoration(
                                              // hintText: 'Description',
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 15, 20, 15),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: const Text(
                                                    'Do you want to Submit?'),
                                                content: const Text(
                                                    'You can\'t modify this later'),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      ElevatedButton(
                                                          onPressed: () async {
                                                            if (name.text
                                                                    .isEmpty ||
                                                                date == null ||
                                                                time == null ||
                                                                venue.text
                                                                    .isEmpty ||
                                                                price.text
                                                                    .isEmpty ||
                                                                description.text
                                                                    .isEmpty ||
                                                                poster ==
                                                                    null) {
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                          content:
                                                                              Text('Fill all fields')));
                                                              Navigator.pop(
                                                                  context);
                                                            } else {
                                                              uploadImage();
                                                              setState(() {
                                                                submitted =
                                                                    true;
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                              FocusManager
                                                                  .instance
                                                                  .primaryFocus
                                                                  ?.unfocus();
                                                            }
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
                                    style: const ButtonStyle(
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)))),
                                        minimumSize: WidgetStatePropertyAll(
                                            Size(double.maxFinite, 50)),
                                        backgroundColor: WidgetStatePropertyAll(
                                            Color.fromRGBO(17, 12, 49, 1))),
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                          color: Colors.grey.shade200),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))),
              ),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  const Color.fromRGBO(17, 12, 49, 1),
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor,
                ])),
                child: Container(
                    height: 100.5,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(17, 12, 49, 1),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(50))),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BackButton(
                                color: Colors.white,
                                onPressed: () {
                                  if ((name.text.isEmpty &&
                                          date == null &&
                                          time == null &&
                                          venue.text.isEmpty &&
                                          price.text == '50' &&
                                          description.text.isEmpty &&
                                          poster == null) ||
                                      submitted) {
                                    Navigator.pop(context);
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: const Padding(
                                                padding: EdgeInsets.all(12.0),
                                                child: Text(
                                                  'Discard the changes?',
                                                ),
                                              ),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('Yes')),
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
                                  }
                                },
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
                                                    padding:
                                                        const EdgeInsets.all(
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
                                                            onPressed:
                                                                () async {
                                                              final SharedPreferences
                                                                  preferences =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              await FirebaseAuth
                                                                  .instance
                                                                  .signOut();
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.of(
                                                                      context)
                                                                  .pushReplacementNamed(
                                                                      '/sign-in');
                                                              preferences
                                                                  .remove(
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
                                                            child: const Text(
                                                                'No')),
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
      ),
    );
  }
}
