import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final double coverHeight = 280;

  final double profileHeight = 144;

  File? _imagen;
  final picker = ImagePicker();

  String accessToken = '';
  String nombreUsuario = '';
  String foto = '';

  Future getImage() async {
    final pickerImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickerImage != null) {
        _imagen = File(pickerImage.path);
      } else {
        print('No se ha seleccionado ninguna imágen');
      }
    });
  }
 @override
  void initState() {
    super.initState();
    obtenerDatosLocalmente();
  }
    Future<void> obtenerDatosLocalmente() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken = prefs.getString('access_token') ?? '';
      nombreUsuario = prefs.getString('nombreUsuario') ?? '';
      foto = prefs.getString('foto') ?? '';
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        headerTop(),
        buildContent(),
      ],
    ));
  }

  Widget headerTop() {
    final top = coverHeight - profileHeight / 2;
    final bottom = profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(),
        ),
        Positioned(
          top: top,
          child: buildProfileImageWithCameraButton(),
        ),
      ],
    );
  }

  Widget buildProfileImageWithCameraButton() {
    return Stack(
      children: [
        buildProfileImage(),
        buildCameraButton(),
      ],
    );
  }

  Widget buildContent() => Column(
        children: [
          const SizedBox(height: 10),
           Text(
            nombreUsuario,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Hola vale",
            style: TextStyle(fontSize: 20, color: Colors.black54),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSocialMediaIcon(FontAwesomeIcons.github),
              const SizedBox(width: 12),
              buildSocialMediaIcon(FontAwesomeIcons.facebook),
              const SizedBox(width: 12),
              buildSocialMediaIcon(FontAwesomeIcons.twitter),
              const SizedBox(width: 12),
              buildSocialMediaIcon(FontAwesomeIcons.linkedin),
              const SizedBox(width: 12),
            ],
          ),
          Divider(),
        ],
      );

  Widget buildProfileImage() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 5.0, // Ancho del borde
        ),
      ),
      child: CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        // Usa la imagen seleccionada si existe, de lo contrario, usa una imagen predeterminada
        backgroundImage: _imagen != null
            ? FileImage(_imagen!)
            : AssetImage("assets/yo.jpg") as ImageProvider<Object>,
      ),
    );
  }

  Widget buildCameraButton() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0, // Para centrar horizontalmente
      child: Center(
        child: FloatingActionButton(
          elevation: 0, // Establecer la elevación a 0
          onPressed: () {
            getImage();
          },
          child: Icon(Icons.camera_alt, color: Colors.white),
          backgroundColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: Image.network(
          "https://images.unsplash.com/photo-1555066931-4365d14bab8c?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
      );

  Widget buildSocialMediaIcon(IconData icon) => CircleAvatar(
        radius: 25,
        backgroundColor: const Color.fromARGB(255, 206, 202, 202),
        child: Center(
          child: Icon(
            icon,
            size: 32,
            color: Colors.blue.shade400,
          ),
        ),
      );
}
