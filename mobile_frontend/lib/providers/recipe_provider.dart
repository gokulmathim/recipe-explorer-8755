import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';

/// Provides recipe data, including list, search and detail fetches.
// PUBLIC_INTERFACE
class RecipeProvider extends ChangeNotifier {
  final APIService _api = APIService();
  List<Recipe> _recipes = [];
  bool _loading = false;
  String? _error;

  void setAuthToken(String? token) {
    _api.setToken(token);
  }

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _loading;
  String? get error => _error;

  // PUBLIC_INTERFACE
  Future<void> fetchRecipes({String? query, Map<String, String>? filters}) async {
    _setLoading(true);
    try {
      final params = <String, dynamic>{};
      if (query != null && query.isNotEmpty) params['q'] = query;
      if (filters != null) params.addAll(filters);
      final res = await _api.get('/recipes', params.isEmpty ? null : params);
      final list = (res['data'] ?? res['recipes'] ?? res) as dynamic;
      _recipes = (list as List).map((e) => Recipe.fromJson(e as Map<String, dynamic>)).toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // PUBLIC_INTERFACE
  Future<Recipe?> fetchRecipeDetail(String id) async {
    try {
      final res = await _api.get('/recipes/$id');
      final data = (res['data'] ?? res['recipe'] ?? res) as Map<String, dynamic>;
      return Recipe.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
