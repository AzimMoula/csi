import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ContactHR extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const ContactHR({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:const Text('Contact HR'), // Removed 'const' from here
        ),
        body: Padding(
          padding:const EdgeInsets.all(2.0), // Removed 'const' from here
          child: Column(
            children: [
              GestureDetector(
                onLongPress: () {
                  
                  _copyToClipboard("+91 9550342356", context);
                },
                child: const Card(
                  child: SizedBox(
                    height: 200,
                    width: null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.phone,
                          size: 70,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Rasheed",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(height: 6.0),
                            Text(
                              "+91 9550342356",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(height: 6.0),
                            Text(
                              "Head of HR",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
              ),
              GestureDetector(
                onLongPress: () {
                  
                  _copyToClipboard("+91 9550342356", context);
                },
                child: const Card(
                  child: SizedBox(
                    height: 200,
                    width: null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.phone,
                          size: 70,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Rasheed",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(height: 6.0),
                            Text(
                              "+91 9550342356",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(height: 6.0),
                            Text(
                              "Head of HR",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
              ),
              const SizedBox(height: 10.0,),
              const Text("""We are committed to providing prompt assistance and will respond to your query as soon as possible""")
            ],
          ),
        ),
      ),
    );
  }

  void _copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
      ),
    );
  }
}
