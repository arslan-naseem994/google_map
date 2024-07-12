import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWithSearchOption extends StatefulWidget {
  const MapWithSearchOption({super.key});

  @override
  State<MapWithSearchOption> createState() => _MapWithSearchOptionState();
}

enum Adds {
  city,
  street,
  countryCode,
  countryName,
}

class _MapWithSearchOptionState extends State<MapWithSearchOption> {
  @override
  void initState() {
    // voidconvert();
    super.initState();
  }

  bool isSearch = false;
  // final List<dynamic> _placeList = [35.838154440356256, 137.96468421690844];
  final List<dynamic> _placeList = [];
  final List<dynamic> completeAddress = [];
  final TextEditingController _scontroller = TextEditingController();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.505871069168307, 72.67419551272359),
    zoom: 14.4746,
  );

  final List<LatLng> _latlng = [
    const LatLng(30.503829203516837, 72.67250059683258),
    const LatLng(30.503829203516837, 72.67250059683258),
  ];
  GeoCode geoCode = GeoCode();

  voidconvert() async {
    for (LatLng latLng in _latlng) {
      try {
        var address = await geoCode.reverseGeocoding(
          latitude: latLng.latitude,
          longitude: latLng.longitude,
        );
        completeAddress.add(address);

        // Create a map to hold address information
        Map<Adds, String> addressMap = {
          Adds.city: address.city.toString(),
          Adds.street: address.streetAddress.toString(),
          Adds.countryCode: address.countryCode.toString(),
          Adds.countryName: address.countryName.toString(),
        };

        // Add the address map to the myAddress list
        _placeList.add(addressMap);

        setState(() {
          // Update your UI with the new address data
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                isSearch = !isSearch;
              });
            },
            child: const Icon(Icons.search),
          ),
        ],
        title: !isSearch
            ? const Text('Google Map')
            : TextFormField(
                controller: _scontroller,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: const InputDecoration(hintText: 'Search Location'),
              ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (isSearch) {
                setState(() {
                  isSearch = !isSearch;
                });
              }
            },
            child: GoogleMap(
              // for markers

              //
              // myLocationButtonEnabled: true,
              // myLocationEnabled: true,
              compassEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                if (!_controller.isCompleted) {
                  _controller.complete(controller);
                }
              },
            ),
          ),
          if (isSearch)
            Container(
              height: 100,
              width: double.infinity,
              color: Colors.transparent,
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _placeList.length,
                itemBuilder: (context, index) {
                  String countryname =
                      _placeList[index][Adds.countryName].toString();

                  if (_scontroller.text.isEmpty) {
                    return Text(countryname.toString());
                  } else if (countryname
                      .toLowerCase()
                      .contains(_scontroller.text.toString())) {
                    return InkWell(
                      onTap: () async {
                        // final GoogleMapController controller =
                        //     await _controller.future;

                        try {
                          // Coordinates coordinates =
                          //     await geoCode.forwardGeocoding(
                          //         address:
                          //             "532 S Olive St, Los Angeles, CA 90013");
                          // print("Latitude: ${coordinates.latitude}");
                          // print("Longitude: ${coordinates.longitude}");

                          // controller.animateCamera(
                          //   CameraUpdate.newCameraPosition(
                          //     const CameraPosition(
                          //       target: LatLng(
                          //           30.505871069168307, 72.67419551272359),
                          //       zoom: 14.0,
                          //     ),
                          //   ),
                          // );
                        } catch (e) {
                          print(e);
                        }

                        isSearch = !isSearch;
                        _scontroller.clear();
                        setState(() {});
                      },
                      child: ListTile(
                        title: Text(_placeList[index][Adds.city].toString()),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () async {
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              const CameraPosition(
                target: LatLng(35.838154440356256, 137.96468421690844),
              ),
            ),
          );
          setState(() {});
        },
        child: const Icon(Icons.location_disabled_outlined),
      ),
    );
  }
}
