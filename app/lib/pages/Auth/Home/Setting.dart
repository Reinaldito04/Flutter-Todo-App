import 'package:app/main.dart';
import 'package:app/services/AuthGoogle.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPAge extends StatefulWidget {
  const SettingPAge({super.key});

  @override
  State<SettingPAge> createState() => _SettingPAgeState();
}

class _SettingPAgeState extends State<SettingPAge> {
  Future<void> eliminarToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => MyHomePage(
                title: "home",
              )),
    );
  }

  bool _isDarkMode = false;

  void _toggleDarkMode(bool value) async {
    setState(() {
      _isDarkMode = value;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_isDarkMode) {
      await prefs.setString('tema', 'oscuro');
      print(_isDarkMode);
    } else {
      await prefs.setString('tema', 'claro');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Preferencias',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Notificaciones'),
                trailing: Switch(
                  value:
                      true, // Cambia este valor según el estado de la preferencia
                  onChanged: (value) {
                    // Agrega aquí la lógica para cambiar el estado de la preferencia
                  },
                ),
              ),
              ListTile(
                title: Text('Tema'),
                trailing: Switch(
                  value: _isDarkMode,
                  onChanged: _toggleDarkMode,
                ),
              ),
              ListTile(
                title: Text('Idioma'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Agrega aquí la navegación para cambiar el idioma
                },
              ),
              Divider(),
              Text(
                'Otros',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Acerca de'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Agrega aquí la navegación para ver la pantalla "Acerca de"
                },
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Cerrar Sesión'),
                trailing: Icon(Icons.close),
                onTap: () async {
                  try {
                    await GoogleSignInService().signOutFromGoogle();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(
                                title: "Home",
                              )),
                    );
                  } catch (e) {
                    eliminarToken();
                  }
                  finally{
                    eliminarToken();
                  }

                  // Agrega aquí la navegación para ver la pantalla "Acerca de"
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
