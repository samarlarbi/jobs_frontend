import 'dart:developer';

import 'package:jobs_app/services/services.dart';


class Controller {

  final Services service ;
  Controller() : service =Services();

Future<List<Map<String, dynamic>>> getWorkerOffShifts() async {
    final response = await service.getWorkerOffShifts();
    if (response is List) {
      return response.map((item) => Map<String, dynamic>.from(item)).toList();
    } else {
      throw Exception("Invalid response format");
    }
  }

Future<List<Map<String, dynamic>>> getworkerreservation() async {
    final response = await service.getworkerreservation();
    if (response is List) {
      return response.map((item) => Map<String, dynamic>.from(item)).toList();
    } else {
      throw Exception("Invalid response format");
    }
  }
  Future<Map<String, dynamic>> addOffShift(Map<String, dynamic> body) async {
    return await service.addOffShift(body);
  }
 Future<List<Map<String, dynamic>>> getservicestypes() async {
  final response = await service.getservices();
  if (response is List) {
    return response.map((item) => Map<String, dynamic>.from(item)).toList();
  } else {
    throw Exception("Invalid response format");
  }
}

  Future<Map<String, dynamic>> addservices(int id,  Map<String, dynamic> body) async {
    return await service.addservice(id,body);
  }

  Future<void> deleteOffShift(int id) async {
    await service.deleteOffShift(id);
  }

  // ------------------- Worker Services -------------------
  Future<void> deleteWorkerService(int workerServiceId) async {
    await service.deleteWorkerService(workerServiceId);
  }

  // ------------------- Update Worker Profile -------------------
  Future<Map<String, dynamic>> updateWorkerProfile(Map<String, dynamic> body) async {
    return await service.updateWorkerProfile(body);
  }


   Future<Map<String, dynamic>> getprofile(int id) async {
  final response = await service.getprofile(id);
   return response;
 

}
   Future<Map<String, dynamic>> getareservation(int id) async {
  final response = await service.getareservation(id);
   return response;
 

}


   Future<Map<String, dynamic>> getstatsworker() async {
  final response = await service.getstatsworker();
   return response;
 

}

   Future<Map<String, dynamic>> getmyprofile() async {
  final response = await service.getmyprofile();
   return response;
 

}


  
 Future<List<Map<String, dynamic>>> searchworker({String? q}) async {
  final response = await service.searchWorkers(q: q);

  if (response is List) {
    return response.map((item) => Map<String, dynamic>.from(item)).toList();
  } else {
    throw Exception("Invalid response format");
  }
}



Future<List<Map<String, dynamic>>> getreservations() async {
  final response = await service.getreservations();
if (response is List) {
    return response.map((item) => Map<String, dynamic>.from(item)).toList();
  } else {
    throw Exception("Invalid response format");
  }
}

   Future<Map<String, dynamic>> addreservation(Map<String, dynamic> body) async {
  final response = await service.addreservation(body);
    return response;
 

}
   Future<Map<String, dynamic>> updatereservation(int idreservation,Map<String, dynamic> body) async {
  final response = await service.updatereservation(idreservation,body);
    return response;
 

}


   Future<void> deletreservation(int id) async {
  final response = await service.deletereservation(id);
    return response;
 

}


}
