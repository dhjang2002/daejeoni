
import 'package:daejeoni/home/map/showLocation.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:transition/transition.dart';

class CardKakaoMap extends StatefulWidget {
  final double lat;
  final double lon;
  final String title;
  final String tag;
  int? level;
  bool? guestureLock;
  CardKakaoMap({
    Key? key,
    required this.tag,
    required this.title,
    required this.lat,
    required this.lon,
    this.level = 2,
    this.guestureLock = false,
  }) : super(key: key);

  @override
  State<CardKakaoMap> createState() => _CardKakaoMapState();
}

class _CardKakaoMapState extends State<CardKakaoMap> {
  late KakaoMapController _mapController;
  final List<Marker> _markerList = <Marker>[];
  late LatLng _locateHome;
  bool _bReady = false;

  @override
  void initState() {
    setState((){
      _locateHome = LatLng(widget.lon, widget.lat);
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if(!_bReady) {
    //   return Container();
    // }

    return Stack(
      children: [
        Positioned(
            child: KakaoMap(
              currentLevel: widget.level!,
              center: _locateHome,
              onMapCreated: (controller) async {
                _mapController = controller;
                Future.microtask(() async {
                  await _goMyLocate();
                  setState(() {
                    _bReady = true;
                  });
                });
              },
              markers: _markerList.toList(),
            )
        ),
        Positioned(
            child: Visibility(
              visible: widget.guestureLock!,
              child: Container(
                color: Colors.transparent,
              ),
            )
        ),

        Positioned(
          bottom: 10,
          left: 5,
          right: 5,
          child: Visibility(
            visible: widget.guestureLock!,
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    FloatingActionButton.small(
                      heroTag: "${widget.tag}_zoom",
                        backgroundColor: Colors.white,
                        child: const Icon(
                          Icons.zoom_in_outlined,
                          color: Colors.black,
                          size: 24,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              Transition(
                                  child: ShowLocation(
                                    title: widget.title,
                                    baseLocation:_locateHome,
                                  ),
                                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                        }
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }

  Future <void> _goMyLocate() async {
    _mapController.setLevel(3);
    _mapController.setCenter(_locateHome);
      if(_markerList.isNotEmpty) {
        _markerList.clear();
      }

      _markerList.add(
          Marker(
            markerId: UniqueKey().toString(),
            latLng: await _mapController.getCenter(),
          )
      );
      setState(() { });
  }
}
