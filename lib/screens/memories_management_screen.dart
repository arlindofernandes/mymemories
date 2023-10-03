import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';

import '../providers/memorie_provider.dart';

import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

import '../models/memorie.dart';

import './map_screen.dart';

import '../utils/google_maps_utils.dart';

class MemoriesManagementScreen extends StatefulWidget {
  static const String route = 'memories-management';

  const MemoriesManagementScreen({super.key});

  @override
  State<MemoriesManagementScreen> createState() =>
      MemoriesManagementScreenState();
}

class MemoriesManagementScreenState extends State<MemoriesManagementScreen> {
  Memorie _memorie = Memorie();
  final TextEditingController _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();
  String? _mapPreview;
  bool _isInit = true;

  Future<void> _captureImage() async {
    final imageFile = await _imagePicker.pickImage(source: ImageSource.camera);

    _memorie.image = imageFile?.path;

    setState(() {
      _memorie = _memorie;
    });
  }

  Future<void> _getLocation() async {
    Location location = Location();
    
    LocationData locationData = await location.getLocation();

    LatLng position = await Navigator.of(context)
        .pushNamed(MapScreen.route, arguments: locationData) as LatLng;

    setState(() {
      _memorie.latitude = position.latitude;
      _memorie.longitude = position.longitude;
      _mapPreview =
          GoogleMapsUtils().getLocationFromLatitudeLongitude(position);
    });
  }

  Future<void> _save() async {
    try {
      _memorie.formatedAddress = await GoogleMapsUtils()
          .getAddress(_memorie.latitude, _memorie.longitude);
      _memorie.description = _descriptionController.text;

      Provider.of<MemorieProvider>(context, listen: false).save(_memorie);

      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Object? id = ModalRoute.of(context)?.settings.arguments;
      if (id != null) {
        _memorie =
            Provider.of<MemorieProvider>(context, listen: false).getById(id as int);
        _mapPreview = GoogleMapsUtils().getLocationFromLatitudeLongitude(
            LatLng(_memorie.latitude ?? 0.0, _memorie.longitude ?? 0.0));
        _descriptionController.text = _memorie.description as String;
      }
    }

    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Memórias'),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.save), onPressed: _save),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: mediaQuery.size.height / 3,
              color: Colors.black12,
              child: Center(
                child: _memorie.image != null
                    ? GestureDetector(
                        onTap: _captureImage,
                        child: Hero(
                          tag: _memorie.id != null ? _memorie.id! : 'tag',
                          child: Image.file(
                            File(_memorie.image ?? ''),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.add_a_photo),
                        onPressed: _captureImage,
                        iconSize: 70,
                      ),
              ),
            ),
            const Divider(),
            Container(
              height: mediaQuery.size.height / 3,
              color: Colors.black12,
              child: _mapPreview == null
                  ? Center(
                      child: IconButton(
                        icon: const Icon(Icons.add_location),
                        onPressed: _getLocation,
                        iconSize: 70,
                      ),
                    )
                  : GestureDetector(
                      onTap: _getLocation,
                      child: Image.network(
                        _mapPreview as String,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
            ),
            const Divider(),
            TextFormField(
              controller: _descriptionController,
              minLines: 4,
              maxLines: 4,
              decoration:
                  const InputDecoration(labelText: 'Descreve aqui a sua memória'),
            ),
          ],
        ),
      ),
    );
  }
}
