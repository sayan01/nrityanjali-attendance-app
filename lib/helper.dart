import 'dart:io';

import 'package:csv/csv.dart';
import 'package:ftest/main.dart';
import 'package:path_provider/path_provider.dart';

String timeFormat(DateTime time) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

bool validQR(String data) {
  return  data.length == 8 && (data.startsWith('NR-C-') || data.startsWith('NR-I-'));
}

Future<String> saveCSV(List<Attendance> attendances, String event) async {
  try {
    List<List<String>> data = [];
    List<String> header = ['id', 'time'];
    data.add(header);
    for (int i = 0; i < attendances.length; i++) {
      data.add([attendances[i].id, attendances[i].time.toString()]);
    }
    String csvData = const ListToCsvConverter().convert(data);
    final String directory = (await getApplicationSupportDirectory()).path;
    final String path = "$directory/csv-$event-${DateTime.now()}.csv";
    final File file = File(path);
    await file.writeAsString(csvData);
    return path;
  } catch (e) {
    return await saveCSV(attendances, event);
  }
}
