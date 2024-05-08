import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AboutDevelopersScreen extends StatefulWidget {
  const AboutDevelopersScreen({Key? key}) : super(key: key);

  @override
  _AboutDevelopersScreenState createState() => _AboutDevelopersScreenState();
}

class _AboutDevelopersScreenState extends State<AboutDevelopersScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Developers'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(2.0),
          child: FutureBuilder(
            future: Future.wait([
              _getDevData('Taufeeq'),
              _getDevData('Habeeb'),
              _getDevData('Azim'),
              _getDevData('Abdullah'),
              _getDevData('Rehmat'),
              _getDevData('Iqra'),
              _getDevData('dev')
            ]),
            builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              var data1 = snapshot.data![0];
              var data2 = snapshot.data![1];
              var data3 = snapshot.data![2];
              var data4 = snapshot.data![3];
              var data5 = snapshot.data![4];
              var data6 = snapshot.data![5];
              var data7 = snapshot.data![6];

              return SingleChildScrollView( 
                child: Column(
                  children: [
                    _buildContactCard(data1),
                    _buildContactCard(data2),
                    _buildContactCard(data3),
                    _buildContactCard(data4),
                    _buildContactCard(data5),
                    _buildContactCard(data6),
                    _buildContactCard(data7),
                    const SizedBox(height: 10.0),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(Map<String, dynamic> data) {
    return Card(
      child: SizedBox(
        height: 160,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipOval(
              child: Image.network(
                data['Image'],
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data['Name'],
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(221, 255, 255, 255),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      data['Designation'],
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Color.fromARGB(255, 130, 130, 130),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _getDevData(String docId) async {
    var docSnapshot = await FirebaseFirestore.instance.collection("Developers").doc(docId).get();
    return docSnapshot.data() as Map<String, dynamic>;
  }
}
