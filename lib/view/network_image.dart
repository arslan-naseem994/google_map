import 'dart:async';

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NetworkImageScreen extends StatefulWidget {
  const NetworkImageScreen({super.key});

  @override
  State<NetworkImageScreen> createState() => _NetworkImageScreenState();
}

class _NetworkImageScreenState extends State<NetworkImageScreen> {
  @override
  void initState() {
    _loadMarkerImages();
    super.initState();
  }

  final Set<Marker> _marker = {};
  final List<LatLng> _latlng = [
    const LatLng(30.503829203516837, 72.67250059683258),
    const LatLng(30.507739300482395, 72.67242549498631),
    const LatLng(30.502641649560964, 72.67761322555367)
  ];

  Future<void> _loadMarkerImages() async {
    Uint8List? image = await loadNetworkImage(
      'https://cdn-icons-png.flaticon.com/512/8503/8503966.png',
    );

    final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
      image.buffer.asUint8List(),
      targetHeight: 100,
      targetWidth: 100,
    );
    final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
    final ByteData? byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);

    final Uint8List resizedImageMarker = byteData!.buffer.asUint8List();

    for (int i = 0; i < _latlng.length; i++) {
      _marker.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: _latlng[i],
          infoWindow: const InfoWindow(title: 'Cool Place', snippet: '5 Star'),
          icon: BitmapDescriptor.fromBytes(resizedImageMarker),
        ),
      );
    }
    setState(() {});
  }

  Future<Uint8List> loadNetworkImage(String path) async {
    final completer = Completer<ImageInfo>();

    var image = NetworkImage(path);

    image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((info, _) => completer.complete(info)));

    final imageInfo = await completer.future;

    final byteData =
        await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

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
        centerTitle: true,
        title: const Text(
          'NetworkImage',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              markers: _marker,
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
