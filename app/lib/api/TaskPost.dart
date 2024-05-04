import 'dart:convert';
import 'package:app/api/TaskGet.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TaskPost {
  Future<void> addTask(Task task) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.get('email');
      final String apiUrl = 'http://192.168.100.233:8000/tasks/${email}'; // URL del endpoint de POST para agregar una tarea
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': task.title,
          'description': task.description,
          'completed': task.completed,
          'fecha': task.fecha, // Asegúrate de convertir la fecha a formato ISO8601
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        print('Tarea agregada exitosamente');
      } else {
        throw Exception('Failed to add task');
      }
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }
}
