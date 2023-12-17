import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

import '../models/place.dart';
import '../providers/great_places.dart';
import '../widgets/image_input.dart';
import '../widgets/location_input.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _pickedImage;
  PlaceLocation? _locationData;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectPlace(LatLng locationData)  {
    _locationData =  PlaceLocation(
      latitude: locationData.latitude,
      longitude: locationData.longitude,
    );
  }

  void _savePlace() {
    print(_titleController.text);
    print(_pickedImage);
    print(_locationData);
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _locationData == null) {
      showDialog(
          context: context,
          builder: (ctx) => const AlertDialog(
                title: Text('Please fill out the form!'),
              ));
      return;
    }
    Provider.of<GreatPlaces>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage!, _locationData!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add a new place'),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              decoration: InputDecoration(
                  label: const Text('Title'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  )),
              controller: _titleController,
            ),
            const SizedBox(height: 15),
            ImageInput(_selectImage),
            const SizedBox(height: 15),
            LocationInput(_selectPlace),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: _savePlace,
              icon: const Icon(Icons.add),
              label: const Text('Add Place'),
            ),
          ],
        ),
      ),
    );
  }
}
