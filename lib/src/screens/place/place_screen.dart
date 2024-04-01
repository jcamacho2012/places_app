import 'package:flutter/material.dart';
import 'package:places_app/src/data/data.dart';
import 'package:places_app/src/model/models.dart' show Place;
import '../../components/components.dart' show WelcomeWidget;

class PlaceScreen extends StatelessWidget {
  const PlaceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Place> places = listaPlacesVisited();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
            padding: EdgeInsets.only(top: 30, right: 20, left: 20, bottom: 30),
            child: WelcomeWidget()),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Lugares visitados',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        renderPlacesVisited(places),
      ],
    );
  }

  Widget renderPlacesVisited(List<Place> places) {
    return Expanded(
      child: ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          final Place place = places[index];
          return Card(
            elevation: 5,
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 5),
                    Text("${place.location} - ${place.date}",
                        style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.comment,
                          color: Colors.blue,
                          size: 15,
                        ),
                        const SizedBox(width: 4),
                        Text("${place.comments}",
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 12)),
                        const SizedBox(width: 10),
                        const Icon(Icons.favorite, color: Colors.red, size: 15),
                        const SizedBox(width: 4),
                        Text("${place.favorites}",
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                trailing: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      8.0), // Ajusta el radio del borde aquí
                  child: Image.network(
                    place.pictureUrl,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
