import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
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
  List sList=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: sList.length,
        itemBuilder: (context, index) {
          Map<String,dynamic> item = sList[index];

          return ListTile(
            title: Text(item["name"]??""),
            subtitle: Text("age : ${item["age"]}"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String data =
              '{"status":true,"message":"success","student":[{"name":"s1","age":10,"address":"rajkot"},{"name":"jayveer","age":18,"address":"150 ring road,rajkot"},{"name":"s5","age":10,"address":"rajkot"},{"name":"new jayveer","age":18,"address":"150 ring road,rajkot"}]}';
          Map<String, dynamic> jsonData = jsonDecode(data);
          sList = jsonData["student"]??[];
          setState(() {

          });
          
          rootBundle.loadString(key)

          print(sList);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
