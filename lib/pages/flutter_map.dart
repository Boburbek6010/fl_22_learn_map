import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomFlutterMap extends StatefulWidget {
  const CustomFlutterMap({super.key});

  @override
  State<CustomFlutterMap> createState() => _CustomFlutterMapState();
}

class _CustomFlutterMapState extends State<CustomFlutterMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(41.234152, 69.216101),
              initialZoom: 16
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              PolygonLayer(
                polygonCulling: false,
                polygons: [
                  Polygon(
                      points: [
                        LatLng(41.235212, 69.215068),
                        LatLng(41.235593, 69.217218),
                        LatLng(41.233517, 69.218483),
                        LatLng(41.232821, 69.215445),
                      ],
                      color: Colors.blue.withOpacity(0.5),
                      borderStrokeWidth: 2,
                      borderColor: Colors.blue,
                      isFilled: true
                  ),

                ],
              ),
              // CircleLayer(
              //   circles: [
              //     CircleMarker(
              //       point: LatLng(41.232821, 69.215445),
              //       radius: 1000,
              //       useRadiusInMeter: true,
              //       color: Colors.red.withOpacity(0.3),
              //       borderColor: Colors.red.withOpacity(0.7),
              //       borderStrokeWidth: 2,
              //     )
              //   ],
              // ),
              // MarkerLayer(
              //   markers: [
              //     Marker(
              //       point: LatLng(41.232821, 69.215445),
              //       width: 50,
              //       height: 50,
              //       child: FlutterLogo(),//Image.asset("assets/img.png"),
              //     ),
              //   ],
              // )
            ],
          )
        ],
      ),
    );
  }
}
