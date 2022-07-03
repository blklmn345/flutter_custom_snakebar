import 'package:custom_snake_bar/custom_snake_container.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('test')),
        body: CustomSnakeBarContainer(
          builder: (context) {
            return Center(
              child: TextButton(
                child: const Text('show snake bar'),
                onPressed: () {
                  CustomSnakeBarContainer.of(context).showSnakeBar(
                      type: SnakeType.success, message: 'success');
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
