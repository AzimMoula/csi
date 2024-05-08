// ignore_for_file: use_build_context_synchronously
// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csi/admin/admin_home.dart';
import 'package:csi/main.dart';
// import 'package:csi/user/screens/event_register.dart';
import 'package:csi/user/user_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Registrations extends StatefulWidget {
  const Registrations({
    super.key,
    required this.name,
  });

  final String? name;

  @override
  State<Registrations> createState() => _RegistrationsState();
}

class _RegistrationsState extends State<Registrations> {
  int index = 2;
  int sno = 0;
  String? theme;
  List<Student> tableValues = [];
  StudentDataSource? _studentDataSource;

  @override
  void initState() {
    super.initState();
    _initializeDataSource();
  }

  void _initializeDataSource() async {
    await loadRegistrations();
    setState(() {
      _studentDataSource = StudentDataSource(tableValues);
    });
  }

  Future<void> loadRegistrations() async {
    try {
      final values = await FirebaseFirestore.instance
          .collection('Event-Registrations')
          .doc(widget.name)
          .collection('Registered-Users')
          .get();
      setState(() {
        tableValues = values.docs.map((doc) {
          return Student('${++sno}', doc['Name'], '${doc['Roll']}');
        }).toList();
      });
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  // Future<void> loadRegistrations() async {
  //   final values = await FirebaseFirestore.instance
  //       .collection('Event-Registrations')
  //       .doc(widget.name)
  //       .collection('Registered-Users')
  //       .get();
  //   setState(() {
  //     tableValues = values.docs.map((doc) {
  //       sno++;
  //       return TableRow(children: [
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Center(child: Text('$sno')),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Text('${doc['Name']}'),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Text('${doc['Roll']}'),
  //         ),
  //       ]);
  //     }).toList();
  //     final style = const TextStyle(fontWeight: FontWeight.bold);
  //     tableValues.insert(
  //         0,
  //         TableRow(children: [
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Center(
  //                 child: Text(
  //               'S.No',
  //               style: style,
  //             )),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Center(
  //                 child: Text(
  //               'Name',
  //               style: style,
  //             )),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Center(
  //                 child: Text(
  //               'Roll Number',
  //               style: style,
  //             )),
  //           ),
  //         ]));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // List<Widget> _widgetList = [
    //   adminWidgetList[0],
    //   adminWidgetList[1],
    //   Padding(
    //     padding: const EdgeInsets.all(10.0),
    //     child: _studentDataSource == null
    //         ? const Center(child: CircularProgressIndicator())
    //         : SfDataGrid(
    //             allowTriStateSorting: true,
    //             allowFiltering: true,
    //             headerGridLinesVisibility: GridLinesVisibility.both,
    //             gridLinesVisibility: GridLinesVisibility.both,
    //             allowSorting: true,
    //             showHorizontalScrollbar: false,
    //             source: _studentDataSource!,
    //             columnWidthMode: ColumnWidthMode.fill,
    //             columns: <GridColumn>[
    //               GridColumn(
    //                   minimumWidth: 65,
    //                   allowFiltering: false,
    //                   columnName: 'S.No',
    //                   label: Container(
    //                       padding: const EdgeInsets.all(4.0),
    //                       alignment: Alignment.center,
    //                       child: const Text(
    //                         'SNo',
    //                       ))),
    //               GridColumn(
    //                   minimumWidth: 185,
    //                   // columnWidthMode: ColumnWidthMode.fitByCellValue,
    //                   columnName: 'Name',
    //                   label: Container(
    //                       padding: const EdgeInsets.all(0.0),
    //                       alignment: Alignment.center,
    //                       child: const Text(
    //                         'Name',
    //                         overflow: TextOverflow.ellipsis,
    //                       ))),
    //               GridColumn(
    //                   maximumWidth: 185,
    //                   columnWidthMode: ColumnWidthMode.fitByCellValue,
    //                   columnName: 'Roll Number',
    //                   label: Container(
    //                       padding: const EdgeInsets.all(.0),
    //                       alignment: Alignment.center,
    //                       child: const Text(
    //                         'Roll Number',
    //                         overflow: TextOverflow.ellipsis,
    //                       ))),
    //             ],
    //           ),
    //   )
    //   // Table(
    //   //   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    //   //   columnWidths: const {
    //   //     0: MaxColumnWidth(FixedColumnWidth(55), FixedColumnWidth(50))
    //   //   },
    //   //   border: TableBorder.all(
    //   //       color: Theme.of(context).brightness == Brightness.dark
    //   //           ? Colors.white
    //   //           : Colors.black),
    //   //   children: tableValues,
    //   // ),
    //   ,
    //   adminWidgetList[3]
    // ];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.chevron_left)),
          actions: [
            IconButton(
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                if (preferences.getString('theme') == null) {
                  preferences.setString('theme', 'light');
                } else {
                  preferences.setString(
                      'theme',
                      preferences.getString('theme') == 'light'
                          ? 'dark'
                          : 'light');
                  setState(() {
                    theme = preferences.getString('theme');
                  });
                  MyApp.themeNotifier.value =
                      theme == 'light' ? ThemeMode.dark : ThemeMode.light;
                }
              },
              icon: Icon(theme == 'dark' ? Icons.dark_mode : Icons.light_mode),
            ),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: FittedBox(
                                  child: const Text('Do you want to Logout?')),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        // final SharedPreferences preferences =
                                        //     await SharedPreferences.getInstance();
                                        await FirebaseAuth.instance.signOut();
                                        Navigator.of(context)
                                            .pushReplacementNamed('/sign-in');
                                        // preferences.remove('email');
                                        // preferences.remove('password');
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
                  // final SharedPreferences preferences =
                  //     await SharedPreferences.getInstance();
                  // await FirebaseAuth.instance.signOut();
                  // Navigator.of(context).pushNamed('/sign-in');
                  // preferences.remove('email');
                  // preferences.remove('password');
                },
                icon: const Icon(Icons.logout)),
          ],
          title: const Text('Admin View'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _studentDataSource == null
              ? const Center(child: CircularProgressIndicator())
              : SfDataGrid(
                  allowTriStateSorting: true,
                  allowFiltering: true,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  gridLinesVisibility: GridLinesVisibility.both,
                  allowSorting: true,
                  showHorizontalScrollbar: false,
                  source: _studentDataSource!,
                  columnWidthMode: ColumnWidthMode.fill,
                  columns: <GridColumn>[
                    GridColumn(
                        minimumWidth: 65,
                        allowFiltering: false,
                        columnName: 'S.No',
                        label: Container(
                            padding: const EdgeInsets.all(4.0),
                            alignment: Alignment.center,
                            child: const Text(
                              'SNo',
                            ))),
                    GridColumn(
                        minimumWidth: 185,
                        // columnWidthMode: ColumnWidthMode.fitByCellValue,
                        columnName: 'Name',
                        label: Container(
                            padding: const EdgeInsets.all(0.0),
                            alignment: Alignment.center,
                            child: const Text(
                              'Name',
                              overflow: TextOverflow.ellipsis,
                            ))),
                    GridColumn(
                        maximumWidth: 185,
                        columnWidthMode: ColumnWidthMode.fitByCellValue,
                        columnName: 'Roll Number',
                        label: Container(
                            padding: const EdgeInsets.all(.0),
                            alignment: Alignment.center,
                            child: const Text(
                              'Roll Number',
                              overflow: TextOverflow.ellipsis,
                            ))),
                  ],
                ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            elevation: 10,
            backgroundColor: Colors.blue,
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
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code_2), label: 'Scan'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.table_chart), label: 'Registration'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.card_membership_rounded),
                  label: 'Membership'),
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
