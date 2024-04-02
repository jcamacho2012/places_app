import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String _baseUrl = 'e79faebb-f0ef-42db-8f57-9d346765911f.mock.pstmn.io';

const Duration maxTimeOut = Duration(seconds: 10);
Future<Map<String, dynamic>> getJsonData({required String endpoint}) async {
  try {
    final url = Uri.https(_baseUrl, endpoint);

    // Await the http get response, then decode the json-formatted response.
    final headers = await getHeaders();
    String message = '';

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode != 200) {
      message = json.decode(response.body)['message'];
    }

    return <String, dynamic>{
      'statusCode': response.statusCode,
      'body': response.body,
      'message': message
    };
  } on TimeoutException catch (_) {
    return <String, dynamic>{
      'statusCode': 400,
      'body': null,
      'message': 'Servicio no disponible, intente mas tarde'
    };
  } catch (_) {
    return <String, dynamic>{
      'statusCode': 400,
      'body': null,
      'message': 'error'
    };
  }
}

Future<Map<String, dynamic>> postJsonData(
    {required String endpoint, required Object body}) async {
  try {
    final url = Uri.https(_baseUrl, endpoint);
    final headers = await getHeaders();
    String message = '';

    final response = await http
        .post(
          url,
          headers: headers,
          body: jsonEncode(body),
        )
        .timeout(maxTimeOut);

    if (response.statusCode != 200) {
      try {
        message = json.decode(response.body)['message'];
      } catch (error) {
        message = response.body;
      }
    }

    return <String, dynamic>{
      'statusCode': response.statusCode,
      'body': response.body,
      'message': message
    };
  } on TimeoutException catch (_) {
    return <String, dynamic>{
      'statusCode': 400,
      'body': null,
      'message': 'Servicio no disponible, intente mas tarde'
    };
  } catch (error) {
    return <String, dynamic>{
      'statusCode': 400,
      'body': null,
      'message': 'error'
    };
  }
}

Future<Map<String, String>> getHeaders() async {
  return <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Access-Control-Allow-Origin': '*',
  };
}
