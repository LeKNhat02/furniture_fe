// DEPRECATED: SQLite has been removed. All data now comes from FastAPI backend.
// This file is kept only for backward compatibility with existing screens.
// Please update screens to use Provider pattern instead of direct DatabaseHandler calls.

class DatabaseHandler {
  // Empty implementation - all methods now throw deprecated warnings
  
  Future<void> initializeDB() async {
    // No-op: Database initialization removed
    return;
  }
  
  Future<void> retrieveCarts() async {
    throw Exception('DatabaseHandler deprecated: Use CartProvider instead');
  }
  
  Future<void> retrieveFavorites() async {
    throw Exception('DatabaseHandler deprecated: Use FavoriteProvider instead');
  }
  
  Future<void> retrieveUser() async {
    throw Exception('DatabaseHandler deprecated: Use UserProvider instead');
  }
  
  Future<void> retrieveHisSearch() async {
    throw Exception('DatabaseHandler deprecated: Use appropriate provider');
  }
  
  List get listCart => [];
  List get listFavorite => [];
  List get listUser => [];
  List get listHistorySearch => [];
  
  Future<int> insertCart(dynamic cart) async {
    throw Exception('DatabaseHandler deprecated: Use CartProvider.addToCart() instead');
  }
  
  Future<int> insertFavorite(dynamic favorite) async {
    throw Exception('DatabaseHandler deprecated: Use FavoriteProvider.addFavorite() instead');
  }
  
  Future<int> deleteCart(int id) async {
    throw Exception('DatabaseHandler deprecated: Use CartProvider.removeFromCart() instead');
  }
  
  Future<int> deleteFavorite(int id) async {
    throw Exception('DatabaseHandler deprecated: Use FavoriteProvider.removeFavorite() instead');
  }
  
  Future<int> updateCart(int id, int quantity) async {
    throw Exception('DatabaseHandler deprecated: Use CartProvider.updateQuantity() instead');
  }
}
