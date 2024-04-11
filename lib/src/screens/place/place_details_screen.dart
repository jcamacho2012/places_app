import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:places_app/src/components/components.dart' show GalleryViewer;
import 'package:places_app/src/model/models.dart' show Place;
import 'package:places_app/src/theme/theme.dart';
import 'package:places_app/src/utils/utils_constants.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final Place place;
  const PlaceDetailsScreen({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 150,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.arrow_back_ios, color: Colors.white),
              SizedBox(width: 5),
              Text('Lugares',
                  style: TextStyle(color: Colors.white, fontSize: 15)),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            renderName(place),
            renderDescription(place),
            const SizedBox(height: 10),
            renderLocation(place),
            const SizedBox(height: 5),
            renderDate(place),
            renderSocialInfo(place),
            const SizedBox(height: 15),
            renderPictures(place),
          ],
        ),
      ),
    );
  }

  Widget renderPictures(Place place) {
    final List<String> imageUrls = place.pictureUrls;

    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Número de columnas
          crossAxisSpacing: 8, // Espaciado horizontal
          mainAxisSpacing: 10, // Espaciado vertical
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          File imageFile = File(imageUrls[index]);
          return GestureDetector(
            onTap: () => _openImageGallery(context, index, imageUrls),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget renderDate(Place place) {
    const String customDateTimeFormat = UtilsConstants.customDateTimeFormat;
    const String dateTimeFormat = UtilsConstants.dateTimeFormat;

    DateTime dateTime = DateFormat(dateTimeFormat).parse(place.date);
    String formattedDate =
        DateFormat(customDateTimeFormat, 'es').format(dateTime);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.calendar_today, size: 12, color: AppTheme.primary),
        const SizedBox(width: 5),
        Text(formattedDate, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget renderName(Place place) {
    return Text(
      place.name,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget renderDescription(Place place) {
    return Text(
      place.description,
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget renderLocation(Place place) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.location_on, size: 14, color: AppTheme.primary),
        const SizedBox(width: 5),
        Text(place.location, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget renderSocialInfo(Place place) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.comment,
          color: AppTheme.primary,
          size: 15,
        ),
        const SizedBox(width: 4),
        Text("${place.comments}",
            style: const TextStyle(color: AppTheme.primary, fontSize: 12)),
        const SizedBox(width: 10),
        const Icon(Icons.favorite, color: Colors.red, size: 15),
        const SizedBox(width: 4),
        Text("${place.favorites}",
            style: const TextStyle(color: Colors.red, fontSize: 12)),
      ],
    );
  }

  void _openImageGallery(
      BuildContext context, int initialIndex, List<String> imageUrls) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GalleryViewer(
              initialIndex: initialIndex,
              imageUrls: imageUrls,
            )));
  }
}
