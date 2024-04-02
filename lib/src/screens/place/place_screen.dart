import 'package:flutter/material.dart';
import 'package:places_app/src/components/components.dart'
    show WelcomeWidget, SkeletonPlaces;
import 'package:places_app/src/model/models.dart' show Place;
import 'package:provider/provider.dart';
import "package:places_app/src/services/services.dart" show PlacesServices;

class PlaceScreen extends StatefulWidget {
  const PlaceScreen({Key? key}) : super(key: key);

  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  List<Place> places = [];
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
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

  @override
  void initState() {
    super.initState();
    getPlacesVisited();
  }

  getPlacesVisited() async {
    final placeService = Provider.of<PlacesServices>(context, listen: false);
    setState(() {
      _loading = true;
    });
    final resultLogin = await placeService.myPlaces();
    if (resultLogin['state']) {
      setState(() {
        places = resultLogin['places'];
        _loading = false;
      });
    }
  }

  Widget renderPlacesVisited(List<Place> places) {
    if (_loading) {
      return ListView.builder(
          itemCount: 4,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return const SkeletonPlaces();
          });
    }

    return Expanded(
      child: RefreshIndicator(
        displacement: 10,
        color: const Color(0xff00209f),
        strokeWidth: 2,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: () async {
          getPlacesVisited();
        },
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
                      renderTitlePlace(place),
                      const SizedBox(height: 5),
                      renderSubtitlePlace(place),
                      const SizedBox(height: 5),
                      renderSocialInfo(place)
                    ],
                  ),
                  trailing: renderPicturePlace(place),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget renderTitlePlace(Place place) {
    return Text(place.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14));
  }

  Widget renderSubtitlePlace(Place place) {
    return Text("${place.location} - ${place.date}",
        style: const TextStyle(fontSize: 12));
  }

  Widget renderPicturePlace(Place place) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network(
        place.pictureUrl,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
        cacheHeight: 100,
        cacheWidth: 100,
      ),
    );
  }

  Widget renderSocialInfo(Place place) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.comment,
          color: Colors.blue,
          size: 15,
        ),
        const SizedBox(width: 4),
        Text("${place.comments}",
            style: const TextStyle(color: Colors.blue, fontSize: 12)),
        const SizedBox(width: 10),
        const Icon(Icons.favorite, color: Colors.red, size: 15),
        const SizedBox(width: 4),
        Text("${place.favorites}",
            style: const TextStyle(color: Colors.red, fontSize: 12)),
      ],
    );
  }
}
