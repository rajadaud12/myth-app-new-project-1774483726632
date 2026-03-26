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
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return json.decode(response.body);
    }
    
    String errorMessage;
    try {
      final body = json.decode(response.body);
      if (body is Map) {
        errorMessage = body['message'] ?? body['error'] ?? 'Unknown error';
        if (body.containsKey('errors') && body['errors'] is Map) {
          final errors = body['errors'] as Map<String, dynamic>;
          errorMessage = errors.values.map((e) => e.toString()).join(', ');
        }
      } else {
        errorMessage = body.toString();
      }
    } catch (_) {
      errorMessage = response.body.isNotEmpty ? response.body : 'Unknown error';
    }
    
    switch (response.statusCode) {
      case 400:
        throw ApiException(400, 'Bad request: $errorMessage');
      case 401:
        throw ApiException(401, 'Unauthorized: Please login again');
      case 403:
        throw ApiException(403, 'Forbidden: Access denied');
      case 404:
        throw ApiException(404, 'Not found: Resource does not exist');
      case 422:
        throw ApiException(422, 'Validation error: $errorMessage');
      case 500:
        throw ApiException(500, 'Server error: Please try again later');
      case 502:
        throw ApiException(502, 'Bad gateway: Service temporarily unavailable');
      case 503:
        throw ApiException(503, 'Service unavailable: Please try again later');
      default:
        throw ApiException(response.statusCode, errorMessage);
    }
  }
  
  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);
      return handleResponse(response);
    } on http.ClientException catch (e) {
      throw ApiException(0, 'Network error: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(0, 'Connection failed: Please check your internet');
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
    } on http.ClientException catch (e) {
      throw ApiException(0, 'Network error: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(0, 'Connection failed: Please check your internet');
    }
  }
}