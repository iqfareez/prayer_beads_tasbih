import 'package:flutter/material.dart';

import 'features/tasbih/views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasbeeh',
      themeMode: ThemeMode.system,
      home: Home(),
    );
  }
}
