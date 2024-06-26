import 'package:http/http.dart';

class ApiHelper{

  String baseUrl="https://jsonplaceholder.typicode.com/";
  ApiHelper._name();

  static final ApiHelper obj=ApiHelper._name();

  Future<Response> getUserData()async {
    Response res = await get(Uri.parse("${baseUrl}users"));
    return res;
  }

  Future<Response> getUserPost()async {
    Response res = await get(Uri.parse("${baseUrl}posts"));
    return res;
  }

  Future<Response> getUserComments()async {
    Response res = await get(Uri.parse("${baseUrl}comments"));
    return res;
  }

  Future<Response> getNetworkData(String endpoint)async {
    print("Api Calling  => $endpoint");
    Response res = await get(Uri.parse("$baseUrl$endpoint"));
    print("Api Response  => ${res.statusCode}");
    return res;
  }


  Future<Response> getApiMovieData(String movieName)async {

    print("Api Calling  => $baseUrl");
    Response res = await get(Uri.parse("http://www.omdbapi.com/?apikey=c1729c9&s=$movieName"));
    print("Api Response  => ${res.statusCode}");
    return res;
  }

  Future<Response> getPixabayImage(String category,String imageType)async{
    print("category $category imageType $imageType");
    Response res=await get(Uri.parse("https://pixabay.com/api/?key=42123171-51231a30c65e62f23fa607de4&category=$category&image_type=$imageType&per_page=18"));
    return res;
  }

}