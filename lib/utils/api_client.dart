import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int statusCode;
  final String message;
  
  ApiException(this.statusCode, this.message);
  
  @override
  String toString() => 'ApiException: $statusCode - $message';
}

class ApiClient {
  static const String baseUrl = 'https://api.example.com';
  static const Duration timeout = Duration(seconds: 30);
  
  static Future<Map<String, dynamic>> handleResponse(http.Response response) async {
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body);
      case 422:
        final body = json.decode(response.body);
        String errorMessage = 'Validation error';
        if (body is Map && body.containsKey('message')) {
          errorMessage = body['message'];
        } else if (body is Map && body.containsKey('errors')) {
          final errors = body['errors'];
          if (errors is Map) {
            errorMessage = errors.values.map((e) => e.toString()).join(', ');
          }
        }
        throw ApiException(422, errorMessage);
      case 400:
        throw ApiException(400, 'Bad request');
      case 401:
        throw ApiException(401, 'Unauthorized');
      case 403:
        throw ApiException(403, 'Forbidden');
      case 404:
        throw ApiException(404, 'Not found');
      case 500:
        throw ApiException(500, 'Server error');
      default:
        throw ApiException(response.statusCode, 'Unknown error');
    }
  }
  
  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);
      return handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(0, e.toString());
    }
  }
  
  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      ).timeout(timeout);
      return handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(0, e.toString());
    }
  }
}