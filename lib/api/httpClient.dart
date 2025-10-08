import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jobs_app/api/EndPoint.dart';

class Httpclient {
  static String baseurl = Endpoint.url;
  static String token ="" ;

  // ------------------ GET ------------------
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      print(token);
      final Uri url = Uri.parse('$baseurl/$endpoint');
      print('GET: $url');
      final defaultHeaders = {
        'Content-Type': 'application/json',
        'Authorization':   'Bearer $token'
        
      };
      final combinedHeaders = headers != null
          ? {...defaultHeaders, ...headers}
          : defaultHeaders;

      final response = await http.get(
        url,
            headers: combinedHeaders,
      );

      return _handleResponse(response);
    } catch (e) {
      print('GET error: $e');
      rethrow;
    }
  }

  // ------------------ POST ------------------
  Future<dynamic> post(String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    try {
      final Uri url = Uri.parse('$baseurl/$endpoint');
      print('POST: $url');
      print('Body: $body');

      // Default headers (if none passed)
      final defaultHeaders = {
        'Content-Type': 'application/json',
        'Authorization':   'Bearer $token'
        
      };
      final combinedHeaders = headers != null
          ? {...defaultHeaders, ...headers}
          : defaultHeaders;

      final response = await http
          .post(
            url,
            headers: combinedHeaders,
            body: json.encode(body),
          )
;
      return _handleResponse(response);
    } catch (e) {
      print('POST error: $e');
      rethrow;
    }
  }
 Future<dynamic> delete(String endpoint,
      {Map<String, String>? headers}) async {
    try {
      final Uri url = Uri.parse('$baseurl/$endpoint');
      print('DELETE: $url');

      final defaultHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final combinedHeaders = headers != null
          ? {...defaultHeaders, ...headers}
          : defaultHeaders;

      final response = await http
          .delete(url, headers: combinedHeaders)
;
      return _handleResponse(response);
    } catch (e) {
      print('DELETE error: $e');
      rethrow;
    }
  }

  // ------------------ HANDLE RESPONSE ------------------
 dynamic _handleResponse(http.Response response) {
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode < 300) {
    try {
      return json.decode(response.body);
    } catch (e) {
      return response.body;
    }
  } else {
    try {
      final Map<String, dynamic> errorData = json.decode(response.body);
      print('--- Error Message: ${errorData["message"]} ---');
    } catch (e) {
      print('--- Error: Unable to parse error message ---');
    }

    if (response.statusCode == 401) {
      throw Exception('Unauthorized access. Please check your credentials.');
    } else if (response.statusCode == 403) {
      throw Exception('Forbidden access. You do not have permission to access this resource.');
    } else if (response.statusCode == 404) {
      throw Exception('Resource not found.');
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }
}
  // ------------------ PUT ------------------
  Future<dynamic> put(String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    try {
      final Uri url = Uri.parse('$baseurl/$endpoint');
      print('PUT: $url');
      print('Body: $body');

      final defaultHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final combinedHeaders = headers != null
          ? {...defaultHeaders, ...headers}
          : defaultHeaders;

      final response = await http
          .put(
            url,
            headers: combinedHeaders,
            body: json.encode(body),
          )
;
      return _handleResponse(response);
    } catch (e) {
      print('PUT error: $e');
      rethrow;
    }
  }

}
