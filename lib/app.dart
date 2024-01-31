import 'package:fl_22_learn_map/pages/flutter_map.dart';
import 'package:fl_22_learn_map/pages/yandex_map.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: CustomFlutterMap(),
      home: CustomYandexMap(),
    );
  }
}
