import 'package:http/http.dart' as http;

class SharedTask {
  Future<void> compartirTarea(String email, int idTask) async {
    try {
      final String apiUrl = 'http://192.168.100.233:8000/tasks/share/$idTask/$email';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // Verificar el estado de la respuesta
      if (response.statusCode == 200) {
        // La tarea se compartió exitosamente
        print('Tarea compartida exitosamente');
      } else {
        // Hubo un error al compartir la tarea
        print('Error al compartir la tarea: ${response.statusCode}');
        // Puedes lanzar una excepción para manejarla en el código que llama a completarTarea
        throw Exception('Error al compartir la tarea: ${response.statusCode}');
      }
    } catch (e) {
      // Manejar errores
      print('Error: $e');
      // Puedes lanzar la excepción nuevamente para manejarla en el código que llama a completarTarea
      throw e;
    }
  }
}
