import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:places_app/src/model/models.dart' show Place;

class CollaguePicturePlace extends StatelessWidget {
  final Place place;
  final String type;
  const CollaguePicturePlace(
      {Key? key, required this.place, this.type = "COLLAGUE"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> pictureUrls = place.pictureUrls;
    final List<String> pictureUrlsToShow = pictureUrls.length > 3
        ? pictureUrls.sublist(0, 3)
        : pictureUrls; // Muestra solo las primeras 5 imágenes
    if (type == "COLLAGUE") {
      return SizedBox(
        width: 100, // Ancho total del collage/abanico
        height: 100, // Alto total del collage/abanico
        child: Stack(
          children: List.generate(pictureUrlsToShow.length, (index) {
            double rotation = (index - (pictureUrlsToShow.length / 2)) *
                0.1; // Ajusta la rotación según necesites
            double translation = index *
                10.0; // Ajusta este valor para controlar el "esparcimiento" de las imágenes
            Widget componentPicture = Container();
            String url = pictureUrlsToShow[index];

            if (url.contains('https')) {
              componentPicture = ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                  cacheHeight: 100,
                  cacheWidth: 100,
                ),
              );
            } else {
              File imageFile = File(url);

              componentPicture = ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                  cacheHeight: 100,
                  cacheWidth: 100,
                ),
              );
            }

            return Transform.translate(
              offset: Offset(translation,
                  0), // Traslada cada imagen un poco a la derecha de la anterior
              child: Transform.rotate(
                angle: rotation, // Rota cada imagen ligeramente
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: componentPicture,
                ),
              ),
            );
          }),
        ),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 0.3,
        height: 100,
        enlargeCenterPage: true, // Hace que la imagen central sea más grande
        scrollDirection: Axis.horizontal, // Permite el deslizamiento horizontal
        autoPlay: false, // Deshabilita la reproducción automática
        padEnds: true,
      ),
      items: pictureUrls.map((url) {
        Widget componentPicture = Container();
        if (url.contains('https')) {
          componentPicture = ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              width: 100,
              height: 100,
              cacheHeight: 100,
              cacheWidth: 100,
            ),
          );
        } else {
          File imageFile = File(url);

          componentPicture = ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.file(
              imageFile,
              fit: BoxFit.cover,
              width: 100,
              height: 100,
              cacheHeight: 100,
              cacheWidth: 100,
            ),
          );
        }

        return Builder(
          builder: (BuildContext context) {
            return Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 5.0), // Espaciado entre imágenes
                child: componentPicture);
          },
        );
      }).toList(),
    );
  }
}
