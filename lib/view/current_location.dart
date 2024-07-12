import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({super.key});

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  @override
  void initState() {
    _marker.addAll(_list);
    super.initState();
  }

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

  Future<Position> getusercurrentpositin() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      debugPrint('Error$error');
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CurrentLocation'),
      ),
      body: SafeArea(
        child: GoogleMap(
          // for markers
          markers: Set<Marker>.of(_marker),
          //

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
          getusercurrentpositin().then((value) async {
            debugPrint(value.latitude.toString() + value.longitude.toString());

            _marker.add(
              Marker(
                  markerId: const MarkerId('3'),
                  position: LatLng(value.latitude, value.longitude),
                  infoWindow: const InfoWindow(title: 'My Current Location')),
            );

            CameraPosition kGooglePlex = CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 14.4746,
            );

            final GoogleMapController controller = await _controller.future;

            controller
                .animateCamera((CameraUpdate.newCameraPosition(kGooglePlex)));

            setState(() {});
          });
        },
        child: const Icon(Icons.location_disabled_outlined),
      ),
    );
  }
}
