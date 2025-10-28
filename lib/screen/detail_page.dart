import 'package:flutter/material.dart';
// import 'package:coffee_shop_mobile_app_design_community_3971357995_f2f/bendis_widget.dart';
// import 'package:coffee_shop_mobile_app_design_community_3971357995_f2f/figma_to_flutter.dart'
//     as f2f;
import 'dart:ui';
import '../models/coffee_model.dart'; // Import from model file
import '../services/cart_service.dart';

class DetailPage extends StatefulWidget {
  final Coffee coffee;

  const DetailPage({
    super.key,
    required this.coffee,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String _selectedSize = 'M';

  //Cart Integration Starts From Here to 'Widget.build(BuildContext context)'
  final CartService _cartService = CartService();

  //Calculate price based on size
  double get _sizeAdjustedPrice {
    switch (_selectedSize) {
      case 'S':
        return widget.coffee.price * 0.8; // 20% less for small
      case 'L':
        return widget.coffee.price * 1.2; //20% more for large
      case 'M':
      default:
        return widget.coffee.price;
    }
  }

  void _addToCart() {
    _cartService.addToCart(
      widget.coffee,
      size: _selectedSize,
    );

    //Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.coffee.title} added to cart!'),
        backgroundColor: const Color(0xFFC67C4E),
      ),
    );

    //Navigate back or to cart
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageSection(context),
                      const SizedBox(height: 20),
                      _buildProductInfoSection(context),
                      const SizedBox(height: 24),
                      _buildDescriptionSection(context),
                      const SizedBox(height: 24),
                      _buildSizeSection(context),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          const Text(
            'Detail',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Image.asset(
        widget.coffee.imagePath,
        //package: 'coffee_shop_mobile_app_design_community_3971357995_f2f',
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 220,
            color: Colors.grey[300],
            child: const Center(
              child: Text('Image Asset Failed to Load',
                  style: TextStyle(color: Colors.red)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.coffee.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.coffee.subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            Row(
              children: [
                _buildIconWithBackground(Icons.coffee),
                const SizedBox(width: 12),
                _buildIconWithBackground(Icons.water_drop),
              ],
            )
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 24),
            const SizedBox(width: 8),
            Text(
              widget.coffee.rating.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Text(
              '(${widget.coffee.reviewCount})',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            style:
            const TextStyle(fontSize: 15, color: Colors.grey, height: 1.5),
            children: [
              TextSpan(text: widget.coffee.description),
              const TextSpan(
                text: ' Read More',
                style: TextStyle(
                  color: Color(0xFFC67C4E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSizeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Size',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSizeChip('S'),
            _buildSizeChip('M'),
            _buildSizeChip('L'),
          ],
        ),
      ],
    );
  }

  Widget _buildSizeChip(String size) {
    final bool isSelected = _selectedSize == size;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = size;
        });
      },
      child: Container(
        width: 90,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF5EE) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFC67C4E) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          size,
          style: TextStyle(
            color: isSelected ? const Color(0xFFC67C4E) : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  //Add to your build method - Add the price display and add to cart button
  Widget _buildPriceAndAddButton() {
    return Column(
      children: [
        Text(
          '\$${_sizeAdjustedPrice.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2F4B4E),
          ),
        ),

        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _addToCart,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC67C4E),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Add to Cart',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Price',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                '\$${widget.coffee.price.toStringAsFixed(2)}', // Now converts double to formatted string
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC67C4E),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // FIX: Pass the current coffee data to OrderPage
              Navigator.pushNamed(
                context,
                '/order',
                arguments: widget.coffee, // This passes the selected coffee
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC67C4E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 16),
            ),
            child: const Text(
              'Buy Now',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconWithBackground(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: const Color(0xFFC67C4E)),
    );
  }
}
