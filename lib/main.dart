import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'home.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasbih',
      themeMode: ThemeMode.system,
      // debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
