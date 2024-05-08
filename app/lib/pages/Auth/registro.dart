import 'dart:convert';
import 'package:app/pages/Auth/Home/Home.dart';
import 'package:app/services/AuthGoogle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

final TextEditingController usuarioController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class RegistroPage extends StatefulWidget {
  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  bool isValidEmail(String email) {
    // Expresión regular para validar un correo electrónico
    final RegExp regex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return regex.hasMatch(email);
  }

  void Modal(BuildContext context, String texto, String alerta) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(alerta),
        content: Text(texto),
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
Future<void> sendRegistro() async {
  String usuario = usuarioController.text;
  String email = emailController.text;
  String password = passwordController.text;

  if (usuario.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
    if (isValidEmail(email)) {
      print('Correo electrónico válido');
      
      // Verificar la longitud del usuario y la contraseña
      if (usuario.length >= 8 && password.length >= 8) {
        // Aquí va el código para enviar los datos al servidor y que se registre el usuario
        var url = Uri.parse('http://192.168.100.233:8000/Registrar');
        var data ={
          "email":email,
          "name":usuario,
          "password":password,
        };
        var body = json.encode(data);
        try{
          var response = await http.post(
            url,
            headers: {
               'Content-Type': 'application/json',
            },
            body: body,
          );
          var responseData = jsonDecode(response.body); // Decodifica la respuesta JSON
          var message = responseData["Message"];
         
          if (message =="Usuario Creado Exitosamente") {
            Modal(context,"Se ha registrado correctamente","Exito");
            
          }
          else if(response.statusCode==409){
            Modal(context,"El correo electrónico ya está en uso","Error");
          }
          else{
            Modal(context, "Ha ocurrido un error inesperado", "Error");
          }
        }
        catch (e){
          print ("error");
        }
      } else {
       Modal(context, "Usuario y contraseña deben tener al menos 8 caracteres", "Error");
      }
    } else {
     Modal(context, "Correo no válido", "Error");
    }
  } else {
    Modal(context, "Todos los campos son obligatorios", "Error");
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Registro",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(
                            255, 152, 160, 172), // Cambia el color del texto
                      ),
                    ),
                    SizedBox(height: 20),
                    FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: usuarioController,
                          decoration: InputDecoration(
                            labelText: "Nombre",
                            border: OutlineInputBorder(
                              // Añade un borde alrededor del TextField
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          obscureText: true,
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: "Contraseña",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Función para manejar el evento del botón
                        sendRegistro();
                      },
                      child: Text(
                        "Registrarse",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                        textStyle: TextStyle(fontSize: 18),
                        backgroundColor:
                            Colors.blue, // Cambia el color de fondo del botón
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "O continuar con",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          
                          ElevatedButton.icon(
                            onPressed: () async {
  // Acción al presionar el botón
                            GoogleSignInService googleSignInService = GoogleSignInService();
                            User? user = await googleSignInService.signInWithGoogle();
                            if (user != null) {
                              Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomePage()));
                              // El usuario inició sesión correctamente, haz algo con el usuario
                              print('Usuario ${user.displayName} ha iniciado sesión con Google');
                            } else {
                              // Hubo un error o el usuario canceló el inicio de sesión
                              print('Error al iniciar sesión con Google');
                            }
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
                                color: Colors.blue,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                disabledBackgroundColor: Colors.transparent,
                                side: BorderSide(
                                  color: Colors.blue,
                                  width: 1,
                                )),
                          ), //
                        ])
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
