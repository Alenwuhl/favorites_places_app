import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:favorite_places_app/models/place.dart';
import 'dart:io';

final uuid = Uuid();

class UserPlaces extends StateNotifier<List<Place>> {
  UserPlaces([List<Place>? initialPlaces]) : super(initialPlaces ?? []);

  void addPlace(String name, String description, List<File> images) {
    final newPlace = Place(
      id: uuid.v4(),
      name: name,
      description: description,
      images: images,
    );
    state = [...state, newPlace];
  }
}

final userPlacesProvider = StateNotifierProvider<UserPlaces, List<Place>>((ref) {
  return UserPlaces();
});
