import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coffee_model.dart';

class CoffeeApiService{
  static const String baseUrl = 'http://localhost:3002';

  //Get all coffees
  static Future<List<Coffee>> getAllCoffees() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/coffees'));
      if (response.statusCode == 200){
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> coffeesJson = data['coffees'];
        return coffeesJson.map((json) => Coffee.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load coffees');
      }
    } catch(e){
      throw Exception('Failed to connect to API: $e');
    }
  }

  //Get coffee by ID
  static Future<Coffee> getCoffeeById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/Coffees/$id'));
      if(response.statusCode == 200){
        final Map<String,dynamic> coffeeJson = json.decode(response.body);
        return Coffee.fromJson(coffeeJson);
      }
      else throw Exception('Failed to load coffee');
    }catch(e){ throw Exception('Failed to connect to API: $e');
    }
  }

  //Get coffees by category
  static Future<List<Coffee>> getCoffeesByCategory(String category) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/coffees/category/$category'));
      if(response.statusCode == 200){
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> coffeesJson = data['coffees'];
        return coffeesJson.map((json) => Coffee.fromJson(json)).toList();
      }else throw Exception('Failed to load coffees by category');
    }catch(e){
      throw Exception('Failed to connect to API: $e');
    }
  }

  //Get all Categories
  static Future<List<String>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories'));
      if(response.statusCode == 200){
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> categoriesJson = data['categories'];
        return categoriesJson.map((category) => category.toString()).toList();
      }else throw Exception('Failed to load categories');
    }catch(e){
      throw Exception('Failed to connect to API:$e');
    }
  }


// Toggle favorite status for a coffee
  static Future<bool> toggleFavorite(int coffeeId, bool isFavorite) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/coffees/$coffeeId/favorite'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'isFavorite': isFavorite}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['success'] ?? false;
      } else {
        throw Exception('Failed to update favorite status');
      }
    } catch (e) {
      throw Exception('Failed to connect to API: $e');
    }
  }

// Get all favorite coffees
  static Future<List<Coffee>> getFavoriteCoffees() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/coffees/favorites'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> coffeesJson = data['coffees'];
        return coffeesJson.map((json) => Coffee.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load favorite coffees');
      }
    } catch (e) {
      throw Exception('Failed to connect to API: $e');
    }
  }
}