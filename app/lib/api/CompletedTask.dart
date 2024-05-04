import 'package:http/http.dart' as http;
import 'dart:convert';
class CompletedTask {

  Future<void> completarTarea(id) async {
    try {
      final String apiUrl = 'http://192.168.100.233:8000/tasks/completed/${id}'; // URL del endpoint para marcar la tarea como completada
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'completed': true, // Marca la tarea como completada
        }),
      );

      if (response.statusCode == 200) {
        print('Tarea completada exitosamente');
      } else {
        throw Exception('Failed to complete task');
      }
    } catch (e) {
      throw Exception('Failed to complete task: $e');
    }
  }
}
