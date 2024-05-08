
import 'package:http/http.dart' as http;
import 'dart:convert';
class VerifyRegister{

Future<bool> isUserRegistered(String email) async {
  final Uri url = Uri.parse('http://192.168.100.233:8000/registers/$email');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData.containsKey('Registrado')) {
        return true; // El usuario está registrado
      } else if (responseData.containsKey('No registrado')) {
        return false; // El usuario no está registrado
      }
    } else {
      print('Error al verificar el registro del usuario: ${response.statusCode}');
      // Manejar el error aquí si es necesario
      throw Exception('Error al verificar el registro del usuario');
    }
  } catch (error) {
    print('Error al realizar la solicitud HTTP: $error');
    // Manejar el error aquí si es necesario
    throw Exception('Error al realizar la solicitud HTTP');
  }

  // Si no se puede determinar el estado del usuario, lanzar una excepción
  throw Exception('No se pudo determinar el estado del usuario');
}

}