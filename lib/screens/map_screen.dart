import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  static const String route = 'map';

  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  LatLng? _selectedLocation;

  void _selectLocation(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _save(LatLng position) {
    Navigator.of(context).pop(_selectedLocation ?? position);
  }

  @override
  Widget build(BuildContext context) {
    LocationData? locationData =
        ModalRoute.of(context)?.settings.arguments as LocationData?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione uma localização'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _save(
              LatLng(locationData?.latitude ?? 0.0,
                  locationData?.longitude ?? 0.0),
            ),
          )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(-8.407711439884904, -55.07146254469307),
          // LatLng(
          //   locationData?.latitude ?? 0.0,
          //   locationData?.longitude ?? 0.0,
          // ),
          zoom: 16,
        ),
        onTap: _selectLocation,
        markers: {
          Marker(
              markerId: const MarkerId('markerId'),
              position: _selectedLocation ??
                  LatLng(
                    locationData?.latitude ?? 0.0,
                    locationData?.longitude ?? 0.0,
                  ))
        },
        mapType: MapType.normal,
      ),
    );
  }
}
