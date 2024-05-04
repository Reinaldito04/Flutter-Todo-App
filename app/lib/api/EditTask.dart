import 'dart:convert';
import 'package:app/api/TaskGet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditTask {
  Future<void> Edit(Task task, int id) async {
    try {
      final String apiUrl =
          'http://192.168.100.233:8000/tasks/update/$id'; // URL del endpoint para actualizar una tarea

       SharedPreferences prefs = await SharedPreferences.getInstance();
      var idUser = prefs.get('ID');
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "user_id":idUser,
          'title': task.title,
          'description': task.description,
          'completed': task.completed,
          'fecha': task.fecha, // Convertir fecha a formato ISO8601
          
        }
        ),
        
      );
      print(response.body);
      if (response.statusCode == 200) {
        print('Tarea actualizada correctamente');
      } else {
        throw Exception('Failed to edit task');
      }
    } catch (e) {
      throw Exception('Failed to edit task: $e');
    }
  }
}
