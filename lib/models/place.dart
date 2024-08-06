import 'dart:io';

class Place {
  final String id;
  final String name;
  final String description;
  final List<File> images;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
  });
}
