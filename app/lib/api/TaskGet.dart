import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';



class TaskGet {

  Future<List<Task>> fetchTasks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.get('email');
      final String apiUrl = 'http://192.168.100.233:8000/tasks/get/${email}';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((taskJson) => Task.fromJson(taskJson)).toList();
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }
}

class Task {
  int id;
  String title;
  String description;
  bool completed;
  String? fecha;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    this.fecha,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'] == 1 ? true : false,
      fecha: json['date'] != null ? json['date'] : null,
    );
  }
}
