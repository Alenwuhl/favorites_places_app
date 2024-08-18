import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:favorite_places_app/models/place.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

const uuid = Uuid();

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  return sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, name TEXT, description TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
    },
    version: 1,
  );
}

class UserPlaces extends StateNotifier<List<Place>> {
  UserPlaces([List<Place>? initialPlaces]) : super(initialPlaces ?? []);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data
        .map((row) => Place(
              id: row['id'] as String,
              name: row['name'] as String,
              description: row['description'] as String,
              images: [File(row['image'] as String)],
              location: PlaceLocation(
                latitude: row['loc_lat'] as double,
                longitude: row['loc_lng'] as double,
                address: row['address'] as String,
              ),
            ))
        .toList();

    state = places;
  }

  void addPlace(String name, String description, List<File> images,
      PlaceLocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();

    final copiedImages = await Future.wait(images.map((image) async {
      final fileName = path.basename(image.path);
      final copiedImage = await image.copy('${appDir.path}/$fileName');
      return copiedImage;
    }).toList());

    final newPlace = Place(
      id: uuid.v4(),
      name: name,
      description: description,
      images: copiedImages,
      location: location,
    );

    final db = await _getDatabase();
    await db.insert(
      'user_places',
      {
        'id': newPlace.id,
        'name': newPlace.name,
        'description': newPlace.description,
        'image': newPlace.images[0].path,
        'loc_lat': newPlace.location.latitude,
        'loc_lng': newPlace.location.longitude,
        'address': newPlace.location.address,
      },
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    state = [...state, newPlace];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlaces, List<Place>>((ref) {
  return UserPlaces();
});
