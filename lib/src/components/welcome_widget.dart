import 'package:flutter/material.dart';
import 'package:places_app/src/components/components.dart'
    show IconNotification;

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          'Bienvenido, José',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          children: <Widget>[
            const IconNotification(),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // TODO: Implementar la navegación a la pantalla de configuración
              },
            ),
          ],
        ),
      ],
    );
  }
}
