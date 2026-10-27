import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/auth_controller.dart';

class ApiService {
  static const String baseUrl = 'https://kirana-mitra-3.onrender.com';
  static const Duration timeoutDuration = Duration(seconds: 40);

  // Helper to get headers with Authorization Bearer token (with fallback dev token)
  static Future<Map<String, String>> _getHeaders() async {
    final headers = {'Content-Type': 'application/json'};
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      } else {
        headers['Authorization'] = 'Bearer mock_jwt_token_for_development';
      }
    } catch (e) {
      debugPrint('Error loading auth token from SharedPreferences: $e');
      headers['Authorization'] = 'Bearer mock_jwt_token_for_development';
    }
    return headers;
  }

  // GET Request
  static Future<dynamic> get(String endpoint, {bool isRetry = false}) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      ).timeout(timeoutDuration);

      if (response.statusCode == 401 && !isRetry) {
        debugPrint('Received 401 in GET [$endpoint]. Refreshing token and retrying...');
        final refreshed = await AuthController.refreshBackendToken();
        if (refreshed) {
          return await get(endpoint, isRetry: true);
        }
      }
      return _handleResponse(response);
    } catch (e) {
      debugPrint('GET Request Failed [$endpoint]: $e');
      throw Exception('GET Request Failed: $e');
    }
  }

  // POST Request
  static Future<dynamic> post(String endpoint, Map<String, dynamic> data, {bool isRetry = false}) async {
    try {
      final headers = await _getHeaders();
      debugPrint('POST Request [$baseUrl$endpoint] with data: $data');
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      ).timeout(timeoutDuration);

      if (response.statusCode == 401 && !isRetry) {
        debugPrint('Received 401 in POST [$endpoint]. Refreshing token and retrying...');
        final refreshed = await AuthController.refreshBackendToken();
        if (refreshed) {
          return await post(endpoint, data, isRetry: true);
        }
      }
      return _handleResponse(response);
    } catch (e) {
      debugPrint('POST Request Failed [$endpoint]: $e');
      throw Exception('POST Request Failed: $e');
    }
  }

  // PUT Request
  static Future<dynamic> put(String endpoint, Map<String, dynamic> data, {bool isRetry = false}) async {
    try {
      final headers = await _getHeaders();
      debugPrint('PUT Request [$baseUrl$endpoint] with data: $data');
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      ).timeout(timeoutDuration);

      if (response.statusCode == 401 && !isRetry) {
        debugPrint('Received 401 in PUT [$endpoint]. Refreshing token and retrying...');
        final refreshed = await AuthController.refreshBackendToken();
        if (refreshed) {
          return await put(endpoint, data, isRetry: true);
        }
      }
      return _handleResponse(response);
    } catch (e) {
      debugPrint('PUT Request Failed [$endpoint]: $e');
      throw Exception('PUT Request Failed: $e');
    }
  }

  // DELETE Request
  static Future<dynamic> delete(String endpoint, {bool isRetry = false}) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      ).timeout(timeoutDuration);

      if (response.statusCode == 401 && !isRetry) {
        debugPrint('Received 401 in DELETE [$endpoint]. Refreshing token and retrying...');
        final refreshed = await AuthController.refreshBackendToken();
        if (refreshed) {
          return await delete(endpoint, isRetry: true);
        }
      }
      return _handleResponse(response);
    } catch (e) {
      debugPrint('DELETE Request Failed [$endpoint]: $e');
      throw Exception('DELETE Request Failed: $e');
    }
  }

  static dynamic _handleResponse(http.Response response) {
    debugPrint('API Response [${response.statusCode}]: ${response.body}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body);
    } else {
      throw Exception('API Error [${response.statusCode}]: ${response.body}');
    }
  }
}
