// home_page_header.dart
import 'package:flutter/material.dart';
// import 'package:coffee_shop_mobile_app_design_community_3971357995_f2f/bendis_widget.dart';

class HomePageHeader extends StatelessWidget {
  final Function(String) onSearchChanged; //This will trigger search as user types
  final Function() onFilterPressed; //Search Filter button & Detects User Press

  const HomePageHeader({
    super.key,
    required this.onSearchChanged,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          width: double.infinity,
          color: const Color(0xFF131313),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 44.0, left: 30, right: 30, bottom: 24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location',
                            style: TextStyle(
                                color: Color(0xFFA2A2A2), fontSize: 12)),
                        Row(
                          children: [
                            Text('Bilzen, Tanjungbalai',
                                style: TextStyle(
                                    color: Color(0xFFDDDDDD),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14)),
                            Icon(Icons.keyboard_arrow_down,
                                color: Colors.white, size: 16),
                          ],
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: Image.asset(
                        'assets/Coffee-shop/Logo.png',
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                            width: 44, height: 44, color: Colors.brown),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search coffee',
                    hintStyle: const TextStyle(color: Color(0xFF989898)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    suffixIcon: GestureDetector(
                      onTap: onFilterPressed,
                      child: const SearchFilterIcon(),
                    ),
                    filled: true,
                    fillColor: Color(0xFF313131),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide.none
                    ),
                  ),
                  onChanged: onSearchChanged, // This will trigger search as user types
                ),
              ],
            ),
          ),
        );
    //     Transform.translate(
    //       offset: const Offset(0, -24),
    //       child: Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 30),
    //         child: Container(
    //           height: 140,
    //           width: double.infinity,
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.all(Radius.circular(16)),
    //             color: Colors.transparent, // Optional: add background color
    //           ),
    //           child: ClipRRect(
    //             borderRadius: BorderRadius.circular(16),
    //             child: Image.asset(
    //               'assets/Coffee-shop/Banner.png',
    //               fit: BoxFit.cover, // or BoxFit.fitWidth
    //               width: double.infinity,
    //               height: 140,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}

class SearchFilterIcon extends StatelessWidget {
  const SearchFilterIcon({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: const Color(0xFFC67C4E),
          borderRadius: BorderRadius.circular(12)
      ),
      child: const Icon(Icons.tune, color: Colors.white),
    );
  }
}
