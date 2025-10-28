import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coffee_model.dart';

class CartApiService {
  static const String baseUrl = 'http://localhost:3002';

  //Get cart items from server
  static Future<List<Coffee>> getCartItems() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/cart'));
      if(response.statusCode == 200){
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> cartJson = data['cart'];

        // Convert cart items back to Coffee objects
        return cartJson.map((item) {
          //The server returns the full coffee object in 'coffee' field

          final coffeeData = item['coffee'] ?? {};
          return Coffee.fromJson({
            ...coffeeData,
            'quantity', item['quantity'] ?? 1,
            'selectedSize': item['size'] ?? 'M',
          });
        }).toList();
        } else {
        throw Exception('Failed to load cart items');
      }} catch(e){
      throw Exception('Failed to connect to API: $e');
      }
    }

    // Add item to cart on server
    static Future<bool> addToCart(int coffeeId, String size, int quantity) async {
     try {
       final response = await http.post(
         Uri.parse('$baseUrl/cart/add'),
         headers: {'Content-Type': 'application/json'},
         
       )
     }
    }

    //Add item to cart on server

  }
}