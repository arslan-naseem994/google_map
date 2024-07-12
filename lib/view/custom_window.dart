import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomInfo extends StatefulWidget {
  const CustomInfo({super.key});

  @override
  State<CustomInfo> createState() => _CustomInfoState();
}

class _CustomInfoState extends State<CustomInfo> {
  String _type = 's';
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  final List<Marker> _marker = <Marker>[];
  final List<LatLng> _latLang = <LatLng>[
    const LatLng(30.505871069168307, 72.67419551272359),
    const LatLng(30.506499775979783, 72.67381713243947),
  ];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.505871069168307, 72.67419551272359),
    zoom: 15,
  );

  loadData() {
    for (int i = 0; i < _latLang.length; i++) {
      _marker.add(Marker(
        markerId: MarkerId(i.toString()),
        icon: BitmapDescriptor.defaultMarker,
        position: _latLang[i],
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
              Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      width: double.infinity,
                      height: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 30,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              "I am here",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Triangle.isosceles(
                  //   edge: Edge.BOTTOM,
                  //   child: Container(
                  //     color: Colors.blue,
                  //     width: 20.0,
                  //     height: 10.0,
                  //   ),
                  // ),
                ],
              ),
              _latLang[i]);
        },
      ));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_outlined,
              color: Colors.black,
            ),
            onSelected: (String value) {
              _type = value;
              setState(() {});
            },
            itemBuilder: (BuildContext context) {
              return const [
                PopupMenuItem<String>(
                  value: 's',
                  child: Text('Setlite'),
                ),
                PopupMenuItem<String>(
                  value: 'n',
                  child: Text('normal'),
                ),
              ];
            },
          ),
        ],
        title: const Text('custom Info windows'),
      ),
      body: Stack(
        children: <Widget>[
          _type == 's'
              ? GoogleMap(
                  mapType: MapType.satellite,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  onTap: (position) {
                    _customInfoWindowController.hideInfoWindow!();
                  },
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove!();
                  },
                  onMapCreated: (GoogleMapController controller) async {
                    _customInfoWindowController.googleMapController =
                        controller;
                  },
                  markers: Set<Marker>.of(_marker),
                  initialCameraPosition: _kGooglePlex,
                )
              : _type == 'n'
                  ? GoogleMap(
                      mapType: MapType.normal,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      onTap: (position) {
                        _customInfoWindowController.hideInfoWindow!();
                      },
                      onCameraMove: (position) {
                        _customInfoWindowController.onCameraMove!();
                      },
                      onMapCreated: (GoogleMapController controller) async {
                        _customInfoWindowController.googleMapController =
                            controller;
                      },
                      markers: Set<Marker>.of(_marker),
                      initialCameraPosition: _kGooglePlex,
                    )
                  : GoogleMap(
                      mapType: MapType.terrain,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      onTap: (position) {
                        _customInfoWindowController.hideInfoWindow!();
                      },
                      onCameraMove: (position) {
                        _customInfoWindowController.onCameraMove!();
                      },
                      onMapCreated: (GoogleMapController controller) async {
                        _customInfoWindowController.googleMapController =
                            controller;
                      },
                      markers: Set<Marker>.of(_marker),
                      initialCameraPosition: _kGooglePlex,
                    ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 50,
            width: 300,
            offset: 35,
          ),
        ],
      ),
    );
  }
}
