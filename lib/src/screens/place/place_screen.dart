import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:places_app/src/components/components.dart'
    show WelcomeWidget, SkeletonPlaces, CollaguePicturePlace;
import 'package:places_app/src/model/models.dart' show Place;
import 'package:places_app/src/theme/theme.dart';
import 'package:places_app/src/utils/utils_constants.dart';
import 'package:places_app/src/utils/utils_place.dart'
    show deletePlace, loadPlaces;
import 'package:places_app/src/components/show_snack_bar.dart'
    show showSnackBar;
import 'package:flutter_slidable/flutter_slidable.dart';

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
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
                padding:
                    EdgeInsets.only(top: 30, right: 20, left: 20, bottom: 30),
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
        ),
        Positioned(
            bottom: 20,
            right: 10,
            child: FloatingActionButton(
              onPressed: () async {
                final successNewPlace =
                    await Navigator.pushNamed(context, 'new_place');
                if (successNewPlace == true) {
                  getPlacesVisited();
                }
              },
              heroTag: 'new_place',
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ))
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getPlacesVisited();
    initializeDateFormatting();
  }

  getPlacesVisited() async {
    setState(() {
      _loading = true;
      places = [];
    });
    List<Place> myPlaces = await loadPlaces();
    if (myPlaces.isNotEmpty) {
      setState(() {
        places = [...myPlaces];
        _loading = false;
      });
    }
    setState(() {
      _loading = false;
    });
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

    if (places.isEmpty) {
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
            itemCount: 1,
            itemBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.all(50),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.place, size: 100, color: Colors.grey),
                      SizedBox(height: 10),
                      Text('No hay lugares visitados',
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              );
            }),
      ));
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
            return Slidable(
              endActionPane: ActionPane(
                extentRatio: 0.30,
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) => _showConfirmationDialog(context, place),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Eliminar',
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'place_details',
                      arguments: place);
                },
                child: Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              renderTitlePlace(place),
                              const SizedBox(height: 5),
                              renderDescriptionPlace(place),
                              const SizedBox(height: 5),
                              renderSubtitlePlace(place),
                              const SizedBox(height: 10),
                              renderSocialInfo(place)
                            ],
                          ),
                          CollaguePicturePlace(
                            place: place,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _showConfirmationDialog(BuildContext context, Place place) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Eliminar ${place.name}'),
            content: const Flexible(
              child: Text('¿Estás seguro de eliminar este lugar?',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 16,
                  )),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  confirmDeletePlace(place);
                },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                    SizedBox(width: 5),
                    Text('Eliminar', style: TextStyle(color: Colors.white)),
                  ],
                ),
              )
            ],
          );
        });
  }

  void confirmDeletePlace(Place place) async {
    await deletePlace(place.id);
    getPlacesVisited();
    if (!context.mounted) return;

    showSnackBar(
        icon: const Icon(
          Icons.check_circle,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
        context: context,
        message: 'Registro Eliminado');
    Navigator.pop(context);
  }

  Widget renderTitlePlace(Place place) {
    return Text(place.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14));
  }

  Widget renderDescriptionPlace(Place place) {
    return Text(place.description, style: const TextStyle(fontSize: 12));
  }

  Widget renderSubtitlePlace(Place place) {
    const String customDateTimeFormat = UtilsConstants.customDateTimeFormat;
    const String dateTimeFormat = UtilsConstants.dateTimeFormat;

    DateTime dateTime = DateFormat(dateTimeFormat).parse(place.date);
    String formattedDate =
        DateFormat(customDateTimeFormat, 'es').format(dateTime);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 14, color: AppTheme.primary),
            const SizedBox(width: 5),
            Text(place.location, style: const TextStyle(fontSize: 10)),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today, size: 12, color: AppTheme.primary),
            const SizedBox(width: 5),
            Text(formattedDate, style: const TextStyle(fontSize: 10)),
          ],
        )
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
}
