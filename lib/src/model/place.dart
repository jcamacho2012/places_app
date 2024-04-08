import 'dart:convert';

class Place {
  int id;
  String name;
  String location;
  double latitude;
  double longitude;
  String description;
  String date;
  String pictureUrl;
  int comments;
  int favorites;

  Place({
    required this.id,
    required this.name,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.date,
    required this.comments,
    required this.pictureUrl,
    required this.favorites,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'description': description,
        'date': date,
        'pictureUrl': pictureUrl,
        'comments': comments,
        'favorites': favorites,
      };

  factory Place.fromJson(String str) => Place.fromMap(json.decode(str));

  factory Place.fromMap(Map<String, dynamic> resp) {
    return Place(
      id: resp['id'],
      name: resp['name'],
      location: resp['location'],
      latitude: resp['latitude'],
      longitude: resp['longitude'],
      description: resp['description'],
      date: resp['date'],
      comments: resp['comments'],
      pictureUrl: resp['pictureUrl'],
      favorites: resp['favorites'],
    );
  }
}

class PlaceResponse {
  PlaceResponse({
    required this.places,
  });

  List<Place> places;

  factory PlaceResponse.fromJson(String str) =>
      PlaceResponse.fromMap(json.decode(str));

  factory PlaceResponse.fromMap(Map<String, dynamic> json) => PlaceResponse(
        places: List<Place>.from(json["places"].map((x) => Place.fromMap(x))),
      );
}
