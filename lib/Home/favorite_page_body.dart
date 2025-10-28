// favorite_page_body.dart
import 'package:flutter/material.dart';
import '../models/coffee_model.dart';
import 'coffee_card.dart';
import '../services/coffee_api_service.dart';

class FavoritePageBody extends StatefulWidget {
  const FavoritePageBody({super.key});

  @override
  State<FavoritePageBody> createState() => _FavoritePageBodyState();
}

class _FavoritePageBodyState extends State<FavoritePageBody> {
  List<Coffee> _favoriteCoffees = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadFavoriteCoffees();
  }

  Future<void> _loadFavoriteCoffees() async {
    try {
      // Get all coffees first
      final allCoffees = await CoffeeApiService.getAllCoffees();

      // Filter only favorites
      final favoriteCoffees = allCoffees.where((coffee) => coffee.isFavorite).toList();

      setState(() {
        _favoriteCoffees = favoriteCoffees;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load favorite coffees: $e';
        _isLoading = false;
      });
      print('Error loading favorite coffees: $e');
    }
  }

  // This method will be called when a coffee is unfavorited
  void _onFavoriteToggle() {
    // Reload favorites to reflect the changes
    _loadFavoriteCoffees();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC67C4E)),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFavoriteCoffees,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC67C4E),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (_favoriteCoffees.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Text(
            'You haven\'t added any favorites yet',
            style: TextStyle(color: Colors.grey, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          children: [
            // // Header text
            // const Text(
            //   'Your Favorite Coffees',
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //     color: Color(0xFF2F2D2C),
            //   ),
            // ),
            const SizedBox(height: 10),

            // Grid of favorite coffees
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 270,
                crossAxisSpacing: 15,
                mainAxisSpacing: 20,
                childAspectRatio: 0.60,
              ),
              itemCount: _favoriteCoffees.length,
              itemBuilder: (context, index) {
                final coffee = _favoriteCoffees[index];
                return CoffeeCard(
                  coffee: coffee,
                  isFavorite: true, // Pass true since these are favorites
                  onFavoriteToggle: _onFavoriteToggle, // Callback to refresh list
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}