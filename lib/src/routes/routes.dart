import 'package:flutter/material.dart';
import 'package:places_app/src/screens/screens.dart' show HomeScreen;

Map<String, WidgetBuilder> getRoutes() {
  return <String, WidgetBuilder>{
    'home': (BuildContext context) => const HomeScreen(),
  };
}
