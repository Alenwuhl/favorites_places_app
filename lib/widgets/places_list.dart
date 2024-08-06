import 'package:favorite_places_app/models/place.dart';
import 'package:favorite_places_app/screens/add_place.dart';
import 'package:favorite_places_app/screens/places_details_screen.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('No places added yet!', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const AddPlaceScreen(),
                  ),
                );
              },
              child: const Text('Add a Place'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(itemCount: places.length, itemBuilder: (ctx, index) => ListTile(
      title: Text(places[index].name, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.primary)),
      subtitle: Text(places[index].description),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => PlacesDetailsScreen(place: places[index]),),);
      },
    ),);
  }
}