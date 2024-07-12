import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocationToDesired extends StatefulWidget {
  const CurrentLocationToDesired({super.key});

  @override
  State<CurrentLocationToDesired> createState() =>
      _CurrentLocationToDesiredState();
}

class _CurrentLocationToDesiredState extends State<CurrentLocationToDesired> {
  Future<Position> getusercurrentpositin() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      debugPrint('Error$error');
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    // _marker.addAll(_list);

    super.initState();

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
  }

  final List<LatLng> _latlng = [
    const LatLng(30.507873177813995, 72.67935139316035),
  ];
  final Set<Marker> _marker = {};
  final Set<Polyline> _polyline = {};

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
          InkWell(
              onTap: () async {
                getusercurrentpositin().then((value) async {
                  debugPrint(
                      value.latitude.toString() + value.longitude.toString());

                  _latlng.add(LatLng(value.latitude, value.longitude));

                  setState(() {});
                });
              },
              child: const Icon(
                Icons.location_disabled,
                color: Colors.black,
              )),
          const SizedBox(
            width: 10,
          )
        ],
        title: const Text('CurrentLocationToDesired'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              // for markers
              markers: _marker,
              //
              polylines: _polyline,
              // polygons: _polygone,
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
        ],
      ),
    );
  }
}
