import 'package:flutter/material.dart';
import 'package:itog_app/Screens/MainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AuthentificationScreen.dart';

class CheckAuthorization extends StatefulWidget {
  const CheckAuthorization({Key? key}) : super(key: key);

  @override
  State<CheckAuthorization> createState() => _CheckAuthorizationState();
}
class _CheckAuthorizationState extends State<CheckAuthorization> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const RootScreen(),
        '/authscreen': (context) => const Authentification(),
        '/mainscreen': (context) => const MainScreen(),
      },
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_univ.jpg'),
            fit: BoxFit.cover
          )
        ),
        child: Center(
          child: Container(
            width: 280,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: const Color(0xff4527a0),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.white
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Итоговое задание',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[800]
                  ),
                ),
                const Text('Цвык Дмитрий'),
                TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Вход',
                          style: TextStyle(
                            color: Colors.deepPurple[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.deepPurple[800],
                          )
                        )
                      ],
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
