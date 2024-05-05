import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TaskGet {
  Future<List<Task>> fetchTasks() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.get('email');
    final String userTasksUrl =
        'http://192.168.100.233:8000/tasks/get/$email';
    final String sharedTasksUrl =
        'http://192.168.100.233:8000/tasks/shared/$email';

    // Realizar dos solicitudes GET simultáneas
    final userTasksFuture = http.get(Uri.parse(userTasksUrl));
    final sharedTasksFuture = http.get(Uri.parse(sharedTasksUrl));

    // Esperar a que ambas solicitudes se completen
    final responses = await Future.wait([userTasksFuture, sharedTasksFuture]);

    // Lista para almacenar todas las tareas
    final List<Task> allTasks = [];

    // Procesar cada respuesta
    for (var response in responses) {
      // Verificar si la respuesta es válida
      if (response.statusCode == 200) {
        // Convertir el cuerpo de la respuesta a datos JSON
        final responseData = json.decode(response.body);

        // Verificar si la respuesta contiene datos relevantes
        if (responseData is List) {
          // Mapear los datos a objetos Task y agregarlos a la lista de tareas
          final tasks = responseData.map((taskJson) => Task.fromJson(taskJson)).toList();
          allTasks.addAll(tasks);
        }
      }
    }

    return allTasks;
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
  String? madeBy;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    this.fecha,
    this.madeBy
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'] == 1 ? true : false,
      fecha: json['date'] != null ? json['date'] : null,
      madeBy: json['madeBy'] != null ? json['madeBy'] : "",
    );
  }
}
