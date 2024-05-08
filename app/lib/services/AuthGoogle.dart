import 'package:app/api/GetImageGoogle.dart';
import 'package:app/api/VerifyRegister.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
class GoogleSignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      // Inicia sesión con Google
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        // Crea las credenciales de acceso con Google
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // Inicia sesión con Firebase
        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        // Guarda los datos del usuario en el almacenamiento local
        if (user != null) {
          String email = user.email ?? 'No email';
          String displayName = user.displayName ?? 'No display name';
          String? photoURL = await GetImage().getImageByEmail(email);

        // Si la URL de la foto del usuario no está disponible desde la API, usa la proporcionada por Google
        if (photoURL == null || photoURL.isEmpty) {
          photoURL = user.photoURL ?? 'No photo URL';
        }
          String uid = user.uid;
        bool isRegistered = await VerifyRegister().isUserRegistered(email);
        if (!isRegistered) {
          // Si el usuario no está registrado, enviar el registro al servidor
          await sendRegistro(email, displayName);
        }
          
          await _saveUserDataLocally(email, displayName, photoURL, uid,
          googleSignInAuthentication.accessToken.toString()
          );
        }

        return user; // Devolver el usuario
      } else {
        // El usuario canceló el inicio de sesión
        return null;
      }
    } catch (error) {
      print('Error al iniciar sesión con Google: $error');
      return null;
    }
  }


 

Future<void>  sendRegistro(email, usuario) async {
  try {
    // Generar un hash único para la contraseña del usuario
    String uniquePassword = sha256.convert(utf8.encode(email)).toString();

    // Aquí va el código para enviar los datos al servidor y que se registre el usuario
    var url = Uri.parse('http://192.168.100.233:8000/Registrar');
    var data = {
      "email": email,
      "name": usuario,
      "password": uniquePassword, // Usar el hash único en lugar de la contraseña original
    };
    var body = json.encode(data);
    try {
        await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Aquí puedes manejar la respuesta del servidor si es necesario
    } catch (e) {
      print("Error: $e");
    }
  } catch (error) {
    print("Error al generar el hash de la contraseña: $error");
  }
}

  Future<void> _saveUserDataLocally(
      String email, String displayName, String? photoUrl, String uid,String accessToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('nombreUsuario', displayName);
    await prefs.setString('foto',
        photoUrl ?? ''); // Si photoUrl es null, asigna una cadena vacía
    await prefs.setString('ID', uid);
    await prefs.setString('access_token', accessToken);

  }

 Future<void> signOutFromGoogle() async {
    try {
      await googleSignIn.signOut(); // Cerrar sesión con Google
      // Opcional: también puedes cerrar sesión en Firebase si lo deseas
      // await _auth.signOut();
      // Limpia los datos del usuario del almacenamiento local
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
      await prefs.remove('nombreUsuario');
      await prefs.remove('foto');
      await prefs.remove('ID');
      await prefs.remove('access_token');
    } catch (error) {
      print('Error al cerrar sesión con Google: $error');
    }
  }

}
