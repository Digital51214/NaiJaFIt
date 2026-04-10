import 'package:flutter/material.dart';

class Selectmealscreen extends StatefulWidget {
  const Selectmealscreen({super.key});

  @override
  State<Selectmealscreen> createState() => _SelectmealscreenState();
}

class _SelectmealscreenState extends State<Selectmealscreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> meals = [
    {
      'tag': 'Morning Energy',
      'title': 'Breakfast',
      'description': 'Light starters or heavy yam porridge for the day ahead.',
      'icon': Icons.wb_sunny_outlined,
      'image': 'assets/images/breakfast.png',
    },
    {
      'tag': 'Peak Sustenance',
      'title': 'Lunch',
      'description': 'Jollof rice, pounded yam, or your favorite soup clusters.',
      'icon': Icons.restaurant_outlined,
      'image': 'assets/images/lunch.png',
    },
    {
      'tag': 'Restorative Night',
      'title': 'Dinner',
      'description': 'Light swallons or protein-rich suya salads to end your day.',
      'icon': Icons.nightlight_round_outlined,
      'image': 'assets/images/dinner.png',
    },
  ];

  List<Map<String, dynamic>> get filteredMeals {
    if (_searchQuery.trim().isEmpty) return meals;

    return meals.where((meal) {
      final title = meal['title'].toString().toLowerCase();
      final tag = meal['tag'].toString().toLowerCase();
      final description = meal['description'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();

      return title.contains(query) ||
          tag.contains(query) ||
          description.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchBar(
      ThemeData theme,
      double width,
      double height,
      double textScale,
      double Function(double) responsiveFont,
      ) {
    return Container(
      height: height * 0.058,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.08),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: width * 0.026,
            offset: Offset(0, height * 0.0025),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: TextStyle(
          fontFamily: "Poppins",
          fontSize: responsiveFont(14) / textScale,
        ),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(
            fontFamily: "regular",
            color: Colors.black38,
            fontSize: responsiveFont(15) / textScale,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black38,
            size: width * 0.06,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.black38,
              size: width * 0.055,
            ),
            onPressed: () {
              setState(() {
                _searchController.clear();
                _searchQuery = '';
              });
            },
          )
              : null,
          contentPadding: EdgeInsets.symmetric(
            horizontal: width * 0.042,
            vertical: height * 0.017,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.08),
            borderSide: const BorderSide(width: 1, color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.08),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.08),
            borderSide: const BorderSide(width: 1, color: Colors.green),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).textScaleFactor;
    final double screenWidth = size.width;
    final double screenHeight = size.height;

    double responsiveFont(double base) => base * (screenWidth / 375);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: screenHeight * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Top Navigation Bar ───
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.018,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Back Button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: screenWidth * 0.11,
                        height: screenWidth * 0.11,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEAF3DE),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.chevron_left,
                            color: const Color(0xFF2E7D32),
                            size: screenWidth * 0.06,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: screenWidth * 0.04),

                    // Title + Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Meal',
                            style: TextStyle(
                              fontSize: screenWidth * 0.065,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Fuel your body with vitality',
                            style: TextStyle(
                              fontSize: screenWidth * 0.038,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Logo
                    Image.asset(
                      'assets/images/LOGO.png',
                      width: screenWidth * 0.15,
                      height: screenWidth * 0.15,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox(
                          width: screenWidth * 0.15,
                          height: screenWidth * 0.15,
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.015),

              // ─── Search Bar ───
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: _buildSearchBar(
                  theme,
                  screenWidth,
                  screenHeight,
                  textScale,
                  responsiveFont,
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // ─── Meal Cards ───
              ...filteredMeals.map((meal) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                    bottom: screenHeight * 0.01,
                  ),
                  child: _MealCard(
                    tag: meal['tag'],
                    title: meal['title'],
                    description: meal['description'],
                    icon: meal['icon'],
                    imagePath: meal['image'],
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final String tag;
  final String title;
  final String description;
  final IconData icon;
  final String imagePath;
  final double screenWidth;
  final double screenHeight;

  const _MealCard({
    required this.tag,
    required this.title,
    required this.description,
    required this.icon,
    required this.imagePath,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        height: 138,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── Left: Text Content ───
            Expanded(
              flex: 55,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.045,
                  vertical: screenHeight * 0.022,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tag Row
                    Row(
                      children: [
                        Container(
                          width: screenWidth * 0.08,
                          height: screenWidth * 0.08,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEAF3DE),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              icon,
                              color: const Color(0xFF2E7D32),
                              size: screenWidth * 0.045,
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Flexible(
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: screenWidth * 0.026,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2E7D32),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.009),

                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.004),

                    // Description
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: screenWidth * 0.026,
                        color: Colors.grey[600],
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── Right: Image ───
            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(screenWidth * 0.05),
                bottomRight: Radius.circular(screenWidth * 0.05),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: screenWidth * 0.27,
                  maxWidth: screenWidth * 0.27,
                  minHeight: screenHeight * 0.15,
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: screenWidth * 0.33,
                      color: const Color(0xFFEAF3DE),
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          color: const Color(0xFF2E7D32),
                          size: screenWidth * 0.1,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}