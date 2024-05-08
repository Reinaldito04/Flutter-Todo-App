import 'package:http/http.dart' as http;
import 'dart:convert';

class GetImage {
  Future<String?> getImageByEmail(String email) async {
    try {
      final String apiUrl = 'http://192.168.100.233:8000/getImage/$email'; // URL del endpoint para obtener la imagen
      final response = await http.get(Uri.parse(apiUrl));
      
      // Verifica si la solicitud fue exitosa (código de estado 200)
      if (response.statusCode == 200) {
        // Decodifica el cuerpo de la respuesta JSON
        Map<String, dynamic> data = json.decode(response.body);
        
        // Extrae la URL de la foto del mapa
        String? photoUrl = data['Photo'];
        
        // Devuelve la URL de la foto
        return photoUrl;
      } else {
        // Si la solicitud no fue exitosa, imprime el código de estado
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      // Si ocurrió un error durante la solicitud, imprímelo
      print('Error en la solicitud HTTP: $error');
      return null;
    }
  }
}
