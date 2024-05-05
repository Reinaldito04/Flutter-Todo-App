import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

Future<String?> uploadImage(File imageFile, String email) async {
  try {
    // Crear una solicitud de tipo multipart/form-data
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.100.233:8000/upload-imgbb/$email'),
    );

    // Adjuntar el archivo a la solicitud
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ),
    );

    // Enviar la solicitud y esperar la respuesta
    var response = await request.send();

    // Leer la respuesta del servidor
    var responseData = await response.stream.bytesToString();

    // Verificar el estado de la respuesta
    if (response.statusCode == 200) {
      // Éxito
      var decodedData = jsonDecode(responseData);
      var imageUrl = decodedData["image_url"];
      print('Imagen subida exitosamente');
      print('URL de la imagen: $imageUrl');
      return imageUrl; // Devolver la URL de la imagen
    } else {
      // Error
      print('Error al subir la imagen: ${response.reasonPhrase}');
      return null;
    }
  } catch (e) {
    // Error
    print('Error al subir la imagen: $e');
    return null;
  }
}
