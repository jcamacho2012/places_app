class Place {
  int id;
  String name;
  String location;
  double latitude;
  double longitude;
  String description;
  String date;
  String pictureUrl;
  int comments;
  int favorites;

  Place({
    required this.id,
    required this.name,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.date,
    required this.comments,
    required this.pictureUrl,
    required this.favorites,
  });
}
