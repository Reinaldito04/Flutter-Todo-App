import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          String photoURL = user.photoURL ?? 'No photo URL';
          String uid = user.uid;
      

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
}
