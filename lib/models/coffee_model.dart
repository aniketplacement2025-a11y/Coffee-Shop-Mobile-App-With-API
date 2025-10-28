// models/coffee_model.dart
class Coffee {
  final int id;
  final String imagePath;
  final String title;
  final String subtitle;
  final String category;
  final double rating;
  final int reviewCount;
  final String description;
  final String necessary_supplies;
  final String necessaryTools;
  final double price; // Change from String to double
  final bool isFavorite; // NEW: Add this field
  final int quantity; // NEW: For cart quantity
  final String selectedSize; // NEW: For selected size (S, M, L)

  const Coffee({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.rating, // Provide default value
    required this.reviewCount, // Provide default value
    required this.description, // Provide default value
    required this.necessary_supplies,
    required this.necessaryTools,
    required this.price,
    required this.isFavorite, // NEW: Add this parameter
    this.quantity = 0, // NEW: Default to 0
    this.selectedSize = 'M', // NEW: Default size
  });

  factory Coffee.fromJson(Map<String,dynamic> json){
    return Coffee(id: json['id']??0,
        imagePath: json['imagePath']??'',
        title: json['title']??'',
        subtitle: json['subtitle'] ?? '',
        category: json['category'] ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        reviewCount: json['reviewCount']?? 0,
        description: json['description']?? '',
        necessary_supplies: json['necessary_supplies']??'',
        necessaryTools: json['necessaryTools']??'',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        isFavorite: json['isFavorite'] ?? false, // NEW: Add this
        quantity: json['quantity'] ?? 0, // NEW
        selectedSize: json['selectedSize'] ?? 'M', // NEW
    );
  }

  //NEW: Copy with method for updating properties
  Coffee copyWith({
    int? id,
    String? imagePath,
    String? title,
    String? subtitle,
    String? category,
    double? rating,
    int? reviewCount,
    String? description,
    String? necessary_supplies,
    String? necessaryTools,
    double? price,
    bool? isFavorite,
    int? quantity,
    String? selectedSize,
 }){
   return Coffee(
     id: id ?? this.id,
     imagePath: imagePath ?? this.imagePath,
     title: title ?? this.title,
     subtitle: subtitle ?? this.subtitle,
     category: category ?? this.category,
     rating: rating ?? this.rating,
     reviewCount: reviewCount ?? this.reviewCount,
     description: description ?? this.description,
     necessary_supplies: necessary_supplies ?? this.necessary_supplies,
     necessaryTools: necessaryTools ?? this.necessaryTools,
     price: price ?? this.price,
     isFavorite: isFavorite ?? this.isFavorite,
     quantity: quantity ?? this.quantity,
     selectedSize: selectedSize ?? this.selectedSize,
   );
  }
}

// final sampleCoffee = Coffee(
//   imagePath: 'assets/Coffee-shop/Caffe Mocha.png',
//   title: 'Caffe Mocha',
//   subtitle: 'Ice/Hot',
//   category: 'Machiato',
//   rating: 4.8,
//   reviewCount: 230,
//   description:
//       'A cappuccino is an approximately 150 ml (5 oz) beverage, with 25 ml of espresso coffee and 85ml of fresh milk the fo...',
//   necessary_supplies: '',
//   necessaryTools: '',
//   price: 4.53, // Remove $ sign, use double
// );
