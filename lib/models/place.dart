import 'dart:io';

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
} 

class Place {
  final String id;
  final String name;
  final String description;
  final List<File> images;
  final PlaceLocation location;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.location,
  });
}
