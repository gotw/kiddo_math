import 'package:flutter/material.dart';
import 'package:kiddo_math/screens/MathFactsScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kiddo Math',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MathFactsScreen(key: Key('math_facts'), title: 'Math Facts'),
    );
  }
}
