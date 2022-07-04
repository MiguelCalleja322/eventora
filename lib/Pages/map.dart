import 'dart:async';
import 'package:eventora/controllers/location_controller.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();
  late double? latitude = 0.0;
  late double? longitude = 0.0;
  late Map<String, dynamic>? locationDetails = {};
  late Set<Marker> _markers = <Marker>{};
  late Location location = Location();
  // late bool _serviceEnabled = false;
  // late PermissionStatus _permissionGranted = PermissionStatus.denied;
  // late LocationData _locationData = Locat;
  static const Marker _kGooglePlexMarker = Marker(
      markerId: MarkerId('_kGoogleMarker'),
      infoWindow: InfoWindow(title: 'Google Plex'),
      icon: BitmapDescriptor.defaultMarker,
      // ignore: unnecessary_const
      position: const LatLng(37.43296265331129, -122.08832357078792));

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.43296265331129, -122.08832357078792),
    zoom: 14.4746,
  );

  @override
  void initState() {
    setMarker(const LatLng(37.43296265331129, -122.08832357078792));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(children: <Widget>[
              Expanded(
                  child: TextField(
                controller: _searchController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(hintText: 'Search'),
              )),
              IconButton(
                onPressed: () {
                  fetchLocationAndGo();
                },
                icon: const Icon(FeatherIcons.search),
              )
            ]),
            Expanded(
              child: GoogleMap(
                // polylines: {_kPolyLine},
                mapType: MapType.normal,
                markers: _markers,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setMarker(LatLng point) {
    setState(() {
      _markers = {};
      _markers.add(Marker(markerId: MarkerId('marker$point'), position: point));
    });
  }

  void fetchLocationAndGo() async {
    if (_searchController.text.isEmpty) {
      return;
    }

    locationDetails =
        await LocationController().getPlace(_searchController.text);

    if (locationDetails!.isNotEmpty) {
      setState(() {
        latitude = locationDetails!['geometry']['location']['lat'];
        longitude = locationDetails!['geometry']['location']['lng'];
      });
    } else {
      return;
    }
    setMarker(LatLng(latitude!, longitude!));

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude!, longitude!), zoom: 12)));
  }

  // static const CameraPosition _kLake = CameraPosition(
  //   bearing: 192.8334901395799,
  //   target: LatLng(37.43296265331129, -122.08832357078792),
  //   tilt: 59.440717697143555,
  // );

  // static final Marker _kGoogleLakeMarker = Marker(
  //     markerId: const MarkerId('_kLakeMarker'),
  //     infoWindow: const InfoWindow(title: 'Lake'),
  //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
  //     position: const LatLng(37.43296265331129, -122.08832357078792));

  // static const Polyline _kPolyLine = Polyline(
  //     polylineId: PolylineId('_kPolyLine'),
  //     points: [
  //       LatLng(37.43296265331129, -122.08832357078792),
  //       LatLng(37.42796133580664, -122.085749655962)
  //     ],
  //     width: 5);
}
