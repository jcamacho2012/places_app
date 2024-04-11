import 'package:flutter/material.dart';
import 'package:places_app/src/components/components.dart'
    show GalleryPhotoViewWrapper;

class GalleryViewer extends StatelessWidget {
  final int initialIndex;
  final List<String> imageUrls;

  const GalleryViewer(
      {Key? key, required this.initialIndex, required this.imageUrls})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Fondo semitransparente
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () =>
              Navigator.of(context).pop(), // Cierra la vista actual y regresa
        ),
      ),
      body: GalleryPhotoViewWrapper(
        galleryItems: imageUrls,
        backgroundDecoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        initialIndex: initialIndex,
      ),
    );
  }
}
