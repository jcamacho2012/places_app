import 'package:flutter/material.dart';
import 'package:places_app/src/components/components.dart'
    show IconNotification;

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Bienvenido, José',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          children: <Widget>[
            IconNotification(),
            IconButton(icon: Icon(Icons.settings), onPressed: null),
          ],
        ),
      ],
    );
  }
}
