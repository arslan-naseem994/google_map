import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineScreen extends StatefulWidget {
  const PolylineScreen({super.key});

  @override
  State<PolylineScreen> createState() => _PolylineScreenState();
}

class _PolylineScreenState extends State<PolylineScreen> {
  @override
  void initState() {
    for (int i = 0; i < _latlng.length; i++) {
      _marker.add(
        Marker(
            markerId: MarkerId(i.toString()),
            position: _latlng[i],
            infoWindow:
                const InfoWindow(title: 'Cool Place', snippet: '5 Star'),
            icon: BitmapDescriptor.defaultMarker),
      );
      setState(() {});
      _polyline.add(Polyline(
          polylineId: const PolylineId('1'),
          points: _latlng,
          color: Colors.pink,
          width: 3));
    }

    super.initState();
  }

  final Set<Polyline> _polyline = {};

  final List<LatLng> _latlng = [
    const LatLng(30.507739300482395, 72.67242549498631),
    // const LatLng(30.503829203516837, 72.67250059683258),
    const LatLng(30.504097276650043, 72.6790129997863),
    // const LatLng(30.507831735860595, 72.67924903416022),
    // const LatLng(30.507739300482395, 72.67242549498631),
  ];
  final List<Marker> _marker = [];
  

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
        title: const Text('Polyline'),
      ),
      body: SafeArea(
        child: GoogleMap(
          // for markers
          markers: Set<Marker>.of(_marker),
          //
          // polygons: _polygone,
          polylines: _polyline,
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
