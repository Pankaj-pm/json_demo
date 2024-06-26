import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:json_demo/movies_list.dart';
import 'package:json_demo/network_user.dart';
import 'package:json_demo/new_user_model.dart';
import 'package:json_demo/pixa_api.dart';
import 'package:json_demo/pixabay_api.dart';

import 'package:json_demo/todo_api_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List sList = [];
  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();

  @override
  void initState() {
    super.initState();
    String cl = prefs.getString("cl") ?? "";
    Map<String, dynamic> jsonData = jsonDecode(cl);
    sList = jsonData["contact_list"] ?? [];
    // setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NetworkUser(),
                    ));
              },
              icon: Icon(Icons.person)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MoviesList(),
                    ));
              },
              icon: Icon(Icons.movie)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PixabayApi(),
                    ));
              },
              icon: Icon(Icons.photo)),
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text("TODO Api"),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ToDoApiTest();
                      },
                    ));
                  },
                ),
                PopupMenuItem(
                  child: Text("Pixa Api"),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return PixaApi();
                      },
                    ));
                  },
                ),
              ];
            },
          )
        ],
      ),
      body: Column(
        children: [
          TextFormField(
            controller: name,
            decoration: InputDecoration(hintText: "Name"),
          ),
          TextFormField(
            controller: mobile,
            decoration: InputDecoration(hintText: "Mobile Number"),
          ),
          ElevatedButton(
            onPressed: () async {
              Map<String, dynamic> map = {
                "name": name.text,
                "mobile_number": mobile.text,
              };
              sList.add(map);
              setState(() {});

              Map<String, dynamic> contactList = {"contact_list": sList};

              String encodeString = jsonEncode(contactList);
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("cl", encodeString);
              name.clear();
              mobile.clear();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Conctact Added")));
            },
            child: Text("Ok"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> item = sList[index];

                return ListTile(
                  title: Text(item["name"] ?? ""),
                  subtitle: Text("${item["mobile_number"]}"),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // String data =
          //     '{"page":1,"per_page":6,"total":12,"total_pages":2,"data":[{"id":1,"email":"george.bluth@reqres.in","first_name":"George","last_name":"Bluth","avatar":"https://reqres.in/img/faces/1-image.jpg"},{"id":2,"email":"janet.weaver@reqres.in","first_name":"Janet","last_name":"Weaver","avatar":"https://reqres.in/img/faces/2-image.jpg"},{"id":3,"email":"emma.wong@reqres.in","first_name":"Emma","last_name":"Wong","avatar":"https://reqres.in/img/faces/3-image.jpg"},{"id":4,"email":"eve.holt@reqres.in","first_name":"Eve","last_name":"Holt","avatar":"https://reqres.in/img/faces/4-image.jpg"},{"id":5,"email":"charles.morris@reqres.in","first_name":"Charles","last_name":"Morris","avatar":"https://reqres.in/img/faces/5-image.jpg"},{"id":6,"email":"tracey.ramos@reqres.in","first_name":"Tracey","last_name":"Ramos","avatar":"https://reqres.in/img/faces/6-image.jpg"}],"support":{"url":"https://reqres.in/#support-heading","text":"To keep ReqRes free, contributions towards server costs are appreciated!"}}';
          //
          // String data = await rootBundle.loadString("assets/contact.json");
          // print("data $data");

          Response res = await get(Uri.parse("https://reqres.in/api/users?page=1"));
          // NewUserModel userModel=newUserModelFromJson(res.body);
          
          print("resstatusCode =>  ${res.statusCode}");
          print("resstatusCode =>  ${res.body}");

          String data=res.body;

          // Map<String, dynamic> jsonData = jsonDecode(data);
          //
          // NewUserModel userModel=NewUserModel.fromJson(jsonData);
          NewUserModel userModel=newUserModelFromJson(data);

          // sList = jsonData["contact_list"] ?? [];
          // setState(() {});

          // print(jsonData["datas"][1]["last_name1"]);
          print(userModel.total);
          print(userModel.totalPages);
          print(userModel.data?[2].lastName);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
