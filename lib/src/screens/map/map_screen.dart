import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places_app/src/data/data.dart';

import '../../model/models.dart' show Place;

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(-2.1431673, -79.8820324),
    zoom: 10,
  );

  bool _showMyPlaces = true;
  bool _isLoading = true;
  GoogleMapController? mapController;
  final List<Place> places = listaPlacesVisited();

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers =
        _showMyPlaces ? _myPlacesMarkers() : _friendsPlacesMarkers();

    return Stack(children: [
      GoogleMap(
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        tiltGesturesEnabled: false,
        myLocationButtonEnabled: false,
        onCameraMove: (CameraPosition cameraPosition) {
          // print(cameraPosition.zoom);
        },
        initialCameraPosition: _initialPosition,
        onMapCreated: _onMapCreated,
        markers: markers,
      ),
      if (_isLoading) // Muestra el indicador de carga si _isLoading es true
        const Center(
          child:
              CircularProgressIndicator(), // Puedes personalizar este widget según necesites
        ),
      if (!_isLoading) _buttonsPlaces(),
      if (!_isLoading) _buttonsZoom(),
    ]);
  }

  Widget _buttonsZoom() {
    return Positioned(
        top: 500.0, // Ajusta la posición según necesites
        right: 10.0,
        child: Column(children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              mapController?.animateCamera(CameraUpdate.zoomIn());
            },
            mini: true,
            tooltip: 'Zoom In',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              mapController?.animateCamera(CameraUpdate.zoomOut());
            },
            mini: true,
            tooltip: 'Zoom Out',
            child: const Icon(Icons.remove),
          ),
        ]));
  }

  Widget _buttonsPlaces() {
    return Positioned(
      top: 40.0,
      right: 10.0,
      child: Column(
        children: [
          FloatingActionButton(
            tooltip: 'Mis Lugares Visitados',
            onPressed: () {
              setState(() {
                _showMyPlaces = true;
              });
            },
            child: const Icon(Icons.person),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _showMyPlaces = false;
              });
            },
            tooltip: 'Lugares Visitados por Amigos',
            child: const Icon(Icons.people),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _isLoading = false;
    });
  }

  void _onMarkerTapped({required int placeId}) {
    Place place = places.firstWhere((element) => element.id == placeId);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    place.pictureUrl,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.comment,
                      color: Colors.blue,
                      size: 15,
                    ),
                    const SizedBox(width: 4),
                    Text("${place.comments}",
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 12)),
                    const SizedBox(width: 10),
                    const Icon(Icons.favorite, color: Colors.red, size: 15),
                    const SizedBox(width: 4),
                    Text("${place.favorites}",
                        style:
                            const TextStyle(color: Colors.red, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 10),
                Text('${place.name} - ${place.location}'),
                Text('${place.date}'),
              ],
            ),
          ),
        );
      },
    );
  }

  Set<Marker> _myPlacesMarkers() {
    Set<Marker> markers = {};
    for (Place place in places) {
      markers.add(Marker(
        markerId: MarkerId(place.id.toString()),
        position: LatLng(place.latitude, place.longitude),
        onTap: () => _onMarkerTapped(placeId: place.id),
        infoWindow: InfoWindow(
          title: place.name,
          snippet: place.location,
        ),
      ));
    }
    return markers;
  }

  Set<Marker> _friendsPlacesMarkers() {
    Set<Marker> markers = {};
    for (Place place in places) {
      markers.add(Marker(
        markerId: MarkerId(place.id.toString()),
        position: LatLng(place.latitude, place.longitude),
        onTap: () => _onMarkerTapped(placeId: place.id),
        infoWindow: InfoWindow(
          title: place.name,
          snippet: place.location,
        ),
      ));
    }
    return markers;
  }
}
