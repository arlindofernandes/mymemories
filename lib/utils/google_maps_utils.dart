import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

class GoogleMapsUtils {
  static const String KEY = 'AIzaSyDtKJA15rObZsM5u72S4N0KmOZ4qUrvxRE';

  String getLocationFromLatitudeLongitude(LatLng location) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=${location.latitude},${location.longitude}&zoom=20&size=600x300&maptype=normal&markers=color:red%7Clabel:S%7C${location.latitude},${location.longitude}&key=${KEY}';
  }

  Future<String> getAddress(lat, lng) async {
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$KEY';

    var response = await http.get(url as Uri);

    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
