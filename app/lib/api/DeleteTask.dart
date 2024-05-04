import 'package:http/http.dart' as http;

class DeleteTask {
  Future<void> delete(int id) async {
    try {
      final String apiUrl = 'http://192.168.100.233:8000/tasks/delete/$id';
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        print('Tarea eliminada exitosamente');
      } else {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }
}
