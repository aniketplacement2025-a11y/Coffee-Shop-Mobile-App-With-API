// cart_page_body.dart
// import 'package:flutter/material.dart';
//
// class CartPageBody extends StatelessWidget {
//   const CartPageBody({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.all(30.0),
//         child: Center(
//           child: Text(
//             'Your Cart Items Will Appear Here',
//             style: TextStyle(color: Colors.white, fontSize: 18),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     );
//   }
// }

// Have UI But Static 'cart_page_body.dart'
// import 'package:flutter/material.dart';
//
// class CartPageBody extends StatelessWidget {
//   const CartPageBody({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Simulate a list of cart items (replace with actual data from your app state)
//     List<Map<String, dynamic>> cartItems = [
//       {
//         'name': 'Caffe Mocha',
//         'type': 'Deep Foam',
//         'price': 4.53,
//         'quantity': 1,
//       },
//       {
//         'name': 'Flat White',
//         'type': 'Espresso',
//         'price': 3.53,
//         'quantity': 1,
//       },
//     ];
//
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(30.0),
//         child: cartItems.isEmpty
//             ? _buildEmptyCart(context)
//             : Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Your Cart',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF2F4B4E),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ...cartItems.map((item) => _buildCartItem(item)).toList(),
//             const SizedBox(height: 20),
//             _buildCheckoutButton(context),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyCart(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.shopping_cart_outlined,
//             size: 80,
//             color: Colors.grey[400],
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'Your Cart is Empty',
//             style: TextStyle(
//               fontSize: 18,
//               color: Colors.grey,
//               fontWeight: FontWeight.w500,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             'Add some delicious coffee to get started!',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               // Navigate back to home page or refresh tab
//               // Example: Navigator.pop(context) or tab change logic
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFC67C4E),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             child: const Text(
//               'Browse Coffee',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCartItem(Map<String, dynamic> item) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 15),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item['name'],
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF2F4B4E),
//                   ),
//                 ),
//                 Text(
//                   item['type'],
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 Text(
//                   '\$${item['price'].toStringAsFixed(2)}',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: Color(0xFF2F4B4E),
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.remove, color: Color(0xFFC67C4E)),
//                   onPressed: () {
//                     // Logic to decrease quantity
//                   },
//                 ),
//                 Text(
//                   item['quantity'].toString(),
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.add, color: Color(0xFFC67C4E)),
//                   onPressed: () {
//                     // Logic to increase quantity
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () {
//                     // Logic to remove item
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCheckoutButton(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         // Navigate to checkout page
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xFFC67C4E),
//         minimumSize: const Size(double.infinity, 50),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       child: const Text(
//         'Proceed to Checkout',
//         style: TextStyle(color: Colors.white, fontSize: 16),
//       ),
//     );
//   }
// }


// COMPLTETE DYNAMIC CART PAGE
// cart_page_body.dart
import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../models/coffee_model.dart';
import '../screen/home_page.dart';

class CartPageBody extends StatefulWidget {
  const CartPageBody({super.key});

  @override
  State<CartPageBody> createState() => _CartPageBodyState();
}

class _CartPageBodyState extends State<CartPageBody> {
  final CartService _cartService = CartService(); // This gets the singleton
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState(){ // Fixed the typo
    super.initState();
    _initializeCart();
  }

  Future<void> _initializeCart() async {
    try {
      print('Starting cart initalization...');
      await _cartService.initializeCart();
      print('Cart initialized successfully');

      setState(() {
        _isLoading = false;
      });
    } catch(e){
      print('Error inititalizing cart: $e');
      setState(() {
        _errorMessage = 'Failed to load cart: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshCart() async {
    setState(() {
      _isLoading = true;
    });
    await _initializeCart();
  }

  @override
  Widget build(BuildContext context) {
    if(_isLoading){
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC67C4E)),
        ),
      );
    }

    if(_errorMessage.isNotEmpty){
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
              onPressed: _refreshCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC67C4E),
              ),
             child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        )
      );
    }

    final cartItems = _cartService.cartItems;
    final totalPrice = _cartService.totalPrice;

    return RefreshIndicator(
        onRefresh: _refreshCart,
      child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: cartItems.isEmpty
            ? _buildEmptyCart(context)
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   'Your Cart',
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //     color: Color(0xFF2F4B4E),
            //   ),
            // ),
            const SizedBox(height: 10),
            ...cartItems.map((item) => _buildCartItem(item)).toList(),
            const SizedBox(height: 20),
            _buildTotalSection(totalPrice),
            const SizedBox(height: 20),
            _buildCheckoutButton(context),
          ],
        ),
      ), ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          const Text(
            'Your Cart is Empty',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Add some delicious coffee to get started!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC67C4E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Browse Coffee',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Coffee item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Coffee info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2F4B4E),
                    ),
                  ),
                  Text(
                    '${item.subtitle} • Size: ${item.selectedSize}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2F4B4E),
                    ),
                  ),
                ],
              ),
            ),

            // Quantity controls
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Color(0xFFC67C4E)),
                  onPressed: () async {
                    setState(() {
                      _cartService.updateQuantity(
                          item.id,
                          item.selectedSize,
                          item.quantity - 1,
                      );
                    });
                  },
                ),
                Text(
                  item.quantity.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Color(0xFFC67C4E)),
                  onPressed: () async {
                    setState(() {
                      _cartService.updateQuantity(
                          item.id,
                          item.selectedSize,
                          item.quantity + 1,
                      );
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    setState(() {
                      _cartService.removeFromCart(item.id, item.selectedSize);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection(double totalPrice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Subtotal:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F4B4E),
            ),
          ),
          Text(
            '\$${totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F4B4E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(
            context,
            '/order');

        // Navigate to checkout page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proceeding to checkout...'),
            backgroundColor: Color(0xFFC67C4E),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFC67C4E),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'Proceed to Checkout',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
