import 'package:flutter/material.dart';

// Esta es la pantalla a la que navegaremos cuando toques el ícono de la casa.
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: Center(
          child: Text(
            'App Móvil',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.house_siding_rounded, size: 80, color: Color(0xFFEF7532)),
            SizedBox(height: 20),
            Text(
              '¡Estás en la pantalla de inicio (Home)!',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Esta pantalla se abrió usando Navigator.push.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
      // Nota: El BottomAppBar debe estar fuera de esta pantalla si la estás usando como
      // Shell o si la NavigationBar se define en el Scaffold principal de la aplicación.
    );
  }
}