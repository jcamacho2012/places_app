import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:places_app/src/components/components.dart'
    show CollaguePicturePlace;
import 'package:places_app/src/model/models.dart' show Place;
import 'package:places_app/src/services/services.dart' show PlacesServices;
import 'package:places_app/src/theme/theme.dart';
import 'package:places_app/src/utils/utils_constants.dart';
import 'package:places_app/src/utils/utils_place.dart' show loadPlaces;
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
  bool _viewMyPlaces = true;
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
    ]);
  }

  @override
  void initState() {
    super.initState();
  }

  getMyPlaces() async {
    setState(() {
      _loadingPlaces = true;
      places = [];
    });

    List<Place> myPlaces = await loadPlaces();
    if (myPlaces.isNotEmpty) {
      setState(() {
        places = [...myPlaces];
        _loadingPlaces = false;
      });
      Set<Marker> newMarkers = _myPlacesMarkers();
      setState(() {
        markers = newMarkers;
        _centerMapOnMyPlaces();
      });
    }

    setState(() {
      _loadingPlaces = false;
    });
  }

  getFriendsPlaces() async {
    final placeService = Provider.of<PlacesServices>(context, listen: false);

    setState(() {
      _loadingPlaces = true;
      places = [];
    });

    final resultLogin = await placeService.myFriendsPlaces();
    if (resultLogin['state']) {
      setState(() {
        places = resultLogin['places'];
        _loadingPlaces = false;
      });
      Set<Marker> newMarkers = _myPlacesMarkers();
      setState(() {
        markers = newMarkers;
        _centerMapOnMyPlaces();
      });
    }

    setState(() {
      _loadingPlaces = false;
    });
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
                  setState(() {
                    _viewMyPlaces = true;
                    getMyPlaces();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _viewMyPlaces ? AppTheme.primary : Colors.transparent,
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.place,
                      size: 14,
                      color: AppTheme.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Mis Lugares',
                      style: TextStyle(color: AppTheme.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _viewMyPlaces = false;
                    getFriendsPlaces();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _viewMyPlaces ? Colors.transparent : AppTheme.primary,
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.place,
                      size: 14,
                      color: AppTheme.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Lugares de Amigos',
                      style: TextStyle(color: AppTheme.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    getMyPlaces();
    setState(() {
      _isLoading = false;
    });
  }

  void _onMarkerTapped({required int placeId}) {
    Place place = places.firstWhere((element) => element.id == placeId);
    const String customDateTimeFormat = UtilsConstants.customDateTimeFormat;
    const String dateTimeFormat = UtilsConstants.dateTimeFormat;

    DateTime dateTime = DateFormat(dateTimeFormat).parse(place.date);
    String formattedDate =
        DateFormat(customDateTimeFormat, 'es').format(dateTime);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CollaguePicturePlace(
                place: place,
                type: 'GALLERY',
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.comment,
                    color: AppTheme.primary,
                    size: 15,
                  ),
                  const SizedBox(width: 4),
                  Text("${place.comments}",
                      style: const TextStyle(
                          color: AppTheme.primary, fontSize: 12)),
                  const SizedBox(width: 10),
                  const Icon(Icons.favorite, color: Colors.red, size: 15),
                  const SizedBox(width: 4),
                  Text("${place.favorites}",
                      style: const TextStyle(color: Colors.red, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 10),
              Text(place.name,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(
                place.description,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on,
                      size: 14, color: AppTheme.primary),
                  const SizedBox(width: 5),
                  Text(place.location, style: const TextStyle(fontSize: 10)),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today,
                      size: 12, color: AppTheme.primary),
                  const SizedBox(width: 5),
                  Text(formattedDate, style: const TextStyle(fontSize: 10)),
                ],
              )
            ],
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
          visible: true,
          infoWindow: InfoWindow(
            title: place.name,
            snippet: place.location,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          )));
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
    if (markersList.isEmpty) return;
    final LatLngBounds bounds = _boundsFromLatLngList(markersList);

    mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }
}
