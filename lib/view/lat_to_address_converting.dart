import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';

class LatToAddressConvertingScreen extends StatefulWidget {
  const LatToAddressConvertingScreen({super.key});

  @override
  State<LatToAddressConvertingScreen> createState() =>
      _LatToAddressConvertingScreenState();
}

enum Adds {
  city,
  street,
  countryCode,
  countryName,
}

class _LatToAddressConvertingScreenState
    extends State<LatToAddressConvertingScreen> {
  var mylocation;
  var lat;
  String ali = 'a';
  GeoCode geoCode = GeoCode();

  Map<Adds, String> myAddress = {};

  voidconvert() async {
    // for lanlat to address
    try {
      var address = await geoCode.reverseGeocoding(
        latitude: 30.505871069168307,
        longitude: 72.67419551272359,
      );
      myAddress = {
        Adds.city: address.city.toString(),
        Adds.street: address.streetAddress.toString(),
        Adds.countryCode: address.countryCode.toString(),
        Adds.countryName: address.countryName.toString(),
      };
      debugPrint(myAddress[Adds.city].toString());
      // for address to latlan
      //     try {
      //   Coordinates coordinates = await geoCode.forwardGeocoding(
      //       address: "532 S Olive St, Los Angeles, CA 90013");

      //   print("Latitude: ${coordinates.latitude}");
      //   print("Longitude: ${coordinates.longitude}");
      // } catch (e) {
      //   print(e);
      // }
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Converting_Screens')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  voidconvert();
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.green),
                  child: const Center(
                    child: Text('Convert'),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // Display the address details
          Text(myAddress[Adds.city].toString()),
        ],
      ),
    );
  }
}
