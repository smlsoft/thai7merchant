import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:thai7merchant/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetLocationFromMap extends StatefulWidget {
  final double latitude;
  final double longitude;

  const GetLocationFromMap({
    Key? key,
    this.latitude = 0,
    this.longitude = 0,
  }) : super(key: key);

  @override
  State<GetLocationFromMap> createState() => GetLocationFromMapState();
}

class GetLocationFromMapState extends State<GetLocationFromMap> {
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  List<Marker> markers = <Marker>[];
  late Marker marker;
  late Position position;

  static const CameraPosition googleMapPlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.4746,
  );

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  void changeMarker({latitude, longitude}) {
    markers.clear();
    marker = Marker(
        markerId: const MarkerId('1'),
        position: LatLng(latitude, longitude),
        draggable: true,
        infoWindow: InfoWindow(
          title: global.language('my_position'),
        ));
    setState(() {
      markers.add(marker);
    });
  }

  @override
  void initState() {
    Geolocator.requestPermission().then((_) => {
          if (widget.latitude != 0 || widget.longitude != 0)
            {
              changeMarker(
                  latitude: widget.latitude, longitude: widget.longitude),
              mapController.future.then((value) => {
                    value.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: LatLng(widget.latitude, widget.longitude),
                            zoom: 14.4746))),
                  })
            }
          else
            getUserCurrentLocation().then((positionValue) => {
                  position = positionValue,
                  changeMarker(
                      latitude: positionValue.latitude,
                      longitude: positionValue.longitude),
                  mapController.future.then((value) => {
                        value.animateCamera(CameraUpdate.newCameraPosition(
                            CameraPosition(
                                target: LatLng(positionValue.latitude,
                                    positionValue.longitude),
                                zoom: 14.4746))),
                      })
                })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: global.theme.appBarColor,
          automaticallyImplyLeading: false,
          title: Text(global.language('product_unit')),
          leading: IconButton(
              focusNode: FocusNode(skipTraversal: true),
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Navigator.pop(context, marker.position);
              },
            )
          ],
        ),
        body: GoogleMap(
          mapType: MapType.normal,
          markers: Set<Marker>.of(markers),
          initialCameraPosition: googleMapPlex,
          onMapCreated: (GoogleMapController controller) {
            mapController.complete(controller);
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onTap: (argument) {
            changeMarker(
                latitude: argument.latitude, longitude: argument.longitude);
          },
        ) /*floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),*/
        );
  }
}
