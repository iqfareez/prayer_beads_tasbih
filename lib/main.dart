import 'package:animated_drawer/views/animated_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prayer_beads/menu.dart';
import 'home.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasbeeh',
      themeMode: ThemeMode.system,
      // debugShowCheckedModeBanner: false,
      home: AnimatedDrawer(
        homePageXValue: 60,
        shadowXValue: 10,
        homePageContent: Home(),
        backgroundGradient: LinearGradient(colors: [
          Color(0xFF134E5E),
          Color(0xFF71B280),
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        menuPageContent: Menu(),
        shadowColor: Colors.teal,
      ),
    );
  }
}
