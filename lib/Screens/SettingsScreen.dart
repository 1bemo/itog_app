import 'package:flutter/material.dart';
import 'package:itog_app/utils/DrawerSettings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerSettings(context),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[900],
        title: const Text('Настройки'),
      ),
      body: const Center(
        child: Text('Экран настроек')
      ),
    );
  }
}
