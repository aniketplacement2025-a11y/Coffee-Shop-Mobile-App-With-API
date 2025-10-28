import 'package:flutter/material.dart';
// import 'package:coffee_shop_mobile_app_design_community_3971357995_f2f/bendis_widget.dart';
// import 'package:coffee_shop_mobile_app_design_community_3971357995_f2f/figma_to_flutter.dart'
//     as f2f;
import 'dart:ui';
import '../models/coffee_model.dart';
//
//
//
//
import '../Home/home_page_body.dart';
import '../Home/favorite_page_body.dart';
import '../Home/cart_page_body.dart';
import '../Home/notifications_page_body.dart';
import '../Home/home_page_header.dart';
import '../Home/home_page_footer.dart';
import '../Home/Tab/home_page_tab.dart';

// Add this enum to represent different pages
// enum HomePageTab {
//   home,
//   favorite,
//   cart,
//   notifications,
// }

// Create a stateful widget for the main home page
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageTab _currentTab = HomePageTab.home;

  // Method to change tabs
  void _changeTab(HomePageTab tab) {
    setState(() {
      _currentTab = tab;
    });
  }

  // Method to get the current body based on selected tab
  Widget _getCurrentBody() {
    switch (_currentTab) {
      case HomePageTab.home:
        return const HomePageBody();
      case HomePageTab.favorite:
        return const FavoritePageBody();
      case HomePageTab.cart:
        return const CartPageBody();
      case HomePageTab.notifications:
        return const NotificationsPageBody();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: Color(0xFFF9F9F9),
          body: Stack(
            children: [
              // Header (fixed at top)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: HomePageHeader(),
              ),

              // Body content (scrollable) - positioned below header and above footer
              Positioned(
                top: 150, // Adjust based on your header height
                left: 0,
                right: 0,
                bottom: 50, // Space for footer
                child: _getCurrentBody(),
              ),

              // Footer (fixed at bottom)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: HomePageFooter(
                  currentTab: _currentTab,
                  onTabChanged: _changeTab,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
