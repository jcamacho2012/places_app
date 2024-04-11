import 'package:flutter/material.dart';
import 'package:places_app/src/model/models.dart' show Place;
import 'package:places_app/src/screens/screens.dart'
    show HomeScreen, NewPlaceScreen, PlaceDetailsScreen;

Map<String, WidgetBuilder> getRoutes() {
  return <String, WidgetBuilder>{
    'home': (BuildContext context) => const HomeScreen(),
    'new_place': (BuildContext context) => const NewPlaceScreen(),
    'place_details': (BuildContext context) => PlaceDetailsScreen(
          place: ModalRoute.of(context)!.settings.arguments as Place,
        ),
  };
}
