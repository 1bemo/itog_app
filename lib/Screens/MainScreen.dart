import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:itog_app/utils/DrawerSettings.dart';
import 'package:shared_preferences/shared_preferences.dart';

String globalUser = 'notAUser';

Future<List<User>> fetchUsers() async {
  final resp = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
  List<User> listUser=[];
  if (resp.statusCode == 200) {
    final List usList = jsonDecode(resp.body);
    for (var element in usList) {listUser.add(User.fromJson(element));}
    return listUser;
  } else {
    throw Exception('Ошибка какая-то');
  }
}

Future<List<ToDo>> fetchToDo(int idUser) async {
  final resp = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos?userId=$idUser'));
  List<ToDo> listToDo=[];
  if(resp.statusCode==200) {
    final List todoList = jsonDecode(resp.body);
    for (var el in todoList) {listToDo.add(ToDo.fromJson(el));}
    return listToDo;
  } else {
    throw Exception('Эррорина');
  }
}

//--------------------Оставил для себя на будущее
// Future<List<List<ToDo>>> fetchTodo(int cnt) async {
//   List<List<ToDo>> allListTodo = [];
//   for (int i=0;i<cnt;i++) {
//     final resp = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos?userId=${i+1}'));
//     List<ToDo> listTodoFor1=[];
//     if (resp.statusCode==200) {
//       final List tdList = jsonDecode(resp.body);
//       for(var el in tdList) {listTodoFor1.add(ToDo.fromJson(el));}
//       //return listTodoFor1;
//       allListTodo.add(listTodoFor1);
//     } else {
//       throw Exception('что-то не так');
//     }
//   }
//   return allListTodo;
// }

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

//компания внутри адрес
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

//-----кликабельный для List<User>
class ClickableListesUsers extends StatefulWidget {
  const ClickableListesUsers({Key? key, required this.curList}) : super(key: key);
  //проброс пользователя
  final List<User> curList;

  @override
  _ClickableListesUsersState createState() => _ClickableListesUsersState();
}
class _ClickableListesUsersState extends State<ClickableListesUsers> {
  late Future<List<ToDo>> futureListToDo;

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
                  futureListToDo = fetchToDo(widget.curList[i].id);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(widget.curList[i].name,style: const TextStyle(fontWeight: FontWeight.bold),),
                        content: SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child: Column(
                              children: [
                                //основная инфа
                                Container(
                                  padding: const EdgeInsets.only(top: 5,bottom: 5),
                                  alignment: Alignment.centerLeft,
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
                                Column(
                                  children: [
                                    Container(margin: const EdgeInsets.only(bottom: 5),child: const Text('Список дел',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
                                    FutureBuilder<List<ToDo>>(
                                      future: futureListToDo,
                                      builder: (context, ss) {
                                        if(ss.hasData) {
                                          return ListToDoList(curToDo: ss.data!,);
                                        } else if (ss.hasError) {
                                          return Text('ERRORINA: ${ss.error}');
                                        }
                                        return const CircularProgressIndicator();
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Отмена'),
                            child: Text('Закрыть',style: TextStyle(color: Colors.deepPurple[900]),),
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

//список дел ЛистТайл
class ListToDoList extends StatefulWidget {
  const ListToDoList({Key? key, required this.curToDo}) : super(key: key);
  //проброс пользователя
  final List<ToDo> curToDo;

  @override
  _ListToDoListState createState() => _ListToDoListState();
}
class _ListToDoListState extends State<ListToDoList> {
  late Future<List<ToDo>> futureListToDo;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            width: 1,
            color: const Color(0xff311b92)
        )
      ),
      width: 180,
      height: 300,
      child: ListView.builder(
          itemCount: widget.curToDo.length,
          itemBuilder: (BuildContext context, int i) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(20)
              ),
              margin: const EdgeInsets.all(3),
              child: ListTile(
                leading: Checkbox(
                  value: widget.curToDo[i].completed,
                  checkColor: Colors.white,
                  activeColor: Colors.deepPurple[900],
                  onChanged: (_) {},
                ),
                title: Text(
                  widget.curToDo[i].title,
                  style: const TextStyle(fontSize: 10,fontStyle: FontStyle.italic),
                ),
                textColor: Colors.deepPurple[900],
                //onTap: (){},
              ),
            );
          }
      ),
    );
  }
}

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

  @override
  void initState() {
    super.initState();
      futureListUsers = fetchUsers();
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
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Ваш аккаунт (взято из данных):'),
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
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  height: 400,
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
              ],
            ),
          ),
        ),
      )
    );
  }
}
