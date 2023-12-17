import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';


class PlaceDetailScreen extends StatelessWidget {
  static const routeName = '/place-detail-screen';

  const PlaceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final id = ModalRoute.of(context)?.settings.arguments;
    final selectedPlace = Provider.of<GreatPlaces>(context, listen: false)
        .findById(id.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
        actions: [
          IconButton(
              onPressed: () async {
                await Provider.of<GreatPlaces>(context, listen: false)
                    .deletePlace(id.toString());
                navigator.pushReplacementNamed('/');
              },
              icon: const Icon(Icons.delete, color: Colors.red))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Image.file(
                selectedPlace.image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              selectedPlace.title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              width: double.infinity,
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FlutterMap(
                    options: MapOptions(
                      initialZoom: 8.5,
                      initialCenter: LatLng(
                        selectedPlace.location.latitude,
                        selectedPlace.location.longitude,
                      ),
                      // Uncomment the argument if you wanna lock interaction
                      // interactionOptions:
                      //     InteractionOptions(flags: InteractiveFlag.none),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(markers: [
                        Marker(
                            point: LatLng(
                              selectedPlace.location.latitude,
                              selectedPlace.location.longitude,
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ))
                      ])
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
