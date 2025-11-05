// services/cart_service.dart
import '../models/coffee_model.dart';
import 'cart_api_service.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  List<Coffee> _cartItems = [];
  bool _isInitialized = false;

  List<Coffee> get cartItems => _cartItems;

  //Initialize cart from server
  Future<void> initializeCart() async {
    if(!_isInitialized){
      try{
        print('Fetching cart items from server...');
        _cartItems = await CartApiService.getCartItems();
        print('Cart items loaded: ${_cartItems.length}');
        _isInitialized = true;
      } catch(e){
        print('Error initializing cart: $e');
        _cartItems = []; //Fallback to empty cart
        _isInitialized = true; //Make sure to set this even on error
        rethrow; // re-throw to let the UI handle the error
      }
    } else {
      print('Cart already initialized');
    }
  }

  // Add coffee to cart (both locally and on server)
  void addToCart(Coffee coffee, {String size = 'M', required String price}) async {
    // First check if item exist locally
    print('Print the Full Coffee Widget : $coffee \n');
    print('Print the size of Coffee : $size \n');
    print('Print the price of the Coffee : $price');

    final existingIndex = _cartItems.indexWhere(
            (item) => item.id == coffee.id && item.selectedSize == size && item.price == price
    );

    if (existingIndex != -1) {
      // Update quantity if same coffee with same size exists
      final newQuantity = _cartItems[existingIndex].quantity +1;
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
          quantity: newQuantity
      );

      //Update on server
      await CartApiService.updateQuantity(coffee.id, size, newQuantity);
    } else {
      // Add new item to cart
      final newItem = coffee.copyWith(
        quantity: 1,
        selectedSize: size,
        price: double.parse(price), // Keep original price for calculations
      );
      _cartItems.add(newItem);

      //Add to server
      await CartApiService.addToCart(coffee.id, size, 1, price);
    }
  }

  // Remove coffee from cart (both locally and on server)
  Future<void> removeFromCart(int coffeeId, String size) async {
    _cartItems.removeWhere(
            (item) => item.id == coffeeId && item.selectedSize == size
    );

    // Remove from server
    await CartApiService.removeFromCart(coffeeId, size);
  }

  // Update quantity (both locally and on server)
  Future<void> updateQuantity(int coffeeId, String size, int newQuantity) async {
    // First check if item exist locally
    print('Update Print the Full Coffee Widget : $coffeeId \n');
    print('Update Print the size of Coffee : $size \n');

    final index = _cartItems.indexWhere(
            (item) => item.id == coffeeId && item.selectedSize == size
    );

    if (index != -1) {
      if (newQuantity <= 0) {
        //_cartItems.removeAt(index);
        print('Remove $coffeeId');
        await removeFromCart(coffeeId, size);
      } else {
        print('Add $coffeeId');
        _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
        await CartApiService.updateQuantity(coffeeId, size, newQuantity);
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
  Future<void> clearCart() async {
    _cartItems.clear();
    await CartApiService.clearCart();
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

  //Refresh cart from server
  Future<void> refreshCart() async {
    try{
      _cartItems = await CartApiService.getCartItems();
    } catch(e){
      print('Error refreshing cart: $e');
    }
  }
}