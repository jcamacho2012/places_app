import 'package:flutter/material.dart';
import 'package:places_app/src/connection/connection.dart' show getJsonData;
import 'package:places_app/src/model/models.dart' show PlaceResponse, Place;

class PlacesServices extends ChangeNotifier {
  Future<Map<String, dynamic>> myFriendsPlaces() async {
    final jsonData = await getJsonData(endpoint: 'my_friends_places/1');

    bool estado = false;
    String messageApi = '';
    List<Place> places = [];

    final int statusCode = jsonData['statusCode'];
    final body = jsonData['body'];

    final parsePlacesResponse = PlaceResponse.fromJson(body);
    places = parsePlacesResponse.places;
    if (statusCode == 200) {
      estado = true;
    } else {
      messageApi = jsonData['message'];
    }

    notifyListeners();
    return <String, dynamic>{
      'state': estado,
      'places': places,
      'message': messageApi
    };
  }
}
