import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
// import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  LatLng? _locationData;
  bool _isLoading = false;

  final Map<String, dynamic> address = {};

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });
    final locationData = await Location().getLocation();
    // print(locationData.latitude);
    // print(locationData.longitude);
    setState(() {
      _locationData = LatLng(
        double.parse(locationData.latitude.toString()),
        double.parse(locationData.longitude.toString()),
      );
      _isLoading = false;
    });
  }

  Marker myMarker() {
    if (_locationData != null) {
      return Marker(
        rotate: true,
        point: _locationData!,
        child: const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 30,
        ),
      );
    } else {
      return const Marker(
        rotate: true,
        point: LatLng(50.5, 30.51),
        child: Icon(
          Icons.location_on,
          color: Color.fromARGB(0, 244, 67, 54),
          size: 30,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          child: Container(
            height: 320,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(children: [
                _isLoading
                    ? const SizedBox(
                        child: Center(child: CircularProgressIndicator()))
                    : FlutterMap(
                        options: MapOptions(
                            initialCenter:
                                _locationData ?? const LatLng(50.5, 30.51),
                            initialZoom: 8,
                            onTap: (tapPosition, latLng) {
                              setState(() {
                                _locationData = latLng;
                              });
                            }),
                        children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                            ),
                            MarkerLayer(markers: [
                              myMarker(),
                            ])
                          ]),
                Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton.filledTonal(
                    tooltip: 'Get my location',
                    color: Colors.indigo,
                    onPressed: _getCurrentLocation,
                    icon: const Icon(Icons.location_searching),
                  ),
                )
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
