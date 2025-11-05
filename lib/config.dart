import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';

class AppConfig {
  static String? _cachedBaseUrl;

  static Future<String> get baseUrl async {
    // Return cached URL if already determined
    if (_cachedBaseUrl != null){
      print('Using cached base URL: $_cachedBaseUrl');
      return _cachedBaseUrl!;
    }

    // Determine the best base URL based on platform
    _cachedBaseUrl = await _determineBaseUrl();
    print('Determined base URL: $_cachedBaseUrl');
    return _cachedBaseUrl!;
  }

  static Future<String> _determineBaseUrl() async {
    print("Detecting Platform...");
    // For web platform
    if (kIsWeb) {
      print('Platform: Web');
      return 'http://localhost:3002';
    }

    // For mobile platforms
    final possibleUrls = await _getPossibleUrlsForPlatform();

    // Try each URL to see which one works
    for (final url in await possibleUrls) {
      if (await _testConnection(url)) {
        print('✅ Using API server at: $url');
        return url;
      }
    }

    // Fallback to the most likely URL
    print('⚠️  Could not detect server, using fallback URL');
    return possibleUrls.first;
  }

  static Future<List<String>> _getPossibleUrlsForPlatform() async {
    final urls = <String>[];

    if (Platform.isAndroid) {
      print('Platform: Android');
      // Standart Android emulator alias (ALWAYS works in emulators)
      urls.add('http://10.0.2.2:3002');

      // Try to get your actual System IP
      try {
        final networkInfo = NetworkInfo();
        final wifiIP = await networkInfo.getWifiIP();
        if(wifiIP != null && wifiIP != '127.0.0.1'){
          urls.add('http://$wifiIP:3002');
          print('Found system IP: $wifiIP');
        }
      } catch(e){
        print('Could not get system IP: $e');
      }
      // if _getPossibleUrlsForPlatform() return type is 'List<String>'.
      // return [
      //   'http://10.0.2.2:3002',  // Android emulator
      // ];

      //Common local IP ranges
      urls.addAll([
        'http://localhost:3002',
        'http://127.0.0.1:3002',
        'http://192.168.1.100:3002', // Common home network IP
        'http://192.168.0.100:3002', // Another common range
      ]);
    } else {
      print('Platform: Desktop');
      urls.add('http://localhost:3002');
    }

    print('Testing URLs: $urls');
    return urls;
  }

  static Future<bool> _testConnection(String baseUrl) async {
    try {
      final url = await baseUrl;
      print("Testing connection to: $url");

      final response = await http.get(
        Uri.parse('$url/'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 3));

      print('Connection test result: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Connection test failed for $baseUrl: $e');
      return false;
    }
  }

    //Helper method to use in API calls
    static Future<String> getEndpoint(String endpoint) async {
      final base = await baseUrl;
      return '$base$endpoint';
    }

    //static  Future<String> baseUrl = 'http://localhost:3002';

    //I Adding Here 'cart_api_service.dart' ants
    static Future<String> get cart async => await getEndpoint('/cart');

    static Future<String> get addToCart async => await getEndpoint('/cart/add');

    static Future<String> get removeFromCart async =>
    await getEndpoint('/cart/remove');

    static Future<String> get updateQuantity async =>
    await getEndpoint('/cart/update');

    static Future<String> get clearCart async => await getEndpoint('/cart/clear');

    // Adding Here 'coffee_api_service.dart' ants
    static Future<String> get getAllCoffees async =>
    await getEndpoint('/coffees');

    //Coffee endpoints
    static Future<String> get coffees async => await getEndpoint('/coffees');

    //Method to generate coffee with parameter endpoint
    static Future<String> getCoffeesByCategory(String category) async =>
    await getEndpoint('/coffees/category/$category');

    static Future<String> getCoffeeById(int id) async =>
    await getEndpoint('/coffees/$id');

    static Future<String> get getCategories async =>
    await getEndpoint('/categories');

    static Future<String> toggleFavorite(int coffeeId, bool isFavorite) async =>
    await getEndpoint('/coffees/$coffeeId/favorite');

    static Future<String> get getFavoriteCoffees async =>
    await getEndpoint('/coffees/favorites');
  }
