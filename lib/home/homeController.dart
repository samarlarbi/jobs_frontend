import 'package:jobs_app/home/homeSerivce.dart';

class Homecontroller {

  final HomeService homeservice ;
  Homecontroller() : homeservice =HomeService();
   Future<List<Map<String, dynamic>>> getallservices() async {
  final response = await homeservice.getAllServices();
  // Make sure it's a list of maps
  if (response is List) {
    return response.map((item) => Map<String, dynamic>.from(item)).toList();
  } else {
    throw Exception("Invalid response format");
  }
}


}
