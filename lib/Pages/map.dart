import 'dart:async';
import 'package:eventora/controllers/location_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';

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
  late GooglePlace googlePlace;
  late List<AutocompletePrediction> predictions = [];
  late Timer? _debounce = Timer(const Duration(milliseconds: 1000), () {});

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.43296265331129, -122.08832357078792),
    zoom: 14.4746,
  );

  void googlePlaceInit() async {
    await dotenv.load(fileName: ".env");
    final String? key = dotenv.env['GOOGLE_API'];
    googlePlace = GooglePlace(key!);
  }

  void autoCompleteSearch(String value) async {
    var results = await googlePlace.autocomplete.get(value);
    if (results != null && results.predictions != null && mounted) {
      setState(() {
        predictions = results.predictions!;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    setMarker(const LatLng(37.43296265331129, -122.08832357078792));
    googlePlaceInit();
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
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();

                      _debounce = Timer(const Duration(milliseconds: 2000), () {
                        autoCompleteSearch(value);
                      });
                    } else {
                      setState(() {
                        _searchController.text = '';
                        predictions.clear();
                      });
                    }
                  },
                  controller: _searchController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(hintText: 'Search'),
                ),
              )),
              IconButton(
                  onPressed: () {
                    _searchController.text = '';
                    predictions.clear();
                  },
                  icon: const Icon(FeatherIcons.x))
            ]),
            ListView.builder(
                shrinkWrap: true,
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                        leading: const Icon(FeatherIcons.mapPin),
                        onTap: () {
                          fetchLocationAndGo(predictions[index].placeId!);
                          setState(() {
                            _searchController.text =
                                predictions[index].description!.toString();
                            predictions.clear();
                          });
                        },
                        title: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(predictions[index].description!))),
                  );
                }),
            Expanded(
              child: GoogleMap(
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

  void setMarker(LatLng point) async {
    setState(() {
      _markers = {};
      _markers.add(Marker(markerId: MarkerId('marker$point'), position: point));
    });
  }

  void fetchLocationAndGo(String placeId) async {
    if (_searchController.text.isEmpty) {
      return;
    }

    locationDetails = await LocationController().getPlace(placeId);

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
}
