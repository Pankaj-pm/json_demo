class TODOModel{

  int? userId;
  int? id;
  String? title;
  bool? completed;

  TODOModel({this.userId, this.id, this.title, this.completed});

  factory TODOModel.fromJson(Map<String,dynamic> map){

    return TODOModel(
      title: map["title"],
      userId: map["userId"],
      id: map["id"],
      completed: map["completed"],
    );
  }

}