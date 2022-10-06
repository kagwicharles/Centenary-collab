import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/repository/repository.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;
  final _atmLocationRepository = AtmLocationRepository();
  final LatLng _center = const LatLng(0.3476, 32.5825);

  _getLocations() => _atmLocationRepository.getAllAtmLocations();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Atms"),
        ),
        body: FutureBuilder<List<AtmLocation>>(
            future: _getLocations(),
            // a previously-obtained Future<String> or null
            builder: (BuildContext context,
                AsyncSnapshot<List<AtmLocation>> snapshot) {
              Widget child = const SizedBox();
              if (snapshot.hasData) {
                final Map<String, Marker> _markers = {};
                final atmLocations = snapshot.data;

                Future<void> _onMapCreated(
                    GoogleMapController controller) async {
                  setState(() {
                    _markers.clear();
                    atmLocations?.forEach((atmLocation) {
                      final marker = Marker(
                        markerId: MarkerId(atmLocation.location),
                        position:
                            LatLng(atmLocation.latitude, atmLocation.longitude),
                        infoWindow: InfoWindow(
                          title: atmLocation.location,
                        ),
                      );
                      _markers[atmLocation.location] = marker;
                    });
                  });
                }

                debugPrint(
                    "ATM Locations....$atmLocations Available markers...$_markers");
                child = GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 11.0,
                  ),
                );
              }
              return child;
            }));
  }
}
