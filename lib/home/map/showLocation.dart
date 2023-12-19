import 'package:daejeoni/common/buttonSingle.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/provider/gpsStatus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';

class ShowLocation extends StatefulWidget {
  final String title;
  final LatLng baseLocation;
  int? level;
  List<Marker>? baseMakers;

  ShowLocation({
    Key? key,
    required this.title,
    required this.baseLocation,
    this.level = 2,
    this.baseMakers,
  }) : super(key: key);

  @override
  State<ShowLocation> createState() => _ShowLocationState();
}

class _ShowLocationState extends State<ShowLocation> {
  late KakaoMapController _mapController;
  final List<Marker> _markerList = <Marker>[];
  late LatLng _locateHome;

  late GpsStatus _gpsProvider;
  bool _bSelect = false;

  @override
  void initState() {
    _gpsProvider = Provider.of<GpsStatus>(context, listen: false);
    if(widget.baseLocation != null) {
      _locateHome = widget.baseLocation;
    } else {
      _locateHome = LatLng(_gpsProvider.latitude(), _gpsProvider.longitude());
    }

    if (kDebugMode) {
      print("initState(): ....");
      print(_locateHome.toString());
    }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: Visibility(
          visible: true,
          child: IconButton(
              icon: Image.asset(
                "assets/icon/top_back.png",
                height: app_top_size_back,
                fit: BoxFit.fitHeight,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
      ),
      body: _renderBody(),
    );
  }

  Widget _renderBody() {
    return Stack(
      children: [
        Positioned(
          left: 0,top: 0, right: 0, bottom: 0,
            child: KakaoMap(
              zoomControl:false,
              currentLevel: widget.level!,
              center: _locateHome,
              onMapCreated: (controller) async {
                if (kDebugMode) {
                  print("onMapCreated(): ....");
                }
                _mapController = controller;
                _goMyLocate();
              },
              onMapTap:(LatLng latLng) {
                if (kDebugMode) {
                  print("onMapTap(): "
                      "latitude = ${latLng.latitude}, "
                      "longitude = ${latLng.longitude}");
                }

                _updateMarker(latLng);
                setState(() {

                });
              },
              //onMarkerTap: (String markerId, LatLng latLng, int zoomLevel) {},
            )
        ),

        Positioned(
          top: 20,
          left: 10,
          right: 10,
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  FloatingActionButton.small(
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.location_searching_outlined,
                        color: Colors.black,
                        size: 24,
                      ),
                      onPressed: () {
                        _goMyLocate();
                      }
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _updateMarker(LatLng? pos) {
    if(_markerList.isNotEmpty) {
      _markerList.clear();
    }

    _markerList.add(
        Marker(
            markerId: "base",
            markerImageSrc: URL_MakerSelect,//URL_MakerBase,
            latLng: _locateHome
        )
    );

    if(pos != null) {
      _bSelect = true;
      _markerList.add(
          Marker(
            markerId: "target",
            markerImageSrc: URL_MakerSelect,
            latLng: pos,
          )
      );
    }
    _mapController.addMarker(markers: _markerList);
  }

  Future <void> _goMyLocate() async {
    _mapController.setLevel(widget.level);
    _mapController.setCenter(_locateHome);
    _updateMarker(null);
    setState(() {
    });
  }
}
