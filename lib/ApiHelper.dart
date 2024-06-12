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

}