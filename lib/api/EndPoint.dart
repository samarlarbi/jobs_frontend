
import 'package:flutter_dotenv/flutter_dotenv.dart';
class Endpoint {


  static final String url= dotenv.env['URL'] ?? "http://";
  
  static final String getallservices= "services";
  static final String user= "user";
  

}
