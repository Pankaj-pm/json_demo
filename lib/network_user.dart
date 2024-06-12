import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:json_demo/ApiHelper.dart';
import 'package:json_demo/UserModel.dart';
import 'package:json_demo/student.dart';
import 'package:json_demo/user.dart';

class NetworkUser extends StatefulWidget {
  const NetworkUser({super.key});

  @override
  State<NetworkUser> createState() => _NetworkUserState();
}

class _NetworkUserState extends State<NetworkUser> {
  List<UserModel> userList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    isLoading = true;
    setState(() {
    });
    await Future.delayed(Duration(seconds: 2));
    // Response res = await get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
    // Response res = await ApiHelper.obj.getUserData();
    Response res = await ApiHelper.obj.getNetworkData("users");

    // userList = jsonDecode(res.body);
    try{
      userList= userModelFromJson(res.body);
    }catch(e){
      print("Parsing Error");

    }

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              UserModel user = userList[index];

              // UserModel user = UserModel.fromJson(userList[index]);

              print("user = > ${user.runtimeType} ");
              return ListTile(
                leading: CircleAvatar(
                  child: Text("${user.id}"),
                ),
                title: Text("${user.name}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${user.email}"),
                    Text("${user.address?.city},${user.address?.street}"),
                  ],
                ),
              );
            },
          ),
          if (isLoading)
            Container(
              alignment: Alignment.center,
              color: Colors.black26,
              child: CircularProgressIndicator(),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          getUserData();
          // Response res = await ApiHelper.obj.getNetworkData("posts");
        },
      ),
    );
  }
}
