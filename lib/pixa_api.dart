import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:json_demo/pixabay_model.dart';

class PixaApi extends StatefulWidget {
  const PixaApi({super.key});

  @override
  State<PixaApi> createState() => _PixaApiState();
}

class _PixaApiState extends State<PixaApi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: get(Uri.parse("https://pixabay.com/api/?key=42123171-51231a30c65e62f23fa607de4")),
        builder: (context, snapshot) {

          Response? res=snapshot.data;
          if(res!=null){

            PixaBayModel pixaBayModel = pixaBayModelFromJson(res.body);




            return ListView.builder(
              itemCount: pixaBayModel.hits?.length??0,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(10),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Image.network(
                      pixaBayModel.hits![index].previewUrl??"",
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }
}
