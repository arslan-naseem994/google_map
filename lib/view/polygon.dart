import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolygonScreen extends StatefulWidget {
  const PolygonScreen({super.key});

  @override
  State<PolygonScreen> createState() => _PolygonScreenState();
}

class _PolygonScreenState extends State<PolygonScreen> {
  @override
  void initState() {
    _marker.addAll(_list);

    _polygone.add(
      Polygon(
        polygonId: const PolygonId('1'),
        points: _points,
        fillColor: Colors.red.withOpacity(0.3),
        geodesic: true,
        strokeWidth: 2,
      ),
    );

    super.initState();
  }

  final Set<Polygon> _polygone = HashSet<Polygon>();
  final List<LatLng> _points = [
    const LatLng(30.507739300482395, 72.67242549498631),
    const LatLng(30.503829203516837, 72.67250059683258),
    const LatLng(30.504097276650043, 72.6790129997863),
    const LatLng(30.507831735860595, 72.67924903416022),
    const LatLng(30.507739300482395, 72.67242549498631),
  ];
  final List<Marker> _marker = [];
  final List<Marker> _list = [
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(30.503829203516837, 72.67250059683258),
        infoWindow: InfoWindow(title: 'bottom left')),
    const Marker(
        markerId: MarkerId('2'),
        position: LatLng(30.507739300482395, 72.67242549498631),
        infoWindow: InfoWindow(title: 'top left')),
    const Marker(
        markerId: MarkerId('3'),
        position: LatLng(30.507831735860595, 72.67924903416022),
        infoWindow: InfoWindow(title: 'top right')),
    const Marker(
        markerId: MarkerId('4'),
        position: LatLng(30.504097276650043, 72.6790129997863),
        infoWindow: InfoWindow(title: 'bottom right')),
  ];

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.505871069168307, 72.67419551272359),
    tilt: 59.440717697143555,
    zoom: 15,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polygon'),
      ),
      body: SafeArea(
        child: GoogleMap(
          // for markers
          markers: Set<Marker>.of(_marker),
          //
          polygons: _polygone,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          compassEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () async {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => const LatToAddress()));

          GoogleMapController controller = await _controller.future;
          controller.animateCamera(
              (CameraUpdate.newCameraPosition(const CameraPosition(
                  tilt: 50.440717697143555,
                  zoom: 15,
                  target: LatLng(
                    30.50767459566532,
                    72.67267225819549,
                  )))));

          setState(() {});
        },
        child: const Icon(Icons.location_disabled_outlined),
      ),
    );
  }
}
