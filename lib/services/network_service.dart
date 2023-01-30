import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkManager {
  static Future<http.Response> get({required String url}) async {
    try {
      //Get token
      final String? tokenTemp = "";
      String token = "Bearer $tokenTemp";
      //Headers
      Map<String, String> headers = {};
      headers['Accept'] = "application/json";
      headers['Content-Type'] = "application/json";
      headers['Connection'] = "keep-alive";
      headers['authorization'] = token;
      http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      Logger().i(
        'REQ Headers: $headers\n'
        'RES Headers: ${response.request?.headers}\n'
        'REQUEST\n >> ${response.request}\n'
        'STATUS\n >> ${response.statusCode}\n'
        'BODY\n >> ${response.body}',
      );
      return response;
    } catch (e, stack) {
      Logger().e('Error on \n >> $url', e, stack);
      throw Exception('---FAILED TO GET---');
    }
  }

  static Future<http.Response> post(
      {required String url, required Map<String, dynamic> body}) async {
    try {
      //Get token
      final String? tokenTemp = "";
      String token = "Bearer $tokenTemp";
      //Headers
      Map<String, String> headers = {};
      headers['Accept'] = "application/json";
      headers['Content-Type'] = "application/json";
      headers['Connection'] = "keep-alive";
      headers['authorization'] = token;

      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );
      Logger().i(
        'REQ Headers: $headers\n'
        'RES Headers: ${response.request?.headers}\n'
        'REQ BODY: $body\n'
        'REQUEST\n >> ${response.request}\n'
        'STATUS\n >> ${response.statusCode}\n'
        'BODY\n >> ${response.body}',
      );
      // ;
      return response;
    } catch (e, stack) {
      Logger().e('Error on \n >> $url', e, stack);
      throw Exception('---FAILED TO POST---');
    }
  }

  static Future<http.Response> delete({required String url}) async {
    try {
      //Get token
      final String? tokenTemp = "";
      String token = "Bearer $tokenTemp";
      //Headers
      Map<String, String> headers = {};
      headers['Accept'] = "application/json";
      headers['Content-Type'] = "application/json";
      headers['Connection'] = "keep-alive";
      headers['authorization'] = token;

      http.Response response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );
      Logger().i(
        'REQ Headers: $headers\n'
        'RES Headers: ${response.request?.headers}\n'
        'REQUEST\n >> ${response.request}\n'
        'STATUS\n >> ${response.statusCode}\n'
        'BODY\n >> ${response.body}',
      );
      return response;
    } catch (e, stack) {
      Logger().e('Error on \n >> $url', e, stack);
      throw Exception('---FAILED TO DELETE---');
    }
  }
}
