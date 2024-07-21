// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csi/services/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:permission_handler/permission_handler.dart';

class Attendance extends StatefulWidget {
  const Attendance({
    super.key,
    required this.name,
  });

  final String? name;

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  int index = 2;
  String? theme;
  List<Student> tableValues = [];
  StudentDataSource? _studentDataSource;

  @override
  void initState() {
    super.initState();
    _initializeDataSource();
  }

  Future<void> _initializeDataSource() async {
    await loadAttendance();
    setState(() {
      _studentDataSource = StudentDataSource(tableValues);
    });
  }

  Future<void> loadAttendance() async {
    int sno = 0;
    try {
      final values = await FirebaseFirestore.instance
          .collection('Event-Registrations')
          .doc(widget.name)
          .collection('Attended-Users')
          .get();
      setState(() {
        tableValues = values.docs.map((doc) {
          return Student('${++sno}', doc['Name'], '${doc['Roll']}');
        }).toList();
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error fetching data: $error")));
    }
  }

  Future<void> downloadAttendance() async {
    try {
      if (await Permission.storage.request().isPermanentlyDenied) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage permission not granted')));
        return;
      } else {
        final PermissionStatus status = await Permission.storage.request();
      }
      final PermissionStatus status =
          await Permission.manageExternalStorage.request();
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('download_channel', 'Downloads',
              channelDescription:
                  'This channel is used for download notifications',
              importance: Importance.max,
              priority: Priority.high,
              showProgress: true,
              maxProgress: 100,
              onlyAlertOnce: true,
              playSound: false);
      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);

      await FlutterLocalNotificationsPlugin().show(
        0,
        'Downloading ${widget.name}.csv',
        'Download in progress',
        notificationDetails,
      );
      List<List<String>> csvData = [];

      int sno = 0;
      final values = await FirebaseFirestore.instance
          .collection('Event-Registrations')
          .doc(widget.name)
          .collection('Attended-Users')
          .get();
      setState(() {
        csvData = values.docs.map((doc) {
          return [
            '${++sno}'.toString(),
            doc['Name'].toString(),
            '${doc['Roll']}'.toString(),
            doc['Branch'].toString(),
            doc['Year'].toString(),
            doc['Status'].toString(),
          ];
        }).toList();
      });
      csvData.insert(
          0, ['S No', 'Name', 'Roll Number', 'Branch', 'Year', 'Status']);

      final csvFile = await _createCsvFile(csvData);

      // await OpenFile.open(csvFile.path);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error downloading CSV file: $error')));
    }
  }

  Future<File> _createCsvFile(List<List<String>> csvData) async {
    final directory = Directory('/storage/emulated/0/Download');
    final filePath = '${directory.path}/${widget.name}_Attendance.csv';

    final file = File(filePath);
    String csvString = const ListToCsvConverter().convert(csvData);
    final total = csvString.length;

    int progress = 0;
    int chunkSize = (total ~/ 100).clamp(1, total);

    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < csvString.length; i++) {
      buffer.write(csvString[i]);
      if ((i + 1) % chunkSize == 0) {
        progress++;
        await file.writeAsString(buffer.toString(), mode: FileMode.append);
        buffer.clear();
        await FlutterLocalNotificationsPlugin().show(
          0,
          'Downloading ${widget.name}.csv',
          'Download in progress',
          NotificationDetails(
              android: AndroidNotificationDetails(
                  'download_channel', 'Downloads',
                  channelDescription:
                      'This channel is used for download notifications',
                  importance: Importance.max,
                  priority: Priority.high,
                  showProgress: true,
                  maxProgress: 100,
                  progress: progress,
                  playSound: false,
                  onlyAlertOnce: true)),
        );
      }
    }

    if (buffer.isNotEmpty) {
      await file.writeAsString(buffer.toString(), mode: FileMode.append);
    }

    await FlutterLocalNotificationsPlugin().cancel(0);
    await FlutterLocalNotificationsPlugin().show(
      0,
      'Downloading ${widget.name}.csv',
      'Download Complete.',
      const NotificationDetails(
          android: AndroidNotificationDetails('download_channel', 'Downloads',
              channelDescription:
                  'This channel is used for download notifications',
              importance: Importance.max,
              priority: Priority.high,
              showProgress: false,
              playSound: false,
              onlyAlertOnce: true)),
      payload: 'download',
    );

    return file;
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
                          padding: const EdgeInsets.fromLTRB(15, 15, 10, 20),
                          child: Column(
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: _studentDataSource == null
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : RefreshIndicator(
                                          onRefresh: () =>
                                              _initializeDataSource(),
                                          child: SfDataGrid(
                                            allowTriStateSorting: true,
                                            allowFiltering: true,
                                            headerGridLinesVisibility:
                                                GridLinesVisibility.both,
                                            gridLinesVisibility:
                                                GridLinesVisibility.both,
                                            allowSorting: true,
                                            showHorizontalScrollbar: false,
                                            source: _studentDataSource!,
                                            columnWidthMode:
                                                ColumnWidthMode.fill,
                                            columns: <GridColumn>[
                                              GridColumn(
                                                  minimumWidth: 65,
                                                  allowFiltering: false,
                                                  columnName: 'S.No',
                                                  label: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Text(
                                                        'SNo',
                                                      ))),
                                              GridColumn(
                                                  minimumWidth: 185,
                                                  // columnWidthMode: ColumnWidthMode.fitByCellValue,
                                                  columnName: 'Name',
                                                  label: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Text(
                                                        'Name',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ))),
                                              GridColumn(
                                                  maximumWidth: 185,
                                                  columnWidthMode:
                                                      ColumnWidthMode
                                                          .fitByCellValue,
                                                  columnName: 'Roll Number',
                                                  label: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              .0),
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Text(
                                                        'Roll Number',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ))),
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: tableValues.isEmpty
                                    ? null
                                    : downloadAttendance,
                                child: const Text('Download CSV'),
                              ),
                            ],
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
        bottomNavigationBar: BottomNavigationBar(
            elevation: 10,
            // backgroundColor: Colors.blue,
            currentIndex: index,
            // showSelectedLabels: false,
            showUnselectedLabels: true,
            selectedLabelStyle: GoogleFonts.poppins(),
            unselectedLabelStyle: GoogleFonts.plusJakartaSans(),
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
                  icon: Icon(Icons.table_chart), label: 'Events'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.card_membership_rounded),
                  label: 'Membership'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.event_repeat), label: 'Customize Event'),
            ]),
      ),
    );
  }
}

class StudentDataSource extends DataGridSource {
  StudentDataSource(List<Student> students) {
    dataGridRows = students
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell(columnName: 'S.No', value: dataGridRow.sno),
              DataGridCell(columnName: 'Name', value: dataGridRow.name),
              DataGridCell(columnName: 'Roll Number', value: dataGridRow.roll),
            ]))
        .toList();
  }
  late List<DataGridRow> dataGridRows;
  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Center(child: Text(dataGridCell.value.toString()));
    }).toList());
  }
}

class Student {
  Student(this.sno, this.name, this.roll);
  final String sno;
  final String name;
  final String roll;
}
