import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// import 'package:http_parser/http_parser.dart' show MediaType;


/// A network helper class to do all the back end request
class NetworkHelper {
  /// next three lines makes this class a Singleton
  static final NetworkHelper _instance = NetworkHelper.internal();
  NetworkHelper.internal();
  factory NetworkHelper() => _instance;

  /// An object for decoding json values
  final JsonDecoder _decoder = const JsonDecoder();

  /// A function to do the login request with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> postLogin(String url, {Map<String, String>? headers, body, encoding}) async {
    print(url);
    print(body);

    try {
      return http
          .post(Uri.parse(url), body: json.encode(body),
          headers: headers,
          encoding: encoding)
          .then((http.Response response) {
        final String res = response.body;
        print(res);
        final int statusCode = response.statusCode;
        var result = _decoder.convert(res);
        if (statusCode < 200 || statusCode > 400) {
          throw ("${result['message']}");
        }
        return result;
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }


  /// A function to do any get request with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> get(String url, {Map<String, String>? headers, body}) async {
    print(url);
    try {
      return http.get(Uri.parse(url), headers: headers).then((http.Response response) {
        final String res = response.body;
        print(response.statusCode);
        var myResponse={
          "code":response.statusCode,
          "body": response.body
        };
        final int statusCode = response.statusCode;
        if (statusCode < 200 || statusCode >= 400) {
          throw (myResponse);
        }
        return _decoder.convert(res);
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  /// A function to do any post request with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> post(String url, {Map<String, String>? headers, body, encoding}) {
    // print(url);
    // print(headers);
    // print(body);
    try {
      return http
          .post(Uri.parse(url),
          body: json.encode(body), headers: headers, encoding: encoding)
          .then((http.Response response) {
        final String res = response.body;
        print("This is the respoe");
        var myResponse={
          "code":response.statusCode,
          "body": response.body
        };

        final int statusCode = response.statusCode;
        var result = _decoder.convert(res);
        if (statusCode < 200 || statusCode >= 400) {
          throw (myResponse);
        }
        return result;
      });
    } catch (e) {
      print("THis is the value ");
      print(e);
      rethrow;
    }
  }





  /// A function to do any post request with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> patch(String url, {Map<String, String>? headers, body, encoding}) {
    print(url);
    print(headers);
    print(body);
    try {
      return http
          .patch(Uri.parse(url),
          body: json.encode(body), headers: headers, encoding: encoding)
          .then((http.Response response) {
        final String res = response.body;
        print(res);
        final int statusCode = response.statusCode;
        var result = _decoder.convert(res);
        if (statusCode < 200 || statusCode > 400) {
          throw ("${result['msg']}");
        }
        return result;
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  /// A function to do any post request of form data with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> postForm(Uri url, List<http.MultipartFile> files,
      {Map<String, String>? headers, body, encoding}) async {
    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers!);
      if (body != null) {
        request.fields.addAll(body);
      }
      request.files.addAll(files);
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final dynamic res = json.decode(response.body);
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        throw ("${res["msg"]}");
      }
      return res;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  /// A function to do any put request with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> put(String url, {Map<String, String>? headers, body, encoding}) {
    try {
      return http
          .put(Uri.parse(url),
          body: json.encode(body), headers: headers, encoding: encoding)
          .then((http.Response response) {
        print(response.body);
        final String res = response.body;
        final int statusCode = response.statusCode;
        var result = _decoder.convert(res);
        if (statusCode < 200 || statusCode > 400) {
          throw ("${result['msg']}");
        }
        return result;
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  /// A function to do any put request of form data with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> putForm(Uri url, List<http.MultipartFile> files,
      {Map<String, String>? headers, body, encoding}) async {
    try {
      var request = http.MultipartRequest('PUT', url);
      request.headers.addAll(headers!);
      if (body != null) {
        request.fields.addAll(body);
      }
      request.files.addAll(files);
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final dynamic res = json.decode(response.body);
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        throw ("${res["msg"]}");
      }
      return res;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  /// A function to do any delete request with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> delete(String url, {Map<String, String>? headers}) {
    try {
      print(url);
      return http.delete(Uri.parse(url), headers: headers).then((http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;
        // print(statusCode);
        return res;
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
