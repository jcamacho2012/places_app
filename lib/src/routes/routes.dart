import 'package:flutter/material.dart';
import 'package:places_app/src/screens/screens.dart'
    show HomeScreen, NewPlaceScreen;

Map<String, WidgetBuilder> getRoutes() {
  return <String, WidgetBuilder>{
    'home': (BuildContext context) => const HomeScreen(),
    'new_place': (BuildContext context) => const NewPlaceScreen(),
  };
}
