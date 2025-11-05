// screen/order_page.dart
import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../models/coffee_model.dart';

class OrderPage extends StatefulWidget {
  //final Coffee coffee;

  const OrderPage({
    super.key
    //required this.coffee,
  });

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final CartService _cartService = CartService();
  String _deliveryType = 'Deliver';
  bool _hasDiscount = true;
  double _deliveryFee = 2.0;
  double _discountedDeliveryFee = 1.0;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState(){
    super.initState();
    _initializeCart();
  }

  Future<void> _initializeCart() async {
    try {
      await _cartService.initializeCart();
      setState(() {
        _isLoading = false;
      });
    } catch(e){
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
  Widget build(BuildContext context){
    if(_isLoading){
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC67C4E)),
        ),
      ), );
    }

    if(_errorMessage.isNotEmpty){
      return Scaffold(
        body: Center(
          child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
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
          ),
        ),
      );
     }

  final cartItems = _cartService.cartItems;
  final double subtotal = _cartService.totalPrice;
  final double totalPrice = subtotal +
      (_hasDiscount? _discountedDeliveryFee : _deliveryFee);

    // final double totalPrice = widget.coffee.price +
    //     (_hasDiscount ? _discountedDeliveryFee : _deliveryFee);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          'Order',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshCart,
        child: SingleChildScrollView(
         padding: const EdgeInsets.all(20),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Type Selection
            _buildDeliveryTypeSection(),
            const SizedBox(height: 24),

            // Delivery Address
            _buildAddressSection(),
            const SizedBox(height: 24),

            // Coffee Item
            _buildCoffeeItemSection(cartItems),
            const SizedBox(height: 24),

            // Discount & Payment Summary
            _buildPaymentSection(subtotal, totalPrice),
            const SizedBox(height: 24),

            // Payment Method
            _buildPaymentMethodSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
     ),
      bottomNavigationBar: _buildBottomBar(totalPrice),
    );
  }

  Widget _buildDeliveryOption(String title) {
    final isSelected = _deliveryType == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _deliveryType = title;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFD28C5B) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryTypeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDeliveryOption('Deliver'),
          const SizedBox(width: 6),
          _buildDeliveryOption('Pick Up'),
        ],
      ),
    );
  }

  // Widget _buildDeliveryOption(String type, IconData icon) {
  //   final bool isSelected = _deliveryType == type;
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         _deliveryType = type;
  //       });
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  //       decoration: BoxDecoration(
  //         color: isSelected ? const Color(0xFFFFF5EE) : Colors.transparent,
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(
  //           color: isSelected ? const Color(0xFFC67C4E) : Colors.grey[300]!,
  //         ),
  //       ),
  //       child: Row(
  //         children: [
  //           Icon(icon,
  //               color: isSelected ? const Color(0xFFC67C4E) : Colors.grey),
  //           const SizedBox(width: 8),
  //           Text(
  //             type,
  //             style: TextStyle(
  //               fontWeight: FontWeight.w600,
  //               color: isSelected ? const Color(0xFFC67C4E) : Colors.black87,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildAddressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Address',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Jl. Keg Sutoyo',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Keg_Sutoyo No. 620, Diteen, Tanimagahati.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildAddressActionButton('Edit Address', Icons.edit_location),
              const SizedBox(width: 16),
              _buildAddressActionButton('Add Note', Icons.note_add),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressActionButton(String text, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color.fromARGB(255, 59, 54, 50), size: 16),
            const SizedBox(width: 4),
            Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 59, 54, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoffeeItemSection(List<Coffee> cartItems) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Text(
        'Order Items (${cartItems.length})',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...cartItems.map((item)  =>  _buildCartItems(item)).toList(),
       ],
      ),
    );
   }

   Widget _buildCartItems(Coffee item){
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(item.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.subtitle} * Size: ${item.selectedSize}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quantity: ${item.quantity}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFFC67C4E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(double subtotal,double totalPrice){
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Discount Info - Clean and simple
          if (_hasDiscount)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.discount_outlined,
                    color: Color(0xFFC67C4E),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      '1 Discount is Applies',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Text(
                    '-\$1.00',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC67C4E),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: _hasDiscount ? 16 : 0),

          // Payment Summary
          const Text(
            'Payment Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          _buildPaymentRow(
              'Price', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 12),

          _buildPaymentRow(
            'Delivery Fee',
            '\$$_deliveryFee',
            discountedPrice: _hasDiscount ? '\$$_discountedDeliveryFee' : null,
          ),
          const SizedBox(height: 16),

          const Divider(height: 1),
          const SizedBox(height: 12),

          _buildPaymentRow(
            'Total',
            '\$${totalPrice.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value,
      {String? discountedPrice, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (discountedPrice != null)
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                discountedPrice,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC67C4E),
                ),
              ),
            ],
          )
        else
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? const Color(0xFFC67C4E) : Colors.black87,
            ),
          ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Cash/Wallet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ],
      ),
    );
  }

  Widget _buildBottomBar(double totalPrice) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Total Price',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC67C4E),
                ),
              ),
            ],
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/delivery');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC67C4E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Order',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
