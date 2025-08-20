import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

/// Manages favorites/bookmarked recipes locally using SharedPreferences.
// PUBLIC_INTERFACE
class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {};
  static const _prefsKey = 'favorite_recipes';

  FavoritesProvider() {
    _load();
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  // PUBLIC_INTERFACE
  Future<void> toggleFavorite(Recipe recipe) async {
    if (_favoriteIds.contains(recipe.id)) {
      _favoriteIds.remove(recipe.id);
    } else {
      _favoriteIds.add(recipe.id);
    }
    await _save();
    notifyListeners();
  }

  // PUBLIC_INTERFACE
  Future<List<Recipe>> filterFavorites(List<Recipe> all) async {
    return all.where((r) => _favoriteIds.contains(r.id)).toList();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null && raw.isNotEmpty) {
      final list = (jsonDecode(raw) as List).map((e) => e.toString()).toList();
      _favoriteIds
        ..clear()
        ..addAll(list);
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(_favoriteIds.toList()));
  }
}
