import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places_app/src/components/components.dart' show ButtonZoomMap;
import 'package:places_app/src/data/data.dart';
import 'package:places_app/src/model/models.dart' show Place;
import 'package:places_app/src/services/services.dart' show PlacesServices;
import 'package:provider/provider.dart';

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

  bool _isLoading = true;
  bool _loadingPlaces = false;
  GoogleMapController? mapController;
  List<Place> places = [];
  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
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
      if (_loadingPlaces)
        const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Cargando...'),
            ],
          ),
        ),
      if (_isLoading)
        const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Cargando Mapa...'),
            ],
          ),
        ),
      if (!_isLoading) _buttonsPlaces(context: context),
      if (!_isLoading) _buttonsZoom(),
    ]);
  }

  @override
  void initState() {
    super.initState();
    getMyPlaces();
  }

  getMyPlaces() async {
    final placeService = Provider.of<PlacesServices>(context, listen: false);
    setState(() {
      _loadingPlaces = true;
    });
    final resultLogin = await placeService.myPlaces();
    if (resultLogin['state']) {
      setState(() {
        places = resultLogin['places'];
        _loadingPlaces = false;
      });
      markers = _myPlacesMarkers();
    }
  }

  Widget _buttonsZoom() {
    return Positioned(
        bottom: 20.0,
        right: 10.0,
        child: Column(children: <Widget>[
          ButtonZoomMap(
            onPressed: () {
              mapController?.animateCamera(CameraUpdate.zoomIn());
            },
            tooltip: 'Zoom In',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          ButtonZoomMap(
            onPressed: () {
              mapController?.animateCamera(CameraUpdate.zoomOut());
            },
            tooltip: 'Zoom Out',
            child: const Icon(Icons.remove),
          ),
        ]));
  }

  Widget _buttonsPlaces({required BuildContext context}) {
    double top = MediaQuery.of(context).padding.top;
    return Positioned(
        top: top,
        right: 0,
        left: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  getMyPlaces();
                  _myPlacesMarkers();
                  _centerMapOnMyPlaces();
                },
                child: const Row(
                  children: [
                    Icon(Icons.place),
                    SizedBox(width: 5),
                    Text('Mis Lugares'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _friendsPlacesMarkers();
                  _centerMapOnMyPlaces();
                },
                child: const Row(
                  children: [
                    Icon(Icons.place),
                    SizedBox(width: 5),
                    Text('Lugares de Amigos'),
                  ],
                ),
              ),
            ],
          ),
        ));
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
                    cacheHeight: 100,
                    cacheWidth: 100,
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
                Text(place.date),
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

  LatLngBounds _boundsFromLatLngList(List<Marker> markers) {
    double? x0, x1, y0, y1;
    for (Marker marker in markers) {
      if (x0 == null) {
        x0 = x1 = marker.position.latitude;
        y0 = y1 = marker.position.longitude;
      } else {
        if (marker.position.latitude > x1!) x1 = marker.position.latitude;
        if (marker.position.latitude < x0) x0 = marker.position.latitude;
        if (marker.position.longitude > y1!) y1 = marker.position.longitude;
        if (marker.position.longitude < y0!) y0 = marker.position.longitude;
      }
    }
    return LatLngBounds(
        southwest: LatLng(x0!, y0!), northeast: LatLng(x1!, y1!));
  }

  void _centerMapOnMyPlaces() {
    List<Marker> markersList = markers.toList();
    final LatLngBounds bounds = _boundsFromLatLngList(markersList);

    mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }
}
