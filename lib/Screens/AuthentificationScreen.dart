import 'package:flutter/material.dart';

class Authentification extends StatefulWidget {
  const Authentification({Key? key}) : super(key: key);

  @override
  State<Authentification> createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Это экран аутентивикации')
      ),
    );
  }
}
