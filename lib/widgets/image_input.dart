import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function(File) onSelectImage;

  const ImageInput({super.key, required this.onSelectImage});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  final List<File> _takenImages = [];

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      final imageFile = File(pickedImage.path);
      _takenImages.add(imageFile);
      widget.onSelectImage(imageFile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_takenImages.isNotEmpty)
          SizedBox(
            height: 250,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _takenImages.length,
              itemBuilder: (ctx, index) => Container(
                width: 250,
                margin: const EdgeInsets.all(10),
                child: Image.file(
                  _takenImages[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        TextButton.icon(
          icon: const Icon(Icons.camera_alt),
          label: const Text('Take Pictures'),
          onPressed: _takePicture,
        ),
      ],
    );
  }
}
