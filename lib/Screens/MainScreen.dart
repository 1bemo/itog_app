import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:itog_app/utils/DrawerSettings.dart';
import 'package:shared_preferences/shared_preferences.dart';

String globalUser = 'notAUser';
int _countUsers = 10;

Future<List<User>> fetchUsers() async {
  final resp = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
  List<User> listUser=[];
  if (resp.statusCode == 200) {
    final List usList = jsonDecode(resp.body);
    for (var element in usList) {listUser.add(User.fromJson(element));}
    //_countUsers = listUser.length + 1;
    return listUser;
  } else {
    throw Exception('Ошибка какая-то');
  }
}

Future<List<List<ToDo>>> fetchTodo(int cnt) async {
  List<List<ToDo>> allListTodo = [];
  for (int i=0;i<cnt;i++) {
    final resp = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos?userId=${i+1}'));
    List<ToDo> listTodoFor1=[];
    if (resp.statusCode==200) {
      final List tdList = jsonDecode(resp.body);
      for(var el in tdList) {listTodoFor1.add(ToDo.fromJson(el));}
      //return listTodoFor1;
      allListTodo.add(listTodoFor1);
    } else {
      throw Exception('что-то не так');
    }
  }
  return allListTodo;
}

//класс задач
class ToDo {
  int userId = 0;
  int id = 0;
  String title = '';
  bool completed = false;

  ToDo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}

//User class
class User {
  int id = 0;
  String name = '';
  String username = '';
  String email = '';

  String phone = '';
  String website = '';
  Address address;
  Company company;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.address,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
      address: Address(
        street: json['address']['street'],
        suite: json['address']['suite'],
        city: json['address']['city'],
        zipcode: json['address']['zipcode'],
        geo: Geo(
          lat: json['address']['geo']['lat'],
          lng: json['address']['geo']['lng']
        ),
      ),
      company: Company(
        name: json['company']['name'],
        catchPhrase: json['company']['catchPhrase'],
        bs: json['company']['bs'],
      ),
    );
  }
}

//адрес внутри юзер
class Address {
  String street = '';
  String suite = '';
  String city = '';
  String zipcode = '';
  Geo geo;

  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo
  });
}

//гео внутри адрес внутри юзер
class Geo {
  String lat = '';
  String lng = '';

  Geo({
    required this.lat,
    required this.lng,
  });
}

class Company {
  String name = '';
  String catchPhrase = '';
  String bs = '';

  Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });
}

String toDoes(List lsTD) {
  String returned = '';
  for (var el in lsTD) {
    returned += '- ${el.title}.\n';
  }
  return returned;
}

double fSize = 24;

//--------------------------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Row todoRow(List lsTD) => Row(
  children: [
    //левая колонка
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('- ${lsTD[0].title}', style: TextStyle(fontSize: fSize),),
        Text('- ${lsTD[1].title}', style: TextStyle(fontSize: fSize),),
        Text('- ${lsTD[2].title}', style: TextStyle(fontSize: fSize),),
        Text('- ${lsTD[3].title}', style: TextStyle(fontSize: fSize),),
        Text('- ${lsTD[4].title}', style: TextStyle(fontSize: fSize),),
        Text('- ${lsTD[5].title}', style: TextStyle(fontSize: fSize),),
        Text('- ${lsTD[6].title}', style: TextStyle(fontSize: fSize),),
        Text('- ${lsTD[7].title}', style: TextStyle(fontSize: fSize),),
        Text('- ${lsTD[8].title}', style: TextStyle(fontSize: fSize),),
        Text('- ${lsTD[9].title}', style: TextStyle(fontSize: fSize),),
        Text('- ${lsTD[10].title}', style: TextStyle(fontSize: fSize),),
        Text('- ${lsTD[11].title}', style: TextStyle(fontSize: fSize),),
        Text('- ${lsTD[12].title}', style: TextStyle(fontSize: fSize),),
        Text('- ${lsTD[13].title}', style: TextStyle(fontSize: fSize),),
        Text('- ${lsTD[14].title}', style: TextStyle(fontSize: fSize),),
        Text('- ${lsTD[15].title}', style: TextStyle(fontSize: fSize),),
        Text('- ${lsTD[16].title}', style: TextStyle(fontSize: fSize),),
        Text('- ${lsTD[17].title}', style: TextStyle(fontSize: fSize),),
        Text('- ${lsTD[18].title}', style: TextStyle(fontSize: fSize),),
        Text('- ${lsTD[19].title}', style: TextStyle(fontSize: fSize),),
      ],
    ),
    Column(
      children: [

      ],
    )
    //правая колонка
  ],
);

