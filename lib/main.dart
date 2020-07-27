import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basket App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Basket App'),
        ),
      ),
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        accentColor: Colors.deepOrangeAccent,
      ),
    );
  }
}
