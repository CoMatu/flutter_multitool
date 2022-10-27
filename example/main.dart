import 'package:flutter/material.dart';
import 'package:flutter_multitool/flutter_multitool.dart';

void main() => runApp(MyApp());

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Some text').expanded(),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text('Save').paddingAll(12.0),
          ),
          const ColoredBox(color: Colors.red).gestureDetector(
            onTap: onPressed,
          ),
        ],
      ),
    );
  }

  void onPressed() {}
}
