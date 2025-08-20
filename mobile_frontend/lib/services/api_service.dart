import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// APIService abstracts HTTP requests to the backend.
/// It reads BASE_URL from .env and supports authenticated calls.
/// Errors are thrown with descriptive messages.
// PUBLIC_INTERFACE
class APIService {
  /// Create an APIService with optional auth token.
  APIService({String? token}) : _token = token;

  String? _token;

  /// Set or update the bearer token when user logs in.
// PUBLIC_INTERFACE
  void setToken(String? token) {
    _token = token;
  }

  String get _baseUrl {
    final url = dotenv.env['API_BASE_URL'] ?? '';
    if (url.isEmpty) {
      throw Exception('API_BASE_URL is not set in .env');
    }
    return url;
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null && _token!.isNotEmpty) 'Authorization': 'Bearer $_token',
      };

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final base = _baseUrl.endsWith('/') ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
    final p = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$base$p').replace(queryParameters: query?.map((k, v) => MapEntry(k, v?.toString())));
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final res = await http.post(_uri(path), headers: _headers, body: jsonEncode(body));
    return _parseResponse(res);
  }

  Future<Map<String, dynamic>> get(String path, [Map<String, dynamic>? query]) async {
    final res = await http.get(_uri(path, query), headers: _headers);
    return _parseResponse(res);
  }

  Map<String, dynamic> _parseResponse(http.Response res) {
    final status = res.statusCode;
    final decoded = (res.body.isNotEmpty) ? jsonDecode(res.body) : {};
    if (status >= 200 && status < 300) {
      return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
    }
    final message = decoded is Map && decoded['message'] != null ? decoded['message'] : 'Request failed ($status)';
    throw Exception(message);
  }
}
