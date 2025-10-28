// home_page_body.dart
import 'package:flutter/material.dart';
import '../models/coffee_model.dart';
import 'coffee_card.dart';
import '../services/coffee_api_service.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody>{
  List<Coffee> coffeeList = [];
  List<Coffee> _allCoffees = []; // Cache all coffees - Optimization 1
  List<String> categories = ['All Coffee']; // start with just 'All Coffee'
  bool isLoading = true;
  bool isCategoryLoading = false; // Secondary loading state - Optimization 3
  String errorMessage = '';
  String _selectedCategory = 'All Coffee';

  @override
  void initState(){
    super.initState();
    _loadCoffees();
    _loadCategories(); // Load categories from API - Optimization 2
  }

  Future<void> _loadCoffees() async {
    //'Future<void>' is Asynchronous method (it takes time to complete, so we use await).
    try {
      final coffees = await CoffeeApiService.getAllCoffees();
      //'CoffeeApiService.getAllCoffees()' makes an HTTP GET request to your backend and retrieves JSON data.
      setState(() {
        _allCoffees = coffees; // Cache them - Optimization 1
        coffeeList = coffees;
        isLoading = false;
      });
    } catch(e){
      setState(() {      // 'setState' tells Flutter that data has changed, so the UI should rebuild
       errorMessage = 'Failed to load coffees: $e';
       isLoading = false;
      });
      print('Error loading coffees: $e');
    }
  }

  // Load categories from API - Optimization 2
  Future<void> _loadCategories() async {
    try {
      final apiCategories = await CoffeeApiService.getCategories();
      // Create a Set to remove duplicates, then convert to List
      final uniqueCategories = {'All Coffee', ...apiCategories}.toList();

      setState(() {
        categories = uniqueCategories;
      });
    } catch(e) {
      print('Failed to load categories: $e');
      // If categories fail to load, we'll use the default hardcoded ones as fallback
      setState(() {
        categories = ['All Coffee', 'Machiato', 'Latte', 'Americano'];
      });
    }
  }

  void _handleCategoryFilter(String category){
    setState((){
      _selectedCategory =  category;
    });

    if(category == 'All Coffee'){
      // Use cached data instead of API call - Optimization 1
      setState(() {
        coffeeList = _allCoffees;
      });
    } else{
     _loadCoffeesByCategory(category);
    }
  }

  Future<void> _loadCoffeesByCategory(String category) async {
    setState(() {
      isCategoryLoading = true; // Optimization 3
    });

    try {
      final coffees = await CoffeeApiService.getCoffeesByCategory(category);
      setState(() {
        coffeeList = coffees;
        isCategoryLoading = false; // Optimization 3
      });
    } catch(e){
      setState((){
        errorMessage = 'Failed to load $category coffees: $e';
        isCategoryLoading = false; // Optimization 3
      });
      print('Error load $category coffees: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC67C4E)),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadCoffees,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC67C4E),
                ),
                child: const Text(
                    'Retry', style: TextStyle(color: Colors.white)),
              ),
            ],
          )
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.zero, // ✅ no extra padding
        child: Column(
          children: [
            // PROMO BANNER - MOVED FROM HEADER TO BODY
            // Transform.translate(
            //   offset: const Offset(0, -24),
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            //     child: Container(
            //       height: 140,
            //       width: double.infinity,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.all(Radius.circular(16)),
            //         color: Colors.transparent,
            //       ),
            //       child: ClipRRect(
            //         borderRadius: BorderRadius.circular(16),
            //         child: Image.asset(
            //           'assets/Coffee-shop/Banner.png',
            //           fit: BoxFit.cover,
            //           width: double.infinity,
            //           height: 140,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8), // small gap from search bar
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/Coffee-shop/Banner.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 140,
                ),
              ),
            ),


            const SizedBox(height: 10), // Space between banner and filter tabs

            FilterTabs(
          categories: categories, // Pass dynamic categories - Optimization 2
          selectedCategory: _selectedCategory,
          onCategorySelected: _handleCategoryFilter,
        ),
        const SizedBox(height: 15),

        // Show loading indicator for category switching - Optimization 3
        if (isCategoryLoading)
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC67C4E)),
            ),)
        else
          //Expanded(child: //Use Expanded for proper grid layout
          Padding(
            // Adds space around the GridView (on left and right because of horizontal).
            padding: const EdgeInsets.symmetric(
                horizontal:
                30.0), //Adds 30 pixels of padding on the left and right sides.
            child: coffeeList.isEmpty
                ? const Center(
              child: Text(
                'No coffees found',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
                : GridView.builder(
              //Dynamically builds grid items on demand using a builder function — efficient for lists that can grow.
              physics:
              const NeverScrollableScrollPhysics(),
              //Disables scrolling for this GridView.
               shrinkWrap:
                   true, //Tells GridView to shrink to fit its content instead of taking infinite height.
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //Defines how the grid is arranged (columns, spacing, aspect ratio).
                //Used when you want a fixed number of columns.
                crossAxisCount: 2,
                //Defines 2 columns in each grid row.
                mainAxisExtent: 270,
                crossAxisSpacing: 15,
                //Space between columns.
                mainAxisSpacing: 20,
                //Space between rows.
                childAspectRatio:
                0.60, //Controls the width-to-height ratio of each grid item
              ),
              itemCount: coffeeList.length,
              //Number of items to build
              itemBuilder: (context, index) {
                //Function that builds each grid item dynamically.
                final coffee = coffeeList[
                index]; //Fetches a single coffee object from the list.
                return CoffeeCard(
                    coffee:
                    coffee); //Custom widget that displays coffee details.
              },
            ),
          ),
            const SizedBox(height: 20),
        ], ),
      );
    }
  }


class FilterTabs extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const FilterTabs({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 30),
        children: categories.map((category) {
          final isSelected = category == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () => onCategorySelected(category),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFC67C4E) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFC67C4E) : const Color(0xFFDEDEDE),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF2F2D2C),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
//                     backgroundColor: category == 'All Coffee'
//                         ? const Color(0xFFC67C4E)
//                         : Colors.white,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     side: BorderSide.none,
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   ),
//                 ))
//             .toList(),
//       ),
//     );
//   }
// }      For Dynamic
