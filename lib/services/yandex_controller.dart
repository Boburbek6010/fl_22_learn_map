import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class YController{
  static Position? position;
  static bool isLoading = false;
  static YandexMapController? yandexMapController;
  static List<MapObject> mapObjets = [];
  static const String myLocationId = "myLocationId";

  static Future<Position> checkRequest() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    return position!;
  }

  static void onMapCreated(YandexMapController controller){
    yandexMapController = controller;
    if (position != null) {
      final boundingBox = BoundingBox(
        northEast: Point(
          latitude: position!.latitude,
          longitude: position!.longitude,
        ),
        southWest: Point(
          latitude: position!.latitude,
          longitude: position!.longitude,
        ),
      );
      controller.moveCamera(
        CameraUpdate.newTiltAzimuthGeometry(Geometry.fromBoundingBox(boundingBox)),
      );
      controller.moveCamera(CameraUpdate.zoomTo(16));
    }
  }

  static void findMyLocation(){
    if (position != null) {
      final boundingBox = BoundingBox(
        northEast: Point(
          latitude: position!.latitude,
          longitude: position!.longitude,
        ),
        southWest: Point(
          latitude: position!.latitude,
          longitude: position!.longitude,
        ),
      );
      yandexMapController!.moveCamera(
        CameraUpdate.newTiltAzimuthGeometry(
            Geometry.fromBoundingBox(boundingBox)),
      );
      yandexMapController!.moveCamera(
        CameraUpdate.zoomTo(19),
        animation: const MapAnimation(type: MapAnimationType.smooth, duration: 2),
      );
      putLabel(position!);
    }
  }

  static void putLabel(Position position){
    final PlacemarkMapObject placeMarkMapObject = PlacemarkMapObject(
      mapId: const MapObjectId(myLocationId),
      icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            scale: 0.3,
            image: BitmapDescriptor.fromAssetImage("assets/img.png"),
          )
      ),
      point: Point(
        latitude: position.latitude,
        longitude: position.longitude,
      ),
    );
    mapObjets.add(placeMarkMapObject);
  }


  static void tappedLocation(Point tappedPoint){
    final PlacemarkMapObject placeMarkMapObject = PlacemarkMapObject(
      mapId: MapObjectId(tappedPoint.latitude.hashCode.toString()),
      icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            scale: 0.3,
            image: BitmapDescriptor.fromAssetImage("assets/img.png"),
          )
      ),
      point: Point(
        latitude: tappedPoint.latitude,
        longitude: tappedPoint.longitude,
      ),
    );
    mapObjets.add(placeMarkMapObject);
    mapObjets.removeRange(1, mapObjets.length-1);
    // makeRoute(latitude: position!.latitude, longitude: position!.longitude, end: tappedPoint);
  }

  static Future<void> goLive()async{
    Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0,
          // timeLimit: Duration(milliseconds: 500)
        )
    ).listen((live) {
      putLabel(live);
      log(live.speed.toString());
      log("Lat: ${live.latitude}");
      log("Long: ${live.longitude}");
      BoundingBox box = BoundingBox(
        northEast: Point(
          latitude: live.latitude,
          longitude: live.longitude,
        ),
        southWest: Point(
          latitude: live.latitude,
          longitude: live.longitude,
        ),
      );
      yandexMapController!.moveCamera(CameraUpdate.newTiltAzimuthGeometry(Geometry.fromBoundingBox(box)));
      yandexMapController!.moveCamera(CameraUpdate.zoomTo(20));
    });
  }




}