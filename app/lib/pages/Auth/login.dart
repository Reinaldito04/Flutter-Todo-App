import 'package:app/pages/Auth/Home/Home.dart';
import 'package:app/pages/Auth/registro.dart';
import 'package:flutter/material.dart';

final TextEditingController usuarioController = TextEditingController();
final TextEditingController contrasenaController = TextEditingController();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showPassword =
      false; // Variable para controlar la visibilidad de la contraseña

  void login() {
    String usuario = usuarioController.text;
    String password = contrasenaController.text;

    if (usuario == "reinaldo" && password == "12345") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Los datos son incorrectos"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el AlertDialog
                },
                child: Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios)),
              ],
            ),
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Inicio de Sesión",
                      style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 152, 160, 172),
                      ),
                    ),
                    SizedBox(height: 20),
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          controller: usuarioController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            labelText: 'Usuario',
                            labelStyle: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 152, 160, 172),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ), // Aplica bordes a todos los lados
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextFormField(
                            controller: contrasenaController,
                            obscureText:
                                !_showPassword, // Muestra u oculta la contraseña según el estado de _showPassword
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelText: 'Contraseña',
                              labelStyle: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 152, 160, 172),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(_showPassword
                                    ? Icons.visibility
                                    : Icons
                                        .visibility_off), // Cambia el ícono según el estado de _showPassword
                                onPressed: () {
                                  setState(() {
                                    _showPassword =
                                        !_showPassword; // Cambia el estado de _showPassword al presionar el botón
                                  });
                                },
                              ),
                            ),
                          )),
                    ),
                    SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              login();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
                                minimumSize: Size(double.infinity, 50)),
                            child: Text(
                              "Iniciar Sesión",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Continuar con",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                            ]),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // Acción al presionar el botón
                              },
                              icon: Icon(
                                Icons.facebook,
                                color: Colors.blue, // Color del icono
                              ),
                              label: Text(
                                "Facebook",
                                style: TextStyle(
                                  color: Colors.blue, // Color del texto
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  disabledBackgroundColor: Colors
                                      .transparent, // Color de fondo del botón
                                  side: BorderSide(
                                    color: Colors.blue,
                                    width: 1,
                                  )),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Acción al presionar el botón
                              },
                                icon: Image.asset(
                              'assets/google.png', // Ruta de la imagen del icono de Google
                              width: 24, // Ancho del icono
                              height: 24, // Alto del icono
                              color: Colors.blue, // Color del icono
                            ),
                              label: Text(
                                "Google",
                                style: TextStyle(
                                  color: Colors.blue, // Color del texto
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  disabledBackgroundColor: Colors
                                      .transparent, // Color de fondo del botón
                                  side: BorderSide(
                                    color: Colors.blue,
                                    width: 1,
                                  )),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        const Text(
                          "¿No tienes cuenta?",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegistroPage()),
                              );
                            },
                            child: Text("Registrate",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                )))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
