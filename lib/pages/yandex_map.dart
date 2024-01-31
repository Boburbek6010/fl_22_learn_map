import 'dart:developer';

import 'package:fl_22_learn_map/services/yandex_controller.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class CustomYandexMap extends StatefulWidget {
  const CustomYandexMap({super.key});

  @override
  State<CustomYandexMap> createState() => _CustomYandexMapState();
}

class _CustomYandexMapState extends State<CustomYandexMap> {


  void mapInit(){
    YController.checkRequest().then((value) {
      YController.isLoading = true;
      setState((){});
    });
    log("onMapCreated");
  }

  void makeRoute({required double latitude, required double longitude, required Point end}){
    final drive = YandexDriving.requestRoutes(
      points: [
        RequestPoint(
            requestPointType: RequestPointType.wayPoint,
            point: Point(
              latitude: latitude,
              longitude: longitude,
            )
        ),

        RequestPoint(
            requestPointType: RequestPointType.wayPoint,
            point: end
        ),

      ],
      drivingOptions: const DrivingOptions(
        routesCount: 1,
        avoidPoorConditions: true,
        avoidTolls: true,
      ),
    );
    drive.result.then((value) {
      log(value.toString());
      if(value.routes != null){
        value.routes?.asMap().forEach((key, value) {
          YController.mapObjets.add(PolylineMapObject(
            strokeColor: Colors.red,
            strokeWidth: 3,
            mapId: MapObjectId("route_$key"),
            polyline: Polyline(
                points: value.geometry
            ),
          ),);
          setState((){});
        });
      }
    });
  }


  @override
  initState() {
    mapInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YController.isLoading
          ? YandexMap(
              onMapCreated: (controller){
                YController.onMapCreated(controller);
                setState(() {});
              },
              nightModeEnabled: true,
              mapObjects: YController.mapObjets,
              onMapTap: (Point point){
                YController.tappedLocation(point);
                setState(() {});
                makeRoute(latitude: YController.position!.latitude, longitude: YController.position!.longitude, end: point);
                YController.mapObjets.removeRange(1, YController.mapObjets.length-1);
                setState(() {});
              },
              mode2DEnabled: false,
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          MaterialButton(
            height: 60,
            shape: const CircleBorder(),
            color: Colors.white,
            onPressed: (){
              YController.findMyLocation();
              setState(() {});
            },
            child: const Icon(
              Icons.location_on_outlined,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20,),
          MaterialButton(
            height: 60,
            shape: const CircleBorder(),
            color: Colors.white,
            onPressed: ()async{
              await YController.goLive();
              setState(() {});
            },
            child: const Icon(
              Icons.navigation_outlined,
              color: Colors.black,
            ),
          ),
        ],
      )
    );
  }
}
