
import 'package:flutter_dotenv/flutter_dotenv.dart';
class Endpoint {


  static final String url= dotenv.env['URL'] ?? "http://";
  
  static final String getallservices= "services";
  static final String user= "user";
  static final String worker= "worker";
  static final String worker_services= "worker_services";
  static final String reservation= "reservation";
  

}
