import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryPhotoViewWrapper extends StatelessWidget {
  final List<String> galleryItems;
  final BoxDecoration backgroundDecoration;
  final int initialIndex;

  const GalleryPhotoViewWrapper(
      {Key? key,
      required this.galleryItems,
      required this.backgroundDecoration,
      required this.initialIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: FileImage(File(galleryItems[index])),
              initialScale: PhotoViewComputedScale.contained,
              heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index]),
            );
          },
          itemCount: galleryItems.length,
          backgroundDecoration: backgroundDecoration,
          pageController: PageController(initialPage: initialIndex),
          onPageChanged: (int index) {},
        ),
      ),
    );
  }
}
