import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../models/place.dart';
import '../helpers/db_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return _items;
  }

  Place findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> deletePlace(String id) async {
    DBHelper.delete(id);
    notifyListeners();
  }

  Future<void> addPlace(
    String title,
    File image,
    PlaceLocation placeLocation,
  ) async {
    final place = await placemarkFromCoordinates(
        placeLocation.latitude, placeLocation.longitude);
    Placemark placeMark = place[0];
    final name = placeMark.name;
    final subLocality = placeMark.subLocality;
    final locality = placeMark.locality;
    final administrativeArea = placeMark.administrativeArea;
    final postalCode = placeMark.postalCode;
    final country = placeMark.country;
    final address =
        "$name, $subLocality, $locality, $administrativeArea $postalCode, $country";
    final updatedPlaceLocaion = PlaceLocation(
      latitude: placeLocation.latitude,
      longitude: placeLocation.longitude,
      address: address,
    );
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: image,
      title: title,
      location: updatedPlaceLocaion,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map((item) => Place(
              id: item['id'],
              title: item['title'],
              image: File(item['image']),
              location: PlaceLocation(
                latitude: item['loc_lat'],
                longitude: item['loc_lng'],
                address: item['address'],
              ),
            ))
        .toList();
  }
}
