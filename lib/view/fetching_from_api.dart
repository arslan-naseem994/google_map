import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FetchingFromApiScreen extends StatefulWidget {
  const FetchingFromApiScreen({super.key});

  @override
  State<FetchingFromApiScreen> createState() => _FetchingFromApiScreenState();
}

class _FetchingFromApiScreenState extends State<FetchingFromApiScreen> {
  @override
  void initState() {
    _fetchMarkersFromAPI();
    super.initState();
  }

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(30.503829203516837, 72.67250059683258);

  final Set<Marker> _markers = {};

  void _fetchMarkersFromAPI() async {
    // Replace 'YOUR_API_ENDPOINT' with the actual API endpoint to fetch data
    final response = await http.get(Uri.parse('YOUR_API_ENDPOINT'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<dynamic> markersData = jsonData[
          'markers']; // Assuming 'markers' is the key containing marker data
      for (var markerData in markersData) {
        double lat = markerData['lat'];
        double lng = markerData['lng'];
        String imageUrl = markerData['image_url'];

        Uint8List markerIcon = await _getBytesFromUrl(imageUrl);

        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId('$lat-$lng'),
              position: LatLng(lat, lng),
              icon: BitmapDescriptor.fromBytes(markerIcon),
            ),
          );
        });
      }
    } else {
      throw Exception('Failed to load markers from API');
    }
  }

  Future<Uint8List> _getBytesFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image from $url');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetching data from api'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: _markers,
      ),
    );
  }
}
