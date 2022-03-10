import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String currentScreen = 'MainScreen';

void clearUserData(context) async {
  final pr = await SharedPreferences.getInstance();
  pr.setBool('isLogin', false);
  Navigator.pop(context);
  Navigator.pushNamed(context, '/authscreen');
}

Widget drawerSettings(context) => Drawer(
  //backgroundColor: Colors.deepPurple[900],
  child: ListView(
    children: [
      DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.deepPurple[900]
        ),
        child: Container(
          alignment: Alignment.centerLeft,
          height: 200,
          child: const Text(
            'Итоговое приложение',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),
          ),
        )
      ),
      ListTile(
        title: const Text('Главная страница'),
        leading: Icon(
          Icons.domain,
          color: Colors.deepPurple[900],
        ),
        onTap: (){
          Navigator.pop(context);
          if (currentScreen=='Settings') {
            currentScreen='MainScreen';
            Navigator.pushNamed(context, '/mainscreen');
          }
        },
      ),
      ListTile(
        title: const Text('Настройки'),
        leading: Icon(
          Icons.settings,
          color: Colors.deepPurple[900],
        ),
        onTap: (){
          Navigator.pop(context);
          if (currentScreen=='MainScreen') {
            currentScreen='Settings';
            Navigator.pushNamed(context, '/settings');
          }
        },
      ),
      Divider(
        endIndent: 20,
        indent: 20,
        color: Colors.deepPurple[900],
      ),
      ListTile(
        title: const Text('LogOut'),
        leading: Icon(
          Icons.logout,
          color: Colors.deepPurple[900],
        ),
        onTap: (){
          clearUserData(context);
        },
      ),
    ],
  ),
);