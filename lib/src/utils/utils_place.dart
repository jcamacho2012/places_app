import 'dart:convert';
import 'package:places_app/src/model/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Place>> loadPlaces() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? placesString = prefs.getString('places');

  if (placesString == null) return [];

  final List<dynamic> jsonData = json.decode(placesString);

  return jsonData.map((item) => Place.fromMap(item)).toList();
}

Future<void> savePlaces(List<Place> places) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String encodedData =
      json.encode(places.map((place) => place.toJson()).toList());
  await prefs.setString('places', encodedData);
}

Future<void> deletePlace(int placeId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? placesString = prefs.getString('places');
  if (placesString != null) {
    final List<dynamic> placesList = json.decode(placesString);
    placesList.removeWhere((item) => item['id'] == placeId);
    prefs.setString('places', json.encode(placesList));
  }
}
