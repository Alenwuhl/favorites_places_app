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
  int _currentPage = 0;

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
        _pickedImages.isEmpty ||
        _selectedLocation == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Missing Information'),
          content: const Text(
              'Please enter a name, description, take at least one picture, and select a location.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Okay'),
            ),
          ],
        ),
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
              _pickedImages.isEmpty
                  ? ImageInput(onSelectImage: _selectImage)
                  : Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              PageView.builder(
                                itemCount: _pickedImages.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                },
                                itemBuilder: (ctx, index) => Image.file(
                                  _pickedImages[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              if (_pickedImages.length > 1)
                                Positioned(
                                  bottom: 10,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      _pickedImages.length,
                                      (index) => Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _currentPage == index
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            ImageInput(onSelectImage: _selectImage);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("Add another image"),
                        )
                      ],
                    ),
              const SizedBox(height: 20),
              LocationInput(
                onSelectLocation: (PlaceLocation location) {
                  _selectedLocation = location;
                },
              ),
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
