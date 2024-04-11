import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:places_app/src/components/show_snack_bar.dart';
import 'package:places_app/src/model/models.dart' show Place;
import 'package:places_app/src/theme/theme.dart';
import 'package:places_app/src/utils/utils_constants.dart';
import 'package:places_app/src/utils/utils_place.dart'
    show loadPlaces, savePlaces;
import 'package:places_app/src/components/show_snack_bar.dart'
    show showSnackBar;
import 'package:places_app/src/utils/utils_geolocator.dart'
    show determinePosition;
import 'package:places_app/src/utils/utils_geocoding.dart' show getPlaceName;

class NewPlaceScreen extends StatefulWidget {
  const NewPlaceScreen({Key? key}) : super(key: key);
  @override
  State<NewPlaceScreen> createState() => _NewPlaceScreenState();
}

class _NewPlaceScreenState extends State<NewPlaceScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<File> _images = [];
  Position? currentLocation;
  String? placeName;
  bool _loadingLocation = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (_loadingLocation) const LinearProgressIndicator(),
                renderCurrentLocation(),
                TextField(
                  controller: _nameController,
                  decoration:
                      const InputDecoration(labelText: 'Nombre del Lugar'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                const SizedBox(
                  height: 10,
                ),
                renderButtonsUploadPictures(),
                const SizedBox(
                  height: 20,
                ),
                renderPreviewPictures(),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await _saveMyPlace();
            },
            child: const Icon(
              Icons.save,
              color: Colors.white,
            ),
          )),
    );
  }

  Widget renderPreviewPictures() {
    if (_images.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text('No hay imágenes seleccionadas'),
          ],
        ),
      );
    }

    return Expanded(
      child: GridView.builder(
        itemCount: _images.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Tres columnas
          crossAxisSpacing: 10, // Espacio horizontal entre los elementos
          mainAxisSpacing: 20, // Espacio vertical entre los elementos
        ),
        itemBuilder: (context, index) {
          return Stack(
            alignment: Alignment
                .center, // Alinea el ícono de borrar en la esquina superior derecha
            children: [
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppTheme.primary,
                        width: 5), // Borde ancho color blanco
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.file(
                      _images[index],
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                      cacheHeight: 100,
                      cacheWidth: 100,
                    ),
                  )),
              Positioned(
                bottom: -10,
                right: -10,
                child: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 25,
                  ),
                  onPressed: () {
                    setState(() {
                      _images.removeAt(index);
                    });
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget renderButtonsUploadPictures() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () => _pickImage(ImageSource.camera),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt,
                  color: AppTheme.white,
                  size: 14,
                ),
                SizedBox(width: 5),
                Text(
                  'Tomar Foto',
                  style: TextStyle(fontSize: 12, color: AppTheme.white),
                )
              ],
            )),
        ElevatedButton(
          onPressed: () => _pickImage(ImageSource.gallery),
          child: const Row(
            children: [
              Icon(
                Icons.image,
                size: 14,
                color: AppTheme.white,
              ),
              SizedBox(width: 5),
              Text(
                'Escoger Foto(s)',
                style: TextStyle(fontSize: 12, color: AppTheme.white),
              )
            ],
          ),
        ),
      ],
    );
  }

  initCurrentLocation() async {
    setState(() {
      _loadingLocation = true;
    });
    Position currentLocation = await determinePosition();
    String? placeName = await getPlaceName(currentLocation);
    setState(() {
      this.currentLocation = currentLocation;
      this.placeName = placeName;
      _loadingLocation = false;
    });
  }

  Widget renderCurrentLocation() {
    if (_loadingLocation) return const SizedBox();
    if (placeName != null) {
      return Row(children: [
        const Icon(Icons.location_on, color: AppTheme.primary),
        const SizedBox(width: 5),
        Text(placeName!, style: const TextStyle(fontSize: 12)),
      ]);
    } else {
      return const Row(children: [
        Icon(Icons.location_off, color: Colors.red),
        SizedBox(width: 5),
        Text('Ubicación no disponible', style: TextStyle(fontSize: 12)),
      ]);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    if (source == ImageSource.gallery) {
      final List<XFile> pickedFiles = await picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _images.addAll(pickedFiles.map((file) => File(file.path)).toList());
        });
      }
    } else if (source == ImageSource.camera) {
      final XFile? pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _images.add(File(pickedFile.path));
        });
      }
    }
  }

  Future<void> _saveMyPlace() async {
    final String name = _nameController.text;
    final String description = _descriptionController.text;
    bool stateValidationFields = _validationFields();

    if (!stateValidationFields) return;

    final List<String> imagePaths = _images.map((file) => file.path).toList();

    final int newId = generateUniqueId();
    DateTime now = DateTime.now();
    const String dateTimeFormat = UtilsConstants.dateTimeFormat;

    String formattedDate = DateFormat(dateTimeFormat).format(now);

    final Place newPlace = Place(
      id: newId,
      name: name,
      location: placeName ?? 'Ubicación no disponible',
      latitude: currentLocation!.latitude,
      longitude: currentLocation!.longitude,
      description: description,
      date: formattedDate,
      pictureUrls: imagePaths,
      comments: 0,
      favorites: 0,
    );

    await addPlace(newPlace);
    if (!context.mounted) return;

    showSnackBar(
        icon: const Icon(
          Icons.check_circle,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
        context: context,
        message: 'Registro exitoso');

    Navigator.pop(context, true);
  }

  bool _validationFields() {
    final String name = _nameController.text;
    final String description = _descriptionController.text;

    if (name.isEmpty) {
      showSnackBar(
          icon: const Icon(
            Icons.error,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          context: context,
          message: 'Debe ingresar un nombre');
      return false;
    }

    if (description.isEmpty) {
      showSnackBar(
          icon: const Icon(
            Icons.error,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          context: context,
          message: 'Debe ingresar una descripción');
      return false;
    }

    if (_images.isEmpty) {
      showSnackBar(
          icon: const Icon(
            Icons.error,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          context: context,
          message: 'Debe seleccionar una imagen');
      return false;
    }

    return true;
  }

  int generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  Future<void> addPlace(Place newPlace) async {
    final List<Place> places = await loadPlaces();
    places.add(newPlace);
    await savePlaces(places);
  }
}
