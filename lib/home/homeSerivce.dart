import 'dart:io';
import 'package:jobs_app/api/EndPoint.dart';
import 'package:jobs_app/api/httpClient.dart';

class HomeService {
  final Httpclient api;

  HomeService() : api = Httpclient(); // ✅ added semicolon and fixed typo

  Future<dynamic> getAllServices() async {
    try {
      String endpoint =Endpoint.user+"/"+ Endpoint.getallservices;
      var response = await api.get(endpoint);
      print('-----');
print(response);
      if (response != null) {
        return response;
      } else {
        print(" Error: Response does not contain 'data' key or is invalid");
        throw Exception("⚠️ No data returned from server");
      }
    } catch (e) {
      throw Exception("Serveur inaccessible. Vérifiez votre connexion !\n$e");
    }
  }
}
