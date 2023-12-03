import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  _takePicture(ImageSource source) async {
    final imageFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: 600,
    );
    if (imageFile != null) {
      setState(() {
        _storedImage = File(imageFile.path);
      });
      final appDirectory = await syspaths.getApplicationDocumentsDirectory();
      final fileName = path.basename(imageFile.path);
      final savedImage =
          await File(imageFile.path).copy('${appDirectory.path}/$fileName');
      widget.onSelectImage(savedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 200,
          height: 100,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(15)),
          alignment: Alignment.center,
          child: _storedImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(
                    _storedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                )
              : const Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
        ),
        const SizedBox(width: 10),
        TextButton.icon(
          onPressed: () async {
            _takePicture(ImageSource.camera);
          },
          icon: const Icon(Icons.camera),
          label: const Text('Add picture'),
        )
      ],
    );
  }
}
