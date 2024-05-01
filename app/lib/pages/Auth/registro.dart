import 'package:flutter/material.dart';

class RegistroPage extends StatelessWidget {
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
                            onPressed: () {},
                            icon: Icon(
                              Icons.facebook,
                              color: Colors.blue, // Color del icono
                            ),
                            label: Text(
                              "Facebook",
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
                          ),

                          ElevatedButton.icon(
                            onPressed: () {},
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
