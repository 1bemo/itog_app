import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String globalUser = 'notAUser';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(globalUser),
      ),
      body: Center(
          child: Text('Ваш логин: $globalUser')
      ),
    );
  }
}
