import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MainScreen.dart';

OutlineInputBorder _textFieldBorder = const OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(30)),
  borderSide: BorderSide(
    color: Color(0xff4527a0),
    width: 2
  )
);

String _hintUser = 'Введите телефон и пароль';
String _userPhone = '';
String _userPass = '';

void saveLogin() async {
  final pr = await SharedPreferences.getInstance();
  pr.setString('userPhone', '89514549698');
  pr.setString('userPass', 'qwerty77');
}

class Authentification extends StatefulWidget {
  const Authentification({Key? key}) : super(key: key);

  @override
  State<Authentification> createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {
  //проверка на правильность введенных данных
  void checkLogin(String usPh, String usPas) async {
    final pr = await SharedPreferences.getInstance();
    String _phoneData = pr.getString('userPhone') ?? '';
    String _passData = pr.getString('userPass') ?? '';
    if (usPh==_phoneData) {
      if (usPas==_passData) {
        pr.setBool('isLogin', true);
        _hintUser = 'Введите телефон и пароль';
        readUserPhone();
        Navigator.pushNamed(context, '/mainscreen');
      } else {
        setState(() {
          _hintUser = 'Неверный пароль';
        });
      }
    } else {
      setState(() {
        _hintUser = 'Неверный телефон';
      });
    }
  }

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'Авторизация',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.deepPurple[900]
                  ),
                )
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  onChanged: (val) {
                    _userPhone = val;
                  },
                  decoration: InputDecoration(
                    hintText: 'Телефон',
                    filled: true,
                    fillColor: Colors.deepPurple[100],
                    focusedBorder: _textFieldBorder,
                    enabledBorder: _textFieldBorder,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                width: 200,
                child: TextField(
                  onChanged: (val) {
                    _userPass = val;
                  },
                  decoration: InputDecoration(
                    hintText: 'Пароль',
                    filled: true,
                    fillColor: Colors.deepPurple[100],
                    focusedBorder: _textFieldBorder,
                    enabledBorder: _textFieldBorder,
                  ),
                ),
              ),
              Text(_hintUser),
              Container(
                width: 150,
                margin: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    )
                  ),
                  onPressed: (){
                    //проверка на длину телефона
                    if (_userPhone.length < 11) {
                      setState(() {
                        _hintUser = 'Телефон не менее 11 символов';
                      });
                    } else {
                      if (_userPass.isEmpty) {
                        setState(() {
                          _hintUser = 'Пароль не может быть пустым';
                        });
                      } else {
                        checkLogin(_userPhone, _userPass);
                      }
                    }
                  },
                  child: const Text('Вход')
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                  'Пометка для Айрата Галямова\n'
                  'Телефон: 89514549698\n'
                  'Пароль: qwerty77',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.red[900]
                  ),
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}
