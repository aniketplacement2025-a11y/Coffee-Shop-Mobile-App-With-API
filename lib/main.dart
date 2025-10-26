import 'package:flutter/material.dart';
import 'screen/onboarding_page.dart'; // Import the new onboarding page
import 'screen/home_page.dart';
import 'screen/detail_page.dart';
import 'screen/delivery_page.dart';
import 'models/coffee_model.dart';
import 'screen/order_page.dart';

// Add this sample coffee for fallback
Coffee get sampleCoffee => Coffee(
  id: 1,
  imagePath: 'assets/Coffee-shop/Caffe Mocha.png',
  title: 'Caffe Mocha',
  subtitle: 'Deep Foam',
  category: 'All Coffee',
  rating: 4.8,
  reviewCount: 230,
  description: 'Rich chocolate and espresso blend with creamy foam',
  necessary_supplies: 'Fresh espresso beans\nWhole milk\nHigh-quality cocoa powder\nChocolate syrup\nWhipped cream\nSugar (optional)',
  necessaryTools: 'Pump Driven Espresso Machine (\$250 minimum)\nQuality Burr Grinder (\$150 minimum)\nEspresso Tamper (\$25 minimum)\nMug or Glass (\$8)\nSteam Pitcher (\$15)\nWhisk or Frother (\$12)',
  price: 4.53,
  isFavorite: false
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Shop',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Set the initial route to your onboarding page
      initialRoute: '/',

      // b. DEFINE YOUR APP'S ROUTES HERE
      routes: {
        '/': (context) => const OnboardingPage(), // This is your root page
        '/home': (context) =>
            const HomePage(), // This is your new home page route
        '/detail': (context) {
          // Get the coffee data from arguments
          final args = ModalRoute.of(context)!.settings.arguments as Coffee?;
          // If no coffee data is passed, use the sample coffee
          return DetailPage(coffee: args ?? sampleCoffee);
        },
        '/order': (context) {
          // Get the coffee data from arguments
          final args = ModalRoute.of(context)!.settings.arguments as Coffee?;
          return OrderPage(coffee: args ?? sampleCoffee);
        },
        '/delivery': (context) => const DeliveryPage(),
      },
    );
  }
}
