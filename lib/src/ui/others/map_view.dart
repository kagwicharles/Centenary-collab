import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
  bool _isAtms = true;

  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var extend = false;
  var mini = false;
  var rmicons = false;
  var customDialRoot = false;
  var closeManually = false;
  var useRAnimation = true;
  var isDialOpen = ValueNotifier<bool>(false);
  var speedDialDirection = SpeedDialDirection.up;
  var buttonSize = const Size(64.0, 64.0);
  var childrenButtonSize = const Size(64.0, 64.0);
  var selectedfABLocation = FloatingActionButtonLocation.centerFloat;

  Future<List<AppLocation>> _getLocations() async {
    _appLocations.clear();
    if (_isAtms) {
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
    return _appLocations;
  }

  void updateMarkers(bool isATMs) {
    setState(() {
      _isAtms = isATMs;
      debugPrint("Updating markers...ATMs status...$_isAtms");
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
    updateMarkers(_isAtms);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          child: Column(
            children: [
              // Container(
              //     padding: const EdgeInsets.only(
              //         left: 15, right: 15, top: 15, bottom: 4),
              //     child: Row(
              //       mainAxisSize: MainAxisSize.max,
              //       children: [
              //         Expanded(
              //             child: ElevatedButton(
              //                 onPressed: () {}, child: const Text("ATMs"))),
              //         const SizedBox(
              //           width: 12,
              //         ),
              //         Expanded(
              //             child: ElevatedButton(
              //                 onPressed: () {},
              //                 child: const Text("Branches")))
              //       ],
              //     )),
              Expanded(
                  child: FutureBuilder<List<AppLocation>>(
                      future: _getLocations(),
                      // a previously-obtained Future<String> or null
                      builder: (BuildContext context,
                          AsyncSnapshot<List<AppLocation>> snapshot) {
                        debugPrint("Location future ran...");
                        Widget child = const SizedBox();
                        if (snapshot.hasData) {
                          _appLocations = snapshot.data!;

                          debugPrint(
                              "ATM Locations....$_appLocations Available markers...$_markers");
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
          )),
      floatingActionButtonLocation: selectedfABLocation,
      floatingActionButton: SpeedDial(
        // animatedIcon: AnimatedIcons.menu_close,
        // animatedIconTheme: IconThemeData(size: 22.0),
        // / This is ignored if animatedIcon is non null
        // child: Text("open"),
        // activeChild: Text("close"),
        icon: Icons.category,
        activeIcon: Icons.close,
        spacing: 3,
        mini: mini,
        openCloseDial: isDialOpen,
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        dialRoot: customDialRoot
            ? (ctx, open, toggleChildren) {
                return ElevatedButton(
                  onPressed: toggleChildren,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 18),
                  ),
                  child: const Text(
                    "Custom Dial Root",
                    style: TextStyle(fontSize: 17),
                  ),
                );
              }
            : null,
        buttonSize: buttonSize,
        // it's the SpeedDial size which defaults to 56 itself
        // iconTheme: IconThemeData(size: 22),
        label: extend ? const Text("Open") : null,
        // The label of the main button.
        /// The active label of the main button, Defaults to label if not specified.
        activeLabel: extend ? const Text("Close") : null,

        /// Transition Builder between label and activeLabel, defaults to FadeTransition.
        // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
        /// The below button size defaults to 56 itself, its the SpeedDial childrens size
        childrenButtonSize: childrenButtonSize,
        visible: visible,
        direction: speedDialDirection,
        switchLabelPosition: switchLabelPosition,

        /// If true user is forced to close dial manually
        closeManually: closeManually,

        /// If false, backgroundOverlay will not be rendered.
        renderOverlay: renderOverlay,
        // overlayColor: Colors.black,
        // overlayOpacity: 0.5,
        onOpen: () => debugPrint('OPENING DIAL'),
        onClose: () => debugPrint('DIAL CLOSED'),
        useRotationAnimation: useRAnimation,
        tooltip: 'Open Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        // foregroundColor: Colors.black,
        // backgroundColor: Colors.white,
        // activeForegroundColor: Colors.red,
        // activeBackgroundColor: Colors.blue,
        elevation: 8.0,
        animationCurve: Curves.elasticInOut,
        isOpenOnStart: false,
        shape: customDialRoot
            ? const RoundedRectangleBorder()
            : const StadiumBorder(),
        // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        children: [
          SpeedDialChild(
            child: !rmicons ? const Icon(Icons.account_balance) : null,
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            label: 'Branches',
            onTap: () => {
              if (_isAtms) {updateMarkers(false)}
            },
          ),
          SpeedDialChild(
            child: !rmicons ? const Icon(Icons.local_atm) : null,
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            label: 'ATMs',
            visible: true,
            onTap: () => {
              if (_isAtms == false) {updateMarkers(true)}
            },
          ),
        ],
      ),
    );
  }
}
