import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_demo/movies_list.dart';
import 'package:json_demo/network_user.dart';
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
              icon: Icon(Icons.movie))
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
          //     '{"contact_list":[{"name":"jaybeer","mobile_number":464647687},{"name":"veer","mobile_number":464647687},{"name":"harsh","mobile_number":47978},{"name":"baby","mobile_number":455456464}]}';

          String data = await rootBundle.loadString("assets/contact.json");
          print("data $data");

          Map<String, dynamic> jsonData = jsonDecode(data);
          sList = jsonData["contact_list"] ?? [];
          setState(() {});

          print(sList);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
