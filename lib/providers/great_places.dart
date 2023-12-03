import 'dart:io';

import 'package:flutter/material.dart';

import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return _items;
  }

  void addPlace(
    String title,
    File image,
  ) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: image,
      title: title,
      location: PlaceLocation(latitude: 1, longitude: 1),
    );
    _items.add(newPlace);
    notifyListeners();
  }
}
