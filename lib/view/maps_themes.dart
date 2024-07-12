import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapThemeScreen extends StatefulWidget {
  const GoogleMapThemeScreen({super.key});

  @override
  State<GoogleMapThemeScreen> createState() => _GoogleMapThemeScreenState();
}

class _GoogleMapThemeScreenState extends State<GoogleMapThemeScreen> {
  String mapTheme = '';
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.505871069168307, 72.67419551272359),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_outlined,
              color: Colors.black,
            ),
            onSelected: (String select) {
              if (select == 'set') {
                _controller.future.then((value) {
                  DefaultAssetBundle.of(context)
                      .loadString('assets/maptheme/retro.json')
                      .then((string) {
                    value.setMapStyle(string);
                  });
                });
              }
              if (select == 'ter') {
                _controller.future.then((value) {
                  DefaultAssetBundle.of(context)
                      .loadString('assets/maptheme/style.json')
                      .then((string) {
                    value.setMapStyle(string);
                  });
                });
              }
            },
            itemBuilder: (BuildContext context) {
              return const [
                PopupMenuItem<String>(
                  value: 'set',
                  child: Text('Setlite'),
                ),
                PopupMenuItem<String>(
                  value: 'ter',
                  child: Text('Teren'),
                ),
              ];
            },
          ),
        ],
        title: const Text(
          'Map(theme)',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              // for markers
              // markers: Set<Marker>.of(_marker),
              //
              style: mapTheme,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              compassEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(mapTheme);
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
    );
  }
}
