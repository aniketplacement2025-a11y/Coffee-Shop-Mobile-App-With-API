// coffee_card.dart
import 'package:coffe_application_ui_figma/services/coffee_api_service.dart';
import 'package:flutter/material.dart';
import '../models/coffee_model.dart';
import 'dart:ui';

class CoffeeCard extends StatelessWidget {
  final Coffee coffee;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const CoffeeCard({super.key,
    required this.coffee,
    this.isFavorite = false,
    this.onFavoriteToggle
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/detail',
          arguments: coffee,
        );
      },
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: Image.asset(
                    coffee.imagePath,
                    height: 160,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    // IMPROVED ERROR BUILDER TO SHOW MORE INFO
                    errorBuilder: (context, error, stackTrace) {
                      print('Image error: $error');
                      print('Image path: ${coffee.imagePath}');
                      return Container(
                        color: Colors.grey[300],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.broken_image,
                                color: Colors.grey, size: 40),
                            const SizedBox(height: 8),
                            Text(
                              'Image not found',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              coffee.imagePath,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Positioned(top: 8, left: 8, child: StarRating(rating: coffee.rating)),
                // Favorite heart on top-right
                Positioned(top: 8, right: 8, child: FavoriteHeart(
                    coffeeId: coffee.id,
                    initialFavorite: isFavorite,
                    onFavoriteToggle: onFavoriteToggle)
                ),
              ],
            ),


            // Content Section - No fixed height, let it take only needed space
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(coffee.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Color(0xFF2F2D2C))),
                  const SizedBox(height: 4),
                  Text(coffee.subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF9B9B9B))),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$ ${coffee.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Color(0xFF2F4B4E))),
                      const AddButton(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteHeart extends StatefulWidget {
  final int coffeeId;
  final bool initialFavorite;
  final VoidCallback? onFavoriteToggle;

  const FavoriteHeart({
    super.key,
    required this.coffeeId,
    this.initialFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  State<FavoriteHeart> createState() => _FavoriteHeartState();
}

class _FavoriteHeartState extends State<FavoriteHeart>{
  //local state to track favorite status
  late bool _isFavorite;
   bool _isLoading = false;

  @override
  void initState(){
    super.initState();
    //Initialize with the provided initial State
    _isFavorite = widget.initialFavorite;
  }

  // //Method to load favorite state from SharedPreferences or local storage
  // Future<void> _loadFavoriteState() async {
  //   //We can implement local storage here later
  //   //For now, we'll just use the initial state
  // }
  //
  // //Method to save favorite state to local storage
  // Future<void> _saveFavoriteState() async {
  //   //U can implement local storage saving here later
  //   //Example with SharedPreferences:
  //   //final prefs = await SharedPreferences.getInstance();
  //   //await prefs.setBool('favorite_${widget.coffeeId}', _isFavorite);
  // }

  Future<void> _toggleFavorite() async{
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

   try {
     final newFavoriteStatus = !_isFavorite;
     final success = await CoffeeApiService.toggleFavorite(
         widget.coffeeId,
         newFavoriteStatus
     );
     if (success) {
       setState(() {
         _isFavorite = newFavoriteStatus;
       });
       if (widget.onFavoriteToggle != null) {
         widget.onFavoriteToggle!();
           }
         }
     else print('Failed to toggle favorite');
        } catch(e){
      print('Error toggling favorite: $e');
     } finally {
       setState(() {
         _isLoading = false;
       });
     }
    }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : _toggleFavorite,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child:
            _isLoading? const SizedBox(
              width:20,
              height:20,
              child:CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: _isFavorite ? Colors.red : Colors.white,
          size: 20,
        ),
      ),
    );
  }
}


class StarRating extends StatelessWidget {
  final double rating;

  const StarRating({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: Colors.black.withOpacity(0.2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 14),
              SizedBox(width: 4),
              Text(
                  rating.toStringAsFixed(1),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
          color: const Color(0xFFC67C4E),
          borderRadius: BorderRadius.circular(10)),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
