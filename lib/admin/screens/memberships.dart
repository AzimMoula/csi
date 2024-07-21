// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:permission_handler/permission_handler.dart';

class Memberships extends StatefulWidget {
  const Memberships({
    super.key,
  });

  @override
  State<Memberships> createState() => _MembershipsState();
}

class _MembershipsState extends State<Memberships> {
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
    await loadMemberships();
    setState(() {
      _studentDataSource = StudentDataSource(tableValues);
    });
  }

  Future<void> loadMemberships() async {
    int sno = 0;
    try {
      final values =
          await FirebaseFirestore.instance.collection('CSI-Members').get();
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

  Future<void> downloadMemberships() async {
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
        'Downloading CSI-Members.csv',
        'Download in progress',
        notificationDetails,
      );
      List<List<String>> csvData = [];

      int sno = 0;
      final values =
          await FirebaseFirestore.instance.collection('CSI-Members').get();
      setState(() {
        csvData = values.docs.map((doc) {
          ++sno;
          return [
            doc['Email'].toString(),
            doc['Name'].toString(),
            '${doc['Roll']}'.toString(),
            doc['Phone'].toString(),
            doc['Branch'].toString(),
            doc['Year'].toString(),
          ];
        }).toList();
      });
      int total = sno;
      csvData.insert(
          0, ['Email', 'Name', 'Roll Number', 'Contact', 'Branch', 'Year']);
      // ++sno;
      csvData.insert(++sno, ['Total Members', total.toString()]);

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
    final filePath = '${directory.path}/CSI-Members.csv';

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
          'Downloading CSI-Members.csv',
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
      'Downloading CSI-Members.csv',
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: _studentDataSource == null
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : RefreshIndicator(
                                    onRefresh: () => _initializeDataSource(),
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
                                      columnWidthMode: ColumnWidthMode.fill,
                                      columns: <GridColumn>[
                                        GridColumn(
                                            minimumWidth: 65,
                                            allowFiltering: false,
                                            columnName: 'S No',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'SNo',
                                                ))),
                                        GridColumn(
                                            minimumWidth: 185,
                                            // columnWidthMode: ColumnWidthMode.fitByCellValue,
                                            columnName: 'Name',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Name',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))),
                                        GridColumn(
                                            maximumWidth: 185,
                                            columnWidthMode:
                                                ColumnWidthMode.fitByCellValue,
                                            columnName: 'Roll Number',
                                            label: Container(
                                                padding:
                                                    const EdgeInsets.all(.0),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Roll Number',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed:
                              tableValues.isEmpty ? null : downloadMemberships,
                          child: const Text('Download CSV'),
                        ),
                      ],
                    ),
                  ))),
        ),
      ),
    );
  }
}

class StudentDataSource extends DataGridSource {
  StudentDataSource(List<Student> students) {
    dataGridRows = students
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell(columnName: 'S No', value: dataGridRow.sno),
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
