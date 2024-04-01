import 'package:places_app/src/model/models.dart' show Place;

List<Place> listaPlacesVisited() {
  return [
    Place(
      id: 1,
      latitude: -2.1431673,
      longitude: -79.8820324,
      name: "Parque Natural",
      location: "Ciudad Verde",
      description: "Un lugar para disfrutar de la naturaleza",
      date: "2024-03-31",
      pictureUrl:
          "https://media.timeout.com/images/103952107/750/422/image.jpg",
      comments: 120,
      favorites: 300,
    ),
    Place(
      id: 2,
      latitude: -2.1276059,
      longitude: -79.9008128,
      name: "Parque Natural",
      location: "Ciudad Verde",
      description: "Un lugar para disfrutar de la naturaleza",
      date: "2024-03-31",
      pictureUrl:
          "https://media.timeout.com/images/103952107/750/422/image.jpg",
      comments: 120,
      favorites: 300,
    ),
  ];
}
