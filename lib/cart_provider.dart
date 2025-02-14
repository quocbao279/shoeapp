import 'package:flutter/material.dart';

class CartItem {
  String name;
  double price;
  int quantity;
  String image;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });
}

class CartProvider with ChangeNotifier {
  List<CartItem> cartItems = [];

  // Add item to cart
  void addToCart(CartItem item) {
    // Check if item already exists in the cart
    int index = cartItems.indexWhere((cartItem) => cartItem.name == item.name);
    if (index >= 0) {
      // Increment quantity if item exists
      cartItems[index].quantity += item.quantity;
    } else {
      // Add new item to cart
      cartItems.add(item);
    }
    notifyListeners();
  }

  // Remove item from cart
  void removeItem(int index) {
    cartItems.removeAt(index);
    notifyListeners();
  }

  // Increment item quantity
  void incrementQuantity(int index) {
    cartItems[index].quantity++;
    notifyListeners();
  }

  // Decrement item quantity
  void decrementQuantity(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
    } else {
      // Optionally remove the item if quantity reaches 0
      cartItems.removeAt(index);
    }
    notifyListeners();
  }

  // Get total cart price
  double getCartTotal() {
    double total = 0.0;
    for (var item in cartItems) {
      // Convert the string price to double for calculation
      total += item.price * item.quantity;
    }
    return total;
  }

  // Clear all items in the cart
  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }
}


