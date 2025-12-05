import 'package:flutter/material.dart';
import '../models/favorite_model.dart';
import '../services/api_service.dart';

class FavoriteProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  List<Favorite> _favorites = [];
  bool _loading = false;
  String? _error;

  List<Favorite> get favorites => _favorites;
  bool get isLoading => _loading;
  String? get error => _error;
  int get favoriteCount => _favorites.length;

  bool isFavorite(String productId) {
    return _favorites.any((f) => f.idProduct == productId);
  }

  Future<void> init() async {
    await loadFavorites();
  }

  Future<void> loadFavorites() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final apiFavorites = await _api.fetchFavorites();
      _favorites = apiFavorites;
    } catch (e) {
      _error = 'Failed to load favorites: ${e.toString()}';
      _favorites = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleFavorite(Favorite favorite) async {
    final isFav = isFavorite(favorite.idProduct);
    
    if (isFav) {
      return await removeFavorite(favorite);
    } else {
      return await addFavorite(favorite);
    }
  }

  Future<bool> addFavorite(Favorite favorite) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final added = await _api.addFavorite(favorite);
      if (added != null) {
        _favorites.add(added);
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Failed to add favorite: ${e.toString()}';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> removeFavorite(Favorite favorite) async {
    if (favorite.idFavorite == null) return false;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _api.removeFavorite(favorite.idFavorite!);
      if (success) {
        _favorites.removeWhere((f) => f.idFavorite == favorite.idFavorite);
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Failed to remove favorite: ${e.toString()}';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> clearFavorites() async {
    _loading = true;
    notifyListeners();

    try {
      for (final fav in _favorites) {
        if (fav.idFavorite != null) {
          await _api.removeFavorite(fav.idFavorite!);
        }
      }
      _favorites.clear();
    } catch (e) {
      _error = 'Failed to clear favorites: ${e.toString()}';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
