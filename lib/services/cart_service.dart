// services/cart_service.dart
import '../models/coffee_model.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  List<Coffee> _cartItems = [];

  List<Coffee> get cartItems => _cartItems;

  // Add coffee to cart
  void addToCart(Coffee coffee, {String size = 'M'}) {
    final existingIndex = _cartItems.indexWhere(
            (item) => item.id == coffee.id && item.selectedSize == size
    );

    if (existingIndex != -1) {
      // Update quantity if same coffee with same size exists
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
          quantity: _cartItems[existingIndex].quantity + 1
      );
    } else {
      // Add new item to cart
      _cartItems.add(coffee.copyWith(
        quantity: 1,
        selectedSize: size,
      ));
    }
  }

  // Remove coffee from cart
  void removeFromCart(int coffeeId, String size) {
    _cartItems.removeWhere(
            (item) => item.id == coffeeId && item.selectedSize == size
    );
  }

  // Update quantity
  void updateQuantity(int coffeeId, String size, int newQuantity) {
    final index = _cartItems.indexWhere(
            (item) => item.id == coffeeId && item.selectedSize == size
    );

    if (index != -1) {
      if (newQuantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
      }
    }
  }

  // Get total price
  double get totalPrice {
    return _cartItems.fold(0, (total, item) {
      return total + (item.price * item.quantity);
    });
  }

  // Get item count
  int get itemCount {
    return _cartItems.fold(0, (total, item) => total + item.quantity);
  }

  // Clear cart
  void clearCart() {
    _cartItems.clear();
  }

  // Check if coffee is in cart
  bool isInCart(int coffeeId, String size) {
    return _cartItems.any(
            (item) => item.id == coffeeId && item.selectedSize == size
    );
  }

  // Get quantity for specific coffee and size
  int getQuantity(int coffeeId, String size) {
    final item = _cartItems.firstWhere(
          (item) => item.id == coffeeId && item.selectedSize == size,
      orElse: () => Coffee(
        id: 0,
        imagePath: '',
        title: '',
        subtitle: '',
        category: '',
        rating: 0,
        reviewCount: 0,
        description: '',
        necessary_supplies: '',
        necessaryTools: '',
        price: 0,
        isFavorite: false,
        quantity: 0,
      ),
    );
    return item.quantity;
  }
}