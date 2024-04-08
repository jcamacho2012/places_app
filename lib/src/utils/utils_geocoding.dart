import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

FutureOr<String?> getPlaceName(Position position) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      return '${place.locality}, ${place.country}';
    }
  } catch (e) {
    print(e);
    return null;
  }
  return null;
}
