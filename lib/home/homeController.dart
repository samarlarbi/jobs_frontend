import 'package:jobs_app/home/homeSerivce.dart';

class Homecontroller {

  final HomeService homeservice ;
  Homecontroller() : homeservice =HomeService();
   Future<List<Map<String, dynamic>>> getAllWorkersServices() async {
  final response = await homeservice.getAllWorkersServices();
  if (response is List) {
    return response.map((item) => Map<String, dynamic>.from(item)).toList();
  } else {
    throw Exception("Invalid response format");
  }
}Future<List<Map<String, dynamic>>> getallservices() async {
  final response = await homeservice.getAllServices();
  if (response is List) {
    return response.map((item) => Map<String, dynamic>.from(item)).toList();
  } else {
    throw Exception("Invalid response format");
  }
}


}
