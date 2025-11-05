import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coffee_model.dart';
import '../config.dart';

class CartApiService {
  //static const String baseUrl = 'http://localhost:3002';

  //Get cart items from server
  static Future<List<Coffee>> getCartItems() async {
    try {
      final url = await AppConfig.cart;
      final response = await http.get(Uri.parse(url));

      if(response.statusCode == 200){
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> cartJson = data['cart'];

        // Convert cart items back to Coffee objects
        return cartJson.map((item) {
          //The server returns the full coffee object in 'coffee' field

          final coffeeData = item['coffee'] ?? {};

          //Handle price conversion- it might come as String from server
          dynamic priceValue = item['price'] ?? coffeeData['price'] ?? 0.0;
          double price;

          if(priceValue is String){
            //Convert string to double
            price = double.tryParse(priceValue) ?? 0.0;
          } else if(priceValue is int){
            // Convert int to double
            price = priceValue.toDouble();
          } else {
            // It's already double or null
            price = (priceValue as num?)?.toDouble() ?? 0.0;
          }

          return Coffee.fromJson({
            ...coffeeData,
            'quantity': item['quantity'] ?? 1,
            'selectedSize': item['size'] ?? 'M',
            'price': price, // Use the converted double value
          });
        }).toList();
        } else {
        throw Exception('Failed to load cart items');
      }} catch(e){
      throw Exception('Failed to connect to API: $e');
      }
    }

    // Add item to cart on server
    static Future<bool> addToCart(int coffeeId, String size, int quantity, String price) async {
     try {
       final url = await AppConfig.addToCart;

       final response = await http.post(
         Uri.parse(url),
         headers: {'Content-Type': 'application/json'},
         body: json.encode({
          'coffeeId': coffeeId,
          'size': size,
          'quantity': quantity,
           'price': price,
         }),
       );

       if(response.statusCode == 200){
         final Map<String, dynamic> data = json.decode(response.body);
         return data['success'] ?? false;
       } else {
         throw Exception('Failed to add item to cart');
       }
     } catch(e){
       throw Exception('Falied to connect to API: $e');
     }
    }

    //Remove item cart on server
    static Future<bool> removeFromCart(int coffeeId, String size) async {
    try {
      final url = await AppConfig.removeFromCart;

      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'coffeeId': coffeeId,
          'size': size,
        }),
      );

      if(response.statusCode == 200){
        final Map<String, dynamic> data = json.decode(response.body);
        return data['success'] ?? false;
      } else {
        throw Exception('Failed to remove item from cart');
      }
     } catch(e){
      throw Exception('Failed to connect to API: $e');
     }
    }

    // Update quantity on server
   static Future<bool> updateQuantity(int coffeeId, String size, int quantity) async {
    try {
      final url = await AppConfig.updateQuantity;

      final response = await http.put(
       Uri.parse(url),
       headers: {'Content-Type':'application/json'},
       body: json.encode({
         'coffeeId': coffeeId,
         'size': size,
         'quantity': quantity,
       }),
      );

      if(response.statusCode == 200){
        final Map<String, dynamic> data = json.decode(response.body);
        return data['success'] ?? false;
      } else {
        throw Exception('Failed to update quantity');
      }
    } catch(e){
      throw Exception('Failed to connect to API: $e');
    }
  }

  // Clear entire cart on server
  static Future<bool> clearCart() async {
    try{
      final url = await AppConfig.clearCart;
      final response = await http.delete(Uri.parse(url));

      if(response.statusCode == 200){
        final Map<String, dynamic> data = json.decode(response.body);
        return data['success'] ?? false;
      } else {
        throw Exception('Failed to clear cart');
      }
    } catch(e){
      throw Exception('Failed to connect to API: $e');
    }
  }
}