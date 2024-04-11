import 'package:flutter/material.dart';
import 'package:places_app/src/theme/theme.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String nombre = "José Camacho";
    const String correo = "jcamacho@example.com";

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Mi Cuenta'),
      // ),
      body: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(nombre),
            accountEmail: const Text(correo),
            decoration: const BoxDecoration(
              color: AppTheme
                  .primary, // Define aquí el color de fondo que prefieras
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                nombre[0], // Primer letra del nombre
                style: const TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.email,
              size: 20,
            ),
            title: Text(
              correo,
              style: TextStyle(fontSize: 14),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock, size: 20),
            title: const Text('Cambiar contraseña',
                style: TextStyle(fontSize: 14)),
            onTap: () {
              // Navegar a la pantalla de cambio de contraseña
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, size: 20),
            title: const Text('Configuración', style: TextStyle(fontSize: 14)),
            onTap: () {
              // Navegar a la pantalla de configuración
            },
          ),
          // Añade más opciones según sea necesario
        ],
      ),
    );
  }
}
