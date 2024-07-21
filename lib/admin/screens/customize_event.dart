import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:color_picker_field/color_picker_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomizeEvent extends StatefulWidget {
  const CustomizeEvent({super.key});

  @override
  State<CustomizeEvent> createState() => _CustomizeEventState();
}

class _CustomizeEventState extends State<CustomizeEvent> {
  String? headline;
  String? content;
  ColorPickerFieldController? fontColor = ColorPickerFieldController();
  String? url;
  File? background;
  UploadTask? uploadTask;
  Future pickImage(ImageSource source, String name) async {
    try {
      final image =
          await ImagePicker().pickImage(source: source, imageQuality: 100);
      if (image == null) return;
      final extension = image.path.split('.').last;
      final newFile = File('${Directory.systemTemp.path}/$name.$extension');
      await image.saveTo(newFile.path);
      setState(() {
        background = newFile;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future uploadImage(String name) async {
    try {
      if (background != null) {
        final path = 'posters/$name.${background!.path.split('.').last}';
        final fbs = FirebaseStorage.instance.ref().child(path);

        setState(() {
          uploadTask = fbs.putFile(background!);
        });
        final snapshot = await uploadTask!.whenComplete(() {});
        var temp = await snapshot.ref.getDownloadURL().whenComplete(() {});
        setState(() {
          url = temp;
          FirebaseFirestore.instance
              .collection('Info-Cards')
              .doc(name)
              .update({'url': url});
        });
      }
      setState(() {
        if (headline != null) {
          FirebaseFirestore.instance
              .collection('Info-Cards')
              .doc(name)
              .update({'Headline': headline});
        }
        if (content != null) {
          FirebaseFirestore.instance
              .collection('Info-Cards')
              .doc(name)
              .update({'Content': content});
        }
        if (fontColor != null) {
          FirebaseFirestore.instance.collection('Info-Cards').doc(name).update({
            'Color': fontColor!.colors.first.value
            // '${fontColor!.colors.first.alpha},${fontColor!.colors.first.red},${fontColor!.colors.first.green},${fontColor!.colors.first.blue}'
          });
          setState(() {
            fontColor = ColorPickerFieldController();
          });
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Update Complete')));
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height,
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
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Info-Cards')
                          .snapshots(),
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: ((context, index) {
                              final DocumentSnapshot docSnap =
                                  snapshot.data!.docs[index];
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () => showDialog(
                                      // barrierDismissible: false,
                                      context: context,
                                      builder: (context) => Dialog(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black26),
                                                              color: const Color
                                                                  .fromRGBO(
                                                                  235,
                                                                  235,
                                                                  235,
                                                                  0.75),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          15))),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10.0),
                                                            child:
                                                                TextFormField(
                                                              initialValue:
                                                                  docSnap[
                                                                      'Headline'],
                                                              decoration: const InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  headline =
                                                                      value;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                          onPressed: () {
                                                            pickImage(
                                                                ImageSource
                                                                    .gallery,
                                                                docSnap.id);
                                                          },
                                                          icon: const Icon(Icons
                                                              .image_outlined)),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 12.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black26),
                                                          color: const Color
                                                              .fromRGBO(235,
                                                              235, 235, 0.75),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          15))),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10.0),
                                                        child: TextFormField(
                                                          initialValue: docSnap[
                                                              'Content'],
                                                          decoration:
                                                              const InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              content = value;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 12.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black26),
                                                          color: const Color
                                                              .fromRGBO(235,
                                                              235, 235, 0.75),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          15))),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10.0),
                                                        child: ColorPickerField(
                                                          colors: const [],
                                                          enableLightness: true,
                                                          enableSaturation:
                                                              true,
                                                          maxColors: 1,
                                                          buildCounter: (context,
                                                              {required currentLength,
                                                              required isFocused,
                                                              required maxLength}) {
                                                            return Container();
                                                          },
                                                          defaultColor:
                                                              Colors.orange,
                                                          onChanged:
                                                              (List<Color>
                                                                  value) {
                                                            // setState(() {
                                                            //   fontColor = value.first;
                                                            // });
                                                          },
                                                          controller: fontColor,
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText: 'Color',
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      uploadImage(docSnap.id);
                                                      Navigator.pop(context);
                                                    },
                                                    style: const ButtonStyle(
                                                        shape: WidgetStatePropertyAll(
                                                            RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)))),
                                                        minimumSize:
                                                            WidgetStatePropertyAll(
                                                                Size(
                                                                    double
                                                                        .maxFinite,
                                                                    50)),
                                                        backgroundColor:
                                                            WidgetStatePropertyAll(
                                                                Color.fromRGBO(
                                                                    17,
                                                                    12,
                                                                    49,
                                                                    1))),
                                                    child: Text(
                                                      'Submit',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade200),
                                                    ),
                                                  ),
                                                  buildProgress(),
                                                ],
                                              ),
                                            ),
                                          )),
                                  child: Card(
                                    child: Container(
                                      height: 150,
                                      width: 310,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.fitWidth,
                                              image: CachedNetworkImageProvider(
                                                  docSnap['url'])),
                                          borderRadius:
                                              BorderRadius.circular(13)),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            25, 5, 20, 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(docSnap['Headline'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color(
                                                            docSnap['Color']))
                                                // TextStyle(
                                                //   fontSize: 20,
                                                //   fontWeight: FontWeight.bold,
                                                //   color: Color(docSnap['Color']),
                                                // ),
                                                ),
                                            Text(
                                              docSnap['Content'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      color: Color(
                                                          docSnap['Color'])),
                                              // TextStyle(
                                              //   fontSize: 16,
                                              //   fontWeight: FontWeight.w600,
                                              //   color: Color(docSnap['Color']),
                                              // ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                    ),
                  ))),
        ),
      ),
    );
  }
}
