import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
  final _branchLocationRepository = BranchLocationRepository();
  final LatLng _center = const LatLng(0.3476, 32.5825);
  final Set<Marker> _markers = {};
  List<AtmLocation> _atmLocations = [];
  List<BranchLocation> _branchLocations = [];

  List<AppLocation> _appLocations = [];
  bool isAtms = true;

  Future<List<AppLocation>> _getLocations() async {
    if (isAtms) {
      _atmLocations = await _atmLocationRepository.getAllAtmLocations();
      _atmLocations.forEach((atmLocation) {
        _appLocations.add(AppLocation(
            longitude: atmLocation.longitude,
            latitude: atmLocation.latitude,
            distance: atmLocation.distance,
            location: atmLocation.location));
      });
    } else {
      _branchLocations =
          await _branchLocationRepository.getAllBranchLocations();
      _branchLocations.forEach((branchLocation) {
        _appLocations.add(AppLocation(
            longitude: branchLocation.longitude,
            latitude: branchLocation.latitude,
            distance: branchLocation.distance,
            location: branchLocation.location));
      });
    }
    print(_appLocations);
    return _appLocations;
  }

  void updateMarkers() {
    setState(() {
      _markers.clear();
      _appLocations.forEach((atmLocation) {
        _markers.add(Marker(
          markerId: MarkerId(atmLocation.location),
          position: LatLng(atmLocation.latitude, atmLocation.longitude),
          infoWindow: InfoWindow(
            title: atmLocation.location,
          ),
        ));
      });
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      updateMarkers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.only(top: Get.statusBarHeight),
            child: Column(
              children: [
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  if (!isAtms) {
                                    setState(() {
                                      isAtms = true;
                                      updateMarkers();
                                    });
                                  }
                                },
                                child: const Text("ATMs"))),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  if (isAtms) {
                                    setState(() {
                                      isAtms = false;
                                      updateMarkers();
                                    });
                                  }
                                },
                                child: const Text("Branches")))
                      ],
                    )),
                Expanded(
                    child: FutureBuilder<List<AppLocation>>(
                        future: _getLocations(),
                        // a previously-obtained Future<String> or null
                        builder: (BuildContext context,
                            AsyncSnapshot<List<AppLocation>> snapshot) {
                          Widget child = const SizedBox();
                          if (snapshot.hasData) {
                            _appLocations = snapshot.data!;

                            debugPrint(
                                "ATM Locations....$_atmLocations Available markers...$_markers");
                            child = GoogleMap(
                              onMapCreated: _onMapCreated,
                              initialCameraPosition: CameraPosition(
                                target: _center,
                                zoom: 7.0,
                              ),
                              markers: _markers,
                            );
                          }
                          return child;
                        }))
              ],
            )));
  }
}
