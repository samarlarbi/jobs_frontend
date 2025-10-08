import 'dart:io';
import 'package:jobs_app/api/EndPoint.dart';
import 'package:jobs_app/api/httpClient.dart';

class Services {
  final Httpclient api;

  Services() : api = Httpclient(); // ✅ added semicolon and fixed typo
Future<List<dynamic>> getWorkerOffShifts() async {
  try {
    String endpoint = "worker/offshift";
    var response = await api.get(endpoint);
    return response as List<dynamic>;
  } catch (e) {
    if (e.toString().contains("Resource not found")) {
      // ✅ Return empty list if no off shifts found
      return [];
    }
    throw Exception("Erreur lors du chargement des jours off: $e");
  }
}

Future<dynamic> getservices() async {
  try {
    String endpoint = "user/services";
    var response = await api.get(endpoint);
    return response as List<dynamic>;
  } catch (e) {
    throw Exception("Erreur lors du chargement des jours off: $e");
  }
}

Future<dynamic> getworkerreservation() async {
  try {
    String endpoint = "worker/reservation";
    var response = await api.get(endpoint);
    return response as List<dynamic>;
  } catch (e) {
    throw Exception("Erreur lors du chargement des jours off: $e");
  }
}
Future<Map<String, dynamic>> addOffShift(Map<String, dynamic> body) async {
  try {
    String endpoint = "worker/offshift";
    var response = await api.post(endpoint, body);
    return response;
  } catch (e) {
    throw Exception("Erreur lors de l’ajout du jour off: $e");
  }
}


Future<Map<String, dynamic>> addservice(int id ,Map<String, dynamic> body) async {
  try {
    String endpoint = "worker/services/"+id.toString();
    var response = await api.post(endpoint, body);
    return response;
  } catch (e) {
    throw Exception("Erreur lors de l’ajout du jour off: $e");
  }
}
Future<void> deleteOffShift(int id) async {
  try {
    String endpoint = "worker/offshift/"+id.toString();
    await api.delete(endpoint);
  } catch (e) {
    throw Exception("Erreur lors de la suppression du jour off: $e");
  }
}
Future<void> deleteWorkerService(int workerServiceId) async {
  try {
    String endpoint = "worker/workerservice/$workerServiceId";
    await api.delete(endpoint);
  } catch (e) {
    throw Exception("Erreur lors de la suppression du service: $e");
  }
}

Future<void> deletereservation(int workerServiceId) async {
  try {
    String endpoint = "worker/reservation/$workerServiceId";
    await api.delete(endpoint);
  } catch (e) {
    throw Exception("Erreur lors de la suppression du service: $e");
  }
}
Future<Map<String, dynamic>> updateWorkerProfile(Map<String, dynamic> body) async {
  try {
    String endpoint = "worker";
    var response = await api.put(endpoint, body);
    return response;
  } catch (e) {
    throw Exception("Erreur lors de la mise à jour du profil: $e");
  }
}

Future<Map<String, dynamic>> updatereservation(int id ,  Map<String, dynamic> body) async {
  try {
    String endpoint = "worker/reservation/"+id.toString();
    var response = await api.put(endpoint, body);
    return response;
  } catch (e) {
    throw Exception("Erreur lors de la mise à jour du profil: $e");
  }
}
Future<dynamic> getstatsworker() async {
    try {
            print('-+++++-+-+-+-+-+-++----');

      String endpoint =Endpoint.user+"/stats";
      var response = await api.get(endpoint);
      print('-+++++-+-+-STATS+-+-+-++----');
      print(response);
      if (response != null) {
        return response;
      } else {
        print(" Error: Response does not contain 'data' key or is invalid");
        throw Exception("No data returned from server");
      }
    } catch (e) {
      throw Exception("Serveur inaccessible. Vérifiez votre connexion !\n$e");
    }
  }

   Future<Map<String, dynamic>> getprofile(int id) async {
    try {
            print('-+++++-+-+-+-+-+-++----');

      String endpoint =Endpoint.user+"/profile/"+id.toString();
      var response = await api.get(endpoint);
      print('-+++++-+-+-+-+-+-++----');
      print(response);
      if (response != null) {
        return response;
      } else {
        print(" Error: Response does not contain 'data' key or is invalid");
        throw Exception("No data returned from server");
      }
    } catch (e) {
      throw Exception("Serveur inaccessible. Vérifiez votre connexion !\n$e");
    }
  }
   Future<Map<String, dynamic>> getmyprofile() async {
    try {
            print('-+++++-+-+-+-+-+-++----');

      String endpoint =Endpoint.user+"/profile";
      var response = await api.get(endpoint);
      print('-+++++-+-+-+-+-+-++----');
      print(response);
      if (response != null) {
        return response;
      } else {
        print(" Error: Response does not contain 'data' key or is invalid");
        throw Exception("No data returned from server");
      }
    } catch (e) {
      throw Exception("Serveur inaccessible. Vérifiez votre connexion !\n$e");
    }
  }
Future<Map<String, dynamic>> getareservation(int id) async {
    try {
            print('-+++++-+-+-+-+-+-++----');

      String endpoint ="user/reservation/"+id.toString();
      var response = await api.get(endpoint);
      print('-+++++-+-+-+-+-+-++----');
      print(response);
      if (response != null) {
        return response;
      } else {
        print(" Error: Response does not contain 'data' key or is invalid");
        throw Exception("No data returned from server");
      }
    } catch (e) {
      throw Exception("Serveur inaccessible. Vérifiez votre connexion !\n$e");
    }
  }


   Future<dynamic> getreservations() async {
    try {
            print('-+++++-+-+-+-+-+-++----');

      String endpoint =Endpoint.user+"/"+Endpoint.reservation;
      var response = await api.get(endpoint);
      print('-+++++-+-+-+-+-+-++----');
      print(response);
      if (response != null) {
        return response;
      } else {
        print(" Error: Response does not contain 'data' key or is invalid");
        throw Exception("No data returned from server");
      }
    } catch (e) {
      throw Exception("Serveur inaccessible. Vérifiez votre connexion !\n$e");
    }
  }
  
  Future<List<dynamic>> searchWorkers({String? q, int skip = 0, int limit = 10}) async {
  try {
    String endpoint = Endpoint.user + "/search";

    Map<String, String> queryParams = {
      "skip": skip.toString(),
      "limit": limit.toString(),
    };

    if (q != null && q.isNotEmpty) {
      queryParams["q"] = q;
    }

    String queryString = Uri(queryParameters: queryParams).query;
    String fullUrl = "$endpoint?$queryString";

    final response = await api.get(fullUrl);

    print("Search response: $response");

    if (response != null) {
      return response as List;
    } else {
      throw Exception("No data returned from server");
    }
  } catch (e) {
    throw Exception("Serveur inaccessible. Vérifiez votre connexion !\n$e");
  }
}


 Future<Map<String, dynamic>> addreservation(Map<String,dynamic> body) async {
    try {
            print('-+++++-+-+-+-+-+-++----');

      String endpoint =Endpoint.user+"/"+Endpoint.reservation;
      var response = await api.post(endpoint,body);
      print('-+++++-+-+-+-+-+-++----');
      print(response);
      if (response != null) {
        return response;
      } else {
        print(" Error: Response does not contain 'data' key or is invalid");
        throw Exception("No data returned from server");
      }
    } catch (e) {
      throw Exception("Serveur inaccessible. Vérifiez votre connexion !\n$e");
    }
  }
 
}
