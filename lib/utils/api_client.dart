import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? validationErrors;
  
  ApiException(this.statusCode, this.message, {this.validationErrors});
  
  @override
  String toString() => message;
  
  String getFullError() {
    final buffer = StringBuffer();
    buffer.writeln('Error $statusCode: $message');
    if (validationErrors != null && validationErrors!.isNotEmpty) {
      buffer.writeln('Validation errors:');
      validationErrors!.forEach((key, value) {
        buffer.writeln('  - $key: $value');
      });
    }
    return buffer.toString();
  }
}

class ApiClient {
  static const String baseUrl = 'https://api.example.com';
  static const Duration timeout = Duration(seconds: 30);
  
  static Map<String, String> _getHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
  
  static String _getErrorMessage(dynamic body, int statusCode) {
    if (body is Map) {
      final message = body['message'] ?? body['error'] ?? body['Message'];
      if (message != null) return message;
    }
    return 'Request failed with status code $statusCode';
  }
  
  static Future<Map<String, dynamic>> handleResponse(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return json.decode(response.body);
    }
    
    Map<String, dynamic>? validationErrors;
    String errorMessage;
    
    try {
      final body = json.decode(response.body);
      errorMessage = _getErrorMessage(body, response.statusCode);
      if (body is Map) {
        if (body.containsKey('errors') && body['errors'] is Map) {
          validationErrors = Map<String, dynamic>.from(body['errors']);
        } else if (body.containsKey('validation_errors') && body['validation_errors'] is Map) {
          validationErrors = Map<String, dynamic>.from(body['validation_errors']);
        }
      }
    } catch (_) {
      errorMessage = response.body.isNotEmpty 
          ? response.body 
          : 'Request failed with status code ${response.statusCode}';
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
      case 409:
        String conflictDetail = errorMessage;
        if (errorMessage.contains('409') || errorMessage.isEmpty) {
          conflictDetail = 'This item already exists. Please update or remove the existing one first.';
        }
        throw ApiException(409, conflictDetail, validationErrors: validationErrors);
      case 422:
        throw ApiException(422, 'Validation error: $errorMessage', validationErrors: validationErrors);
      case 429:
        throw ApiException(429, 'Too many requests: Please wait before trying again');
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
  
  static Future<Map<String, dynamic>> get(String endpoint, {String? token, Map<String, String>? queryParams}) async {
    try {
      var uri = Uri.parse('$baseUrl$endpoint');
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }
      final response = await http.get(uri, headers: _getHeaders(token: token)).timeout(timeout);
      return handleResponse(response);
    } on http.ClientException catch (e) {
      throw ApiException(0, 'Network error: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(0, 'Connection failed: Please check your internet');
    }
  }
  
  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body, {String? token}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(token: token),
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
  
  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body, {String? token}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(token: token),
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
  
  static Future<Map<String, dynamic>> delete(String endpoint, {String? token}) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(token: token),
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