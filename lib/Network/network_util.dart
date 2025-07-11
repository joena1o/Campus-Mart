import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// import 'package:http_parser/http_parser.dart' show MediaType;

/// A network helper class to do all the back end request
class NetworkHelper {
  /// next three lines makes this class a Singleton
  static final NetworkHelper _instance = NetworkHelper.internal();
  NetworkHelper.internal();
  factory NetworkHelper() => _instance;

  /// A function to do any get request with the url and headers
  Future<http.Response> get(String url,
      {Map<String, String>? headers, body}) async {
    // print(url);
    try {
      return await http.get(Uri.parse(url), headers: headers);
    } catch (e) {
      //print(e);
      rethrow;
    }
  }

  /// A function to do any post request with the url and headers
  Future<http.Response> post(String url,
      {Map<String, String>? headers, body, encoding}) async {
    // print(url);
    // print(headers);
    // print(body);
    try {
      return await http.post(Uri.parse(url),
          body: json.encode(body), headers: headers, encoding: encoding);
    } catch (e) {
      rethrow;
    }
  }

  /// A function to do any put request with the url and headers
  Future<http.Response> put(String url,
      {Map<String, String>? headers, body, encoding}) async {
    try {
      return await http.put(Uri.parse(url),
          body: json.encode(body), headers: headers, encoding: encoding);
    } catch (e) {
      rethrow;
    }
  }

  /// A function to do any delete request with the url and headers
  Future<http.Response> delete(String url,
      {Map<String, String>? headers}) async {
    try {
      return await http.delete(Uri.parse(url), headers: headers);
    } catch (e) {
      rethrow;
    }
  }
}
