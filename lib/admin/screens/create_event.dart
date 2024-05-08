// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csi/widgets/text_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final db = FirebaseFirestore.instance;
  final TextEditingController name = TextEditingController();
  final TextEditingController venue = TextEditingController();
  DateTime? date;
  TimeOfDay? time;
  String? url;

  File? poster;
  UploadTask? uploadTask;
  Future pickImage(ImageSource source) async {
    if (name.text == '') {
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
          'url': url!
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

  Future<void> sendNotification(String topic) async {
    final fburl = Uri.parse('https://fcm.googleapis.com/fcm/send');
    const serverKey =
        'AAAAnhKgc0o:APA91bHWZwPKjL1QPOVjI9e5Y8ugrSFk_V7_4_9mWrCTFZ9Fvryifu2oUCTzMWluZxO8SWV0EpyoSrHH555J2Tn7z7PO2HNZGgf3FbHF2bEtU37T_dIuFDqvDTaSu21AbFvpDJhU2Qw-';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };
    final body = {
      'notification': {
        'title': 'New Event Added!',
        'body': 'Checkout ${name.text} on the CSI app.',
        'image': url!,
      },
      'priority': 'high',
      'to': '/topics/$topic', // Specify the topic here
    };
    final response = await http.post(
      fburl,
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      print('Notification sent successfully to topic: $topic');
    } else {
      print(
          'Failed to send notification to topic: $topic. Error: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Event page'),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.chevron_left)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              poster != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                          leading: const Icon(
                                              Icons.image_search_rounded),
                                          title: const Text('View Image'),
                                          onTap: () {
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
                                                            Image.file(poster!),
                                                          ],
                                                        ),
                                                      ),
                                                    )));
                                          }),
                                      ListTile(
                                          leading: const Icon(
                                              Icons.camera_alt_rounded),
                                          title: const Text('Camera'),
                                          onTap: () {
                                            pickImage(ImageSource.camera);
                                          }),
                                      ListTile(
                                          leading: const Icon(Icons.image),
                                          title: const Text('Gallery'),
                                          onTap: () {
                                            pickImage(ImageSource.gallery);
                                          }),
                                    ],
                                  ));
                        },
                        icon: Column(
                          children: [
                            Image.file(
                              poster!,
                              width: 200,
                              height: 250,
                              fit: BoxFit.fitHeight,
                            ),
                          ],
                        ),
                      ),
                    )
                  : IconButton(
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                        leading: const Icon(
                                            Icons.camera_alt_outlined),
                                        title: const Text('Camera'),
                                        onTap: () {
                                          pickImage(ImageSource.camera);
                                        }),
                                    ListTile(
                                        leading: const Icon(Icons.image),
                                        title: const Text('Gallery'),
                                        onTap: () {
                                          pickImage(ImageSource.gallery);
                                        }),
                                  ],
                                ));
                      },
                      icon: const Icon(Icons.image, size: 200),
                    ),
              CustomTextInput(
                  controller: name, icon: const Icon(Icons.abc), label: 'Name'),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      child: OutlinedButton(
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              minimumSize: const MaterialStatePropertyAll(
                                  Size.fromHeight(60))),
                          onPressed: () => showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(DateTime.now().year - 2,
                                    DateTime.now().month, DateTime.now().day),
                                lastDate: DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month + 1,
                                    DateTime.now().day),
                              ).then((value) => setState(() {
                                    date = value;
                                  })),
                          child: date != null
                              ? Text(
                                  '${date!.day}/${date!.month}/${date!.year}')
                              : const Text('Date')),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: OutlinedButton(
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              minimumSize: const MaterialStatePropertyAll(
                                  Size.fromHeight(60))),
                          onPressed: () => showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) => setState(() {
                                    time = value;
                                  })),
                          child: time != null
                              ? Text(
                                  '${time!.hourOfPeriod}:${time!.minute == 0 ? '00' : time!.minute} ${time!.hour < 12 ? 'AM' : 'PM'}')
                              : const Text('Time')),
                    ),
                  ],
                ),
              ),
              CustomTextInput(
                  controller: venue,
                  icon: const Icon(Icons.location_pin),
                  label: 'Location'),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Do you want to Submit?'),
                                content:
                                    const Text('You can\'t modify this later'),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () async {
                                            if (name.text == '' ||
                                                date == null ||
                                                time == null ||
                                                venue.text == '' ||
                                                poster == null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Fill all fields')));
                                              Navigator.pop(context);
                                            } else {
                                              uploadImage();
                                              Navigator.pop(context);
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            }
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
                    },
                    style: const ButtonStyle(
                        minimumSize: MaterialStatePropertyAll(Size(180, 60)),
                        backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.grey.shade200),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 90,
              ),
              Align(alignment: Alignment.bottomCenter, child: buildProgress()),
            ],
          ),
        ),
      ),
    );
  }
}
