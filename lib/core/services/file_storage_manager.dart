import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileStorageManager {
  static final FileStorageManager _instance = FileStorageManager._();

  FileStorageManager._();
  factory FileStorageManager(){
    return _instance;
  }
 late final Directory _appDocumentsDirectory;
  late final File _tasksFile;
  init() async{
    _appDocumentsDirectory = await getApplicationDocumentsDirectory();
     _tasksFile = File('${_appDocumentsDirectory.path}/tasks.json');
     print(_tasksFile);
  }

  saveTasks(List<dynamic> List) async{
   final listJson = jsonEncode(List);
  await _tasksFile.writeAsString(listJson);
  }
  
 Future <List<dynamic>> loadTasks()async{
    if(!await _tasksFile.exists()) return [];
   final tasksJson = await _tasksFile.readAsString();
    return  jsonDecode(tasksJson) as List<dynamic>;
  }
}