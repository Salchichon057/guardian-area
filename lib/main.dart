import 'package:flutter/material.dart';
import 'package:guardian_area/config/config.dart';

void main() async {

  await Environment.initEnvironment();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Guardian Area'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
