import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../services/api_service.dart';

class CartProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  List<Cart> _cartItems = [];
  bool _loading = false;
  String? _error;

  List<Cart> get cartItems => _cartItems;
  bool get isLoading => _loading;
  String? get error => _error;
  int get cartCount => _cartItems.length;
  double get totalPrice => _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  Future<void> init() async {
    await loadCart();
  }

  Future<void> loadCart() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final apiCart = await _api.fetchCart();
      _cartItems = apiCart;
    } catch (e) {
      _error = 'Failed to load cart: ${e.toString()}';
      _cartItems = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> addToCart(Cart cart) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final addedCart = await _api.addToCart(cart);
      if (addedCart != null) {
        // Check if item exists, update quantity
        final existingIndex = _cartItems.indexWhere(
          (c) => c.idProduct == cart.idProduct && c.color == cart.color
        );
        
        if (existingIndex != -1) {
          _cartItems[existingIndex] = Cart(
            idCart: addedCart.idCart,
            imgProduct: addedCart.imgProduct,
            nameProduct: addedCart.nameProduct,
            color: addedCart.color,
            quantity: _cartItems[existingIndex].quantity + cart.quantity,
            idProduct: addedCart.idProduct,
            price: addedCart.price,
          );
        } else {
          _cartItems.add(addedCart);
        }
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Failed to add to cart: ${e.toString()}';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> removeFromCart(Cart cart) async {
    if (cart.idCart == null) return false;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _api.removeFromCart(cart.idCart!);
      if (success) {
        _cartItems.removeWhere((c) => c.idCart == cart.idCart);
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Failed to remove from cart: ${e.toString()}';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> updateQuantity(Cart cart, int newQuantity) async {
    if (cart.idCart == null) return false;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedCart = await _api.updateCartQuantity(cart.idCart!, newQuantity);
      if (updatedCart != null) {
        final index = _cartItems.indexWhere((c) => c.idCart == cart.idCart);
        if (index != -1) {
          _cartItems[index] = updatedCart;
        }
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Failed to update quantity: ${e.toString()}';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    _loading = true;
    notifyListeners();

    try {
      for (final cart in _cartItems) {
        if (cart.idCart != null) {
          await _api.removeFromCart(cart.idCart!);
        }
      }
      _cartItems.clear();
    } catch (e) {
      _error = 'Failed to clear cart: ${e.toString()}';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
