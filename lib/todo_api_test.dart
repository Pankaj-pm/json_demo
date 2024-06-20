import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:json_demo/student_single.dart';
import 'package:json_demo/student_single.dart';
import 'package:json_demo/todos_model.dart';

class ToDoApiTest extends StatefulWidget {
  const ToDoApiTest({super.key});

  @override
  State<ToDoApiTest> createState() => _ToDoApiTestState();
}

class _ToDoApiTestState extends State<ToDoApiTest> {
  // Map<String, dynamic> apiData={};
  TODOModel? model;
  TextEditingController controller = TextEditingController(text: "70");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: get(Uri.parse("https://jsonplaceholder.typicode.com/todos/${controller.text}")),
        builder: (context, snapshot) {
          Response? res = snapshot.data;

          if (res != null) {
            Map<String, dynamic> apiData = jsonDecode(res.body ?? "");
            model = TODOModel.fromJson(apiData);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: controller,
                ),
                // const Text("UserId",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                // Text("${apiData["userId"]??0}",style: const TextStyle(fontSize: 20),),
                // const Text("ID",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                // Text("${apiData["id"]??0}",style: TextStyle(fontSize: 20),),
                // const Text("Title",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                //  Text(apiData["title"]??"--",style: TextStyle(fontSize: 20),),
                // const Text("completed",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                // Text("${apiData["completed"]}",style: TextStyle(fontSize: 20),),const Text("UserId",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),

                Text(
                  "${model?.userId}",
                  style: const TextStyle(fontSize: 20),
                ),
                const Text(
                  "ID",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${model?.id}",
                  style: TextStyle(fontSize: 20),
                ),
                const Text(
                  "Title",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  model?.title ?? "",
                  style: TextStyle(fontSize: 20),
                ),
                const Text(
                  "completed",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${model?.completed}",
                  style: TextStyle(fontSize: 20),
                ),
                if (model?.completed ?? false) Icon(Icons.cloud_done_rounded)
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Student s = Student.student;
          Student s1 = Student.student;
          Student s2 = Student.student;
          Student s3 = Student.student;

          print("s ${s.hashCode}");
          print("s1 ${s1.hashCode}");
          print("s2 ${s2.hashCode}");
          print("s3 ${s3.hashCode}");

          // Response res=await get(Uri.parse("https://jsonplaceholder.typicode.com/todos/${controller.text}"));
          //
          //
          // Map<String,dynamic> apiData = jsonDecode(res.body);
          // model= TODOModel.fromJson(apiData);
          //
          // setState(() {
          // });
        },
      ),
    );
  }
}
