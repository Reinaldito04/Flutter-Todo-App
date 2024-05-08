import 'package:app/pages/Auth/Home/Home.dart';
import 'package:app/pages/Auth/login.dart';
import 'package:app/pages/Auth/registro.dart';
import 'package:app/services/notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotification();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
  await _limpiarNotificacionMostrada();
}

Future<void> _limpiarNotificacionMostrada() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('notificacionMostrada'); // Eliminar la variable local
}

bool _isDarkMode = false;

String theme = '';

void setTheme() {
  // Aquí puedes definir la lógica para establecer el tema según el valor de la variable `theme`
  if (theme == "claro") {
    _isDarkMode = false; // Si el tema es claro, desactiva el modo oscuro
  } else {
    _isDarkMode = true; // De lo contrario, activa el modo oscuro
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    setTheme();
    return MaterialApp(
      title: 'Test',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    verificarToken();
  }

  Future<void> verificarToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    if (accessToken != null) {
      // Si hay un token de acceso almacenado, redirige a la página de inicio
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(
                    30.0), // Radio de esquina inferior izquierda
                bottomRight:
                    Radius.circular(30.0), // Radio de esquina inferior derecha
              ),
              child: Container(
                height: 450, // Establece la altura deseada para la imagen
                child: Image.asset(
                  "assets/header.jpeg",
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Bienvenido a",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 28,
                    color: Color.fromARGB(255, 160, 143, 143)),
              ),
              const Text(
                "Todo APP",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 28,
                  color: Color.fromARGB(255, 160, 143, 143),
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20), // Relleno horizontal de 10 px
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(
                        double.infinity, 50), // Ancho menos 20 px en cada lado
                  ),
                  child: Text(
                    "Iniciar Sesión",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(height: 20),
              const Text(
                "¿No tienes cuenta?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navegar a la página de registro cuando se presione el texto
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistroPage()),
                  );
                },
                child: Text(
                  "Regístrate",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue, // Color del texto del botón
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