//-----кликабельный для List<User>
class ClickableListesUsers extends StatefulWidget {
  const ClickableListesUsers({Key? key, required this.curList}) : super(key: key);
  //проброс пользователя
  final List<User> curList;

  @override
  _ClickableListesUsersState createState() => _ClickableListesUsersState();
}
class _ClickableListesUsersState extends State<ClickableListesUsers> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.curList.length,
        itemBuilder: (BuildContext context, int i) {
          return Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Colors.deepPurple[400]
            ),
            child: ListTile(
              title: Text(
                'ID: ${widget.curList[i].id}\n'
                'Name: ${widget.curList[i].name}\n'
                'E-mail: ${widget.curList[i].email}',
              ),
              selected: i == _selectedIndex,
              selectedColor: Colors.white,
              textColor: Colors.deepPurple[900],
              onTap: (){
                setState(() {
                  _selectedIndex = i;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(widget.curList[i].name,style: const TextStyle(fontWeight: FontWeight.bold),),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              //основная инфа
                              Container(
                                padding: const EdgeInsets.only(top: 5,bottom: 5),
                                alignment: Alignment.centerLeft,
                                //color: Colors.amber,
                                margin: const EdgeInsets.only(bottom: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(margin: const EdgeInsets.only(bottom: 5),child: const Text('Основное',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),)),
                                    //ID
                                    RichText(text: TextSpan(text: 'ID: ', style: TextStyle(color: Colors.deepPurple[900], fontWeight: FontWeight.bold), children: <TextSpan>[TextSpan(text: widget.curList[i].id.toString(), style: const TextStyle(fontWeight: FontWeight.normal))])),
                                    //username
                                    RichText(text: TextSpan(text: 'Имя Польз: ', style: TextStyle(color: Colors.deepPurple[900], fontWeight: FontWeight.bold), children: <TextSpan>[TextSpan(text: widget.curList[i].username, style: const TextStyle(fontWeight: FontWeight.normal))])),
                                    //email
                                    RichText(text: TextSpan(text: 'E-mail: ', style: TextStyle(color: Colors.deepPurple[900], fontWeight: FontWeight.bold), children: <TextSpan>[TextSpan(text: widget.curList[i].email, style: const TextStyle(fontWeight: FontWeight.normal))])),
                                    //phone
                                    RichText(text: TextSpan(text: 'Телефон: ', style: TextStyle(color: Colors.deepPurple[900], fontWeight: FontWeight.bold), children: <TextSpan>[TextSpan(text: widget.curList[i].phone, style: const TextStyle(fontWeight: FontWeight.normal))])),
                                    //website
                                    RichText(text: TextSpan(text: 'Веб-сайт: ', style: TextStyle(color: Colors.deepPurple[900], fontWeight: FontWeight.bold), children: <TextSpan>[TextSpan(text: widget.curList[i].website, style: const TextStyle(fontWeight: FontWeight.normal))])),
                                  ],
                                ),
                              ),
                              //адрес
                              Container(
                                padding: const EdgeInsets.only(top: 5,bottom: 5),
                                alignment: Alignment.centerLeft,
                                //color: Colors.amber,
                                margin: const EdgeInsets.only(bottom: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(margin: const EdgeInsets.only(bottom: 5),child: const Text('Адрес',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),)),
                                    //улица
                                    RichText(text: TextSpan(text: 'Улица: ', style: TextStyle(color: Colors.deepPurple[900], fontWeight: FontWeight.bold), children: <TextSpan>[TextSpan(text: widget.curList[i].address.street, style: const TextStyle(fontWeight: FontWeight.normal))])),
                                    //здание
                                    RichText(text: TextSpan(text: 'Здание: ', style: TextStyle(color: Colors.deepPurple[900], fontWeight: FontWeight.bold), children: <TextSpan>[TextSpan(text: widget.curList[i].address.suite, style: const TextStyle(fontWeight: FontWeight.normal))])),
                                    //город
                                    RichText(text: TextSpan(text: 'Город: ', style: TextStyle(color: Colors.deepPurple[900], fontWeight: FontWeight.bold), children: <TextSpan>[TextSpan(text: widget.curList[i].address.city, style: const TextStyle(fontWeight: FontWeight.normal))])),
                                    //зипкод
                                    RichText(text: TextSpan(text: 'Пост Код: ', style: TextStyle(color: Colors.deepPurple[900], fontWeight: FontWeight.bold), children: <TextSpan>[TextSpan(text: widget.curList[i].address.zipcode, style: const TextStyle(fontWeight: FontWeight.normal))])),
                                    //геолокация
                                    RichText(text: TextSpan(text: 'Гео: ', style: TextStyle(color: Colors.deepPurple[900], fontWeight: FontWeight.bold), children: <TextSpan>[TextSpan(text: 'lat: ${widget.curList[i].address.geo.lat}, lng: ${widget.curList[i].address.geo.lng}', style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 12))])),
                                  ],
                                ),
                              ),
                              //компания
                              Container(
                                padding: const EdgeInsets.only(top: 5,bottom: 5),
                                alignment: Alignment.centerLeft,
                                //color: Colors.amber,
                                margin: const EdgeInsets.only(bottom: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(margin: const EdgeInsets.only(bottom: 5),child: const Text('Компания',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),)),
                                    //имя компания
                                    RichText(text: TextSpan(text: 'Имя: ', style: TextStyle(color: Colors.deepPurple[900], fontWeight: FontWeight.bold), children: <TextSpan>[TextSpan(text: widget.curList[i].company.name, style: const TextStyle(fontWeight: FontWeight.normal))])),
                                    //фраза
                                    RichText(text: TextSpan(text: 'Фраза: ', style: TextStyle(color: Colors.deepPurple[900], fontWeight: FontWeight.bold), children: <TextSpan>[TextSpan(text: widget.curList[i].company.catchPhrase, style: const TextStyle(fontWeight: FontWeight.normal))])),
                                    //бс
                                    RichText(text: TextSpan(text: 'BS: ', style: TextStyle(color: Colors.deepPurple[900], fontWeight: FontWeight.bold), children: <TextSpan>[TextSpan(text: widget.curList[i].company.bs, style: const TextStyle(fontWeight: FontWeight.normal))])),
                                  ],
                                ),
                              ),
                              //Список дел
                              Container(
                                color: Colors.amber,
                                child: Column(
                                  children: [
                                    Container(margin: const EdgeInsets.only(bottom: 5),child: const Text('Список дел',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
                                    todoRow(testL[i]),
                                    // Text(
                                    //   toDoes(testL[i]),
                                    //   style: TextStyle(
                                    //     fontSize: 6
                                    //   ),
                                    // ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () => Navigator.pop(context, 'Отмена'),
                              child: const Text('Закрыть'),
                          )
                        ],
                      )
                  );
                });
              },
            ),
          );
        }
    );
  }
}

