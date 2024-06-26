// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';
import 'package:json_demo/ApiHelper.dart';
import 'package:json_demo/pixabay_model.dart';

class PixabayApi extends StatefulWidget {
  const PixabayApi({super.key});

  @override
  State<PixabayApi> createState() => _PixabayApiState();
}

class _PixabayApiState extends State<PixabayApi> {
  List<String> imgType = ["all", "photo", "illustration", "vector"];
  List<String> category = [
    "backgrounds",
    "fashion",
    "nature",
    "science",
    "education",
    "feelings",
    "health",
    "people",
    "religion",
    "places",
    "animals",
    "industry",
    "computer",
    "food",
    "sports",
    "transportation",
    "travel",
    "buildings",
    "business",
    "music"
  ];

  int selectedcategoryIndex = 0;

  // String? selectedImgType;
  int selectedImgTypeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // DropdownButton(
          //   value: selectedImgType,
          //   items: imgType
          //       .map(
          //         (e) => DropdownMenuItem(
          //           value: e,
          //           child: Text(e),
          //         ),
          //       )
          //       .toList(),
          //   onChanged: (value) {
          //     selectedImgType=value;
          //     setState(() {
          //     });
          //     print(value);
          //   },
          // ),
          DropdownButton(
            value: selectedImgTypeIndex,
            items: List.generate(imgType.length, (index) {
              return DropdownMenuItem(
                child: Text(imgType[index]),
                value: index,
              );
            }),
            onChanged: (value) {
              selectedImgTypeIndex = value ?? 0;
              setState(() {});
              print(value);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: category.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ActionChip(
                    label: Text(category[index]),
                    padding: const EdgeInsets.all(5),
                    backgroundColor: selectedcategoryIndex == index ? Colors.red : Colors.blueGrey,
                    onPressed: () {
                      selectedcategoryIndex = index;
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<Response>(
              future: ApiHelper.obj.getPixabayImage(category[selectedcategoryIndex], imgType[selectedImgTypeIndex]),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  var pixaBayModel = pixaBayModelFromJson(snapshot.data?.body ?? '');

                  return GridView.builder(
                    padding: const EdgeInsets.all(18.0),
                    itemCount: pixaBayModel.hits?.length ?? 0,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {
                      var hit = pixaBayModel.hits![index];
                      return InkWell(
                        onTap: () async {
                          File file = await DefaultCacheManager().getSingleFile(hit.largeImageUrl ?? "");

                          // bool isSuccess = await AsyncWallpaper.setWallpaperFromFile(
                          //   filePath: file.path,
                          //   goToHome:false,
                          //   wallpaperLocation: AsyncWallpaper.BOTH_SCREENS,
                          // );

                          var res = await showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        Navigator.pop(context,AsyncWallpaper.LOCK_SCREEN);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("Lock Scren"),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        Navigator.pop(context,AsyncWallpaper.HOME_SCREEN);

                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("Home Scren"),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context,AsyncWallpaper.BOTH_SCREENS );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("Both Scren"),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );

                          if(res!=null){
                            setAppWallpaper(res,file);
                          }


                          // print("object--- $isSuccess");
                        },
                        child: Container(
                          child: Image.network(
                            hit.largeImageUrl ?? "",
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void setAppWallpaper(int type, File file) async {
    bool isSuccess = await AsyncWallpaper.setWallpaperFromFile(
      filePath: file.path,
      goToHome: true,
      wallpaperLocation: type,
    );
  }
}
