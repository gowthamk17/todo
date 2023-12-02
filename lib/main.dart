import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/home.dart';

void main() {
  runApp(const Todo());
}

class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