List<List<ToDo>> testL = [];

////////////////////////////////////////
//-----кликабельный для List<User>
class ClickableTest extends StatefulWidget {
  const ClickableTest({Key? key, required this.tst}) : super(key: key);
  //проброс пользователя
  final List<List<ToDo>> tst;

  void loadList() {
    testL = List<List<ToDo>>.from(tst);
  }

  @override
  _ClickableTestState createState() => _ClickableTestState();
}
class _ClickableTestState extends State<ClickableTest> {
  //final int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.loadList();
  }

  @override
  Widget build(BuildContext context) {
    return const Text('now load');
  }
}
////////////////////////////////////////////////////////////

void readUserPhone() async {
  final pr = await SharedPreferences.getInstance();
  globalUser = pr.getString('userPhone') ?? 'ЧТО-ТО ПОШЛО НЕ ТАК 2';
}

//главный экран
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  State<MainScreen> createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  late Future<List<User>> futureListUsers;
  late Future<List<List<ToDo>>> futureAllListTodo;

  @override
  void initState() {
    super.initState();
      futureListUsers = fetchUsers();
      futureAllListTodo = fetchTodo(_countUsers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerSettings(context),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[900],
        title: const Text('Главная страница'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              children: [
                Container(
                  color: Colors.deepPurple[100],
                  alignment: Alignment.center,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Ваш аккаунт:'),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Text(
                          globalUser,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple[900]
                          ),
                        ),
                      ),
                    ],
                  )
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  color: Colors.deepPurple[100],
                  alignment: Alignment.center,
                  height: 200,
                  child: FutureBuilder<List<User>>(
                    future: futureListUsers,
                    builder: (context, ss) {
                      if (ss.hasData) {
                        return ClickableListesUsers(curList: ss.data!,);
                      } else if (ss.hasError) {
                        return Text('Its error: ${ss.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  color: Colors.deepPurple[100],
                  alignment: Alignment.center,
                  height: 200,
                  child: FutureBuilder<List<List<ToDo>>>(
                    future: futureAllListTodo,
                    builder: (context, ss) {
                      if (ss.hasData) {
                        return ClickableTest(tst: ss.data!,);
                      } else if (ss.hasError) {
                        return Text('Its error: ${ss.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
