import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:json_demo/ApiHelper.dart';
import 'package:json_demo/omdb_model.dart';

class MoviesList extends StatefulWidget {
  const MoviesList({super.key});

  @override
  State<MoviesList> createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: search,
              )),
              IconButton(
                  onPressed: () async {
                    setState(() {});
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          Expanded(
            child: FutureBuilder<Response>(
                future: ApiHelper.obj.getApiMovieData(search.text),
                builder: (context, snapshot) {
                  print("Response ${snapshot.data}");
                  if (snapshot.data != null) {
                    OmdbMode omdbMode = omdbModeFromJson(snapshot.data?.body ?? "");
                    return ListView.builder(
                      itemCount: omdbMode.search?.length ?? 0,
                      itemBuilder: (context, index) {
                        var search = omdbMode.search![index];
                        return Container(
                          margin: EdgeInsets.all(10),
                          child: Stack(
                            children: [
                              Image.network(
                                search.poster ?? "",
                                fit: BoxFit.cover,
                                height: 200,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Text("No Image");
                                },
                              ),
                              ClipRRect(
                                // Clip it cleanly.
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    color: Colors.grey.withOpacity(0.1),
                                    alignment: Alignment.center,
                                    height: 200,
                                    child: Image.network(
                                      search.poster ?? "",
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Text("No Image");
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Text(search.title ?? ""),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text("Loading..."));
                  }
                }),
          )
        ],
      ),
    );
  }
}
