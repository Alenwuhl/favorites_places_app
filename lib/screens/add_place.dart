import 'package:favorite_places_app/models/place.dart';
import 'package:favorite_places_app/providers/user_places.dart';
import 'package:favorite_places_app/widgets/image_input.dart';
import 'package:favorite_places_app/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});
  static const routeName = '/add-place';

  @override
  _AddPlaceScreenState createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<File> _pickedImages = [];
  PlaceLocation? _selectedLocation;

  void _selectImage(File pickedImage) {
    setState(() {
      _pickedImages.add(pickedImage);
    });
  }

  void _savePlace() {
    final enteredName = _nameController.text;
    final enteredDescription = _descriptionController.text;

    if (enteredName.isEmpty ||
        enteredDescription.isEmpty ||
        _pickedImages.isEmpty) {
      showAboutDialog(
        context: context,
        children: <Widget>[
          const Text(
              'Please enter a name, description, and take at least one picture.'),
        ],
      );
      return;
    }

    ref.read(userPlacesProvider.notifier).addPlace(
          enteredName,
          enteredDescription,
          _pickedImages,
          _selectedLocation!,
        );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Place'),
      ),
      body: SingleChildScrollView(
        // Envuelve todo el contenido para permitir el scroll
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              ImageInput(onSelectImage: _selectImage),
              const SizedBox(height: 10),
              LocationInput(onSelectPlace: (location) {
                _selectedLocation = location;
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePlace,
                child: const Text('Add Place'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
