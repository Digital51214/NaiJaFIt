// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//
// import '../../core/app_export.dart';
// import '../../models/food_model.dart';
// import '../../services/supabase_service.dart';
// import '../../widgets/custom_icon_widget.dart';
// import './widgets/food_detail_bottom_sheet_widget.dart';
//
// class FoodLoggingScreen extends StatefulWidget {
//   const FoodLoggingScreen({super.key});
//
//   @override
//   State<FoodLoggingScreen> createState() => _FoodLoggingScreenState();
// }
//
// class _FoodLoggingScreenState extends State<FoodLoggingScreen>
//     with SingleTickerProviderStateMixin {
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _searchFocusNode = FocusNode();
//   String _searchQuery = '';
//   List<Map<String, dynamic>> _allFoods = [];
//   List<Map<String, dynamic>> _filteredFoods = [];
//   List<Map<String, dynamic>> _recentlyLogged = [];
//   bool _isLoading = true;
//   String? _errorMessage;
//
//   // Filter states
//   String _selectedRegion = 'All Regions';
//   String _selectedFoodType = 'All';
//
//   final List<String> _regions = [
//     'All Regions',
//     'East',
//     'East/South',
//     'North',
//     'North/Pan-Nigerian',
//     'South',
//     'South-South',
//     'South-South/West',
//     'South/West',
//     'West',
//   ];
//
//   final List<String> _foodTypes = [
//     'All',
//     'Appetizer',
//     'Bread/Snack',
//     'Breakfast',
//     'Drink',
//     'Drink/Snack',
//     'Main',
//     'Main/Salad',
//     'Main/Snack',
//   ];
//
//   // ✅ Animations
//   late final AnimationController _controller;
//
//   // Top (upar se neeche)
//   late final Animation<Offset> _headerSlide;
//   late final Animation<double> _headerFade;
//
//   late final Animation<Offset> _searchSlide;
//   late final Animation<double> _searchFade;
//
//   // Content (neeche se upar) - stagger
//   late final Animation<Offset> _contentSlide;
//   late final Animation<double> _contentFade;
//
//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_onSearchChanged);
//     _loadFoodsFromSupabase();
//     _loadRecentlyLoggedMeals();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1100),
//     );
//
//     // ✅ TOP: Header
//     _headerSlide = Tween<Offset>(
//       begin: const Offset(0, -0.35),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.00, 0.18, curve: Curves.easeOutCubic),
//       ),
//     );
//     _headerFade = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.00, 0.18, curve: Curves.easeOut),
//       ),
//     );
//
//     // ✅ TOP: Search bar
//     _searchSlide = Tween<Offset>(
//       begin: const Offset(0, -0.25),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.10, 0.30, curve: Curves.easeOutCubic),
//       ),
//     );
//     _searchFade = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.10, 0.28, curve: Curves.easeOut),
//       ),
//     );
//
//     // ✅ Content from bottom
//     _contentSlide = Tween<Offset>(
//       begin: const Offset(0, 0.35),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.24, 1.00, curve: Curves.easeOutCubic),
//       ),
//     );
//     _contentFade = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.24, 0.90, curve: Curves.easeOut),
//       ),
//     );
//
//     // ✅ start AFTER first frame
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) _controller.forward();
//     });
//   }
//
//   Future<void> _loadFoodsFromSupabase() async {
//     try {
//       setState(() {
//         _isLoading = true;
//         _errorMessage = null;
//       });
//
//       final client = SupabaseService.instance.client;
//       final response = await client.from('foods').select();
//
//       if ((response.isEmpty)) {
//         setState(() {
//           _allFoods = [];
//           _filteredFoods = [];
//           _isLoading = false;
//           _errorMessage =
//           'No foods in database. Please add food items to your Supabase foods table.';
//         });
//         return;
//       }
//
//       final foods = (response as List)
//           .map((json) => FoodModel.fromJson(json).toUIFormat())
//           .toList();
//
//       setState(() {
//         _allFoods = foods;
//         _filteredFoods = foods;
//         _isLoading = false;
//       });
//     } catch (error) {
//       setState(() {
//         _errorMessage = 'Failed to load foods: ${error.toString()}';
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _loadRecentlyLoggedMeals() async {
//     try {
//       final client = SupabaseService.instance.client;
//       final userId = client.auth.currentUser?.id;
//
//       if (userId == null) return;
//
//       final response = await client
//           .from('logged_meals')
//           .select()
//           .eq('user_id', userId)
//           .order('logged_at', ascending: false)
//           .limit(5);
//
//       final recentMeals = (response as List).map((meal) {
//         return {
//           'name': meal['food_name'],
//           'calories': meal['calories'],
//           'servingSize': meal['serving_size'],
//         };
//       }).toList();
//
//       setState(() {
//         _recentlyLogged = recentMeals;
//       });
//     } catch (error) {
//       // Silently fail for recent meals
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _searchController.removeListener(_onSearchChanged);
//     _searchController.dispose();
//     _searchFocusNode.dispose();
//     super.dispose();
//   }
//
//   void _onSearchChanged() {
//     setState(() {
//       _searchQuery = _searchController.text.toLowerCase();
//       _applyFilters();
//     });
//   }
//
//   void _applyFilters() {
//     List<Map<String, dynamic>> filtered = _allFoods;
//
//     if (_searchQuery.isNotEmpty) {
//       filtered = filtered
//           .where(
//             (food) =>
//             (food["name"] as String).toLowerCase().contains(_searchQuery),
//       )
//           .toList();
//     }
//
//     if (_selectedRegion != 'All Regions') {
//       filtered =
//           filtered.where((food) => food['region'] == _selectedRegion).toList();
//     }
//
//     if (_selectedFoodType != 'All') {
//       filtered = filtered
//           .where((food) => food['category'] == _selectedFoodType)
//           .toList();
//     }
//
//     setState(() {
//       _filteredFoods = filtered;
//     });
//   }
//
//   void _clearSearch() {
//     setState(() {
//       _searchController.clear();
//       _searchQuery = '';
//       _applyFilters();
//     });
//     _searchFocusNode.unfocus();
//   }
//
//   void _onFoodTap(Map<String, dynamic> food) async {
//     final result = await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => FoodDetailBottomSheetWidget(
//         food: food,
//         onAdd: (selectedFood, servingSize, servings) async {
//           await _logMealToSupabase(selectedFood, servingSize, servings);
//           if (mounted) {
//             Navigator.of(context).pop(true);
//           }
//         },
//       ),
//     );
//
//     if (result == true) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Added ${food["name"]} to your food log'),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//       _loadRecentlyLoggedMeals();
//     }
//   }
//
//   Future<void> _logMealToSupabase(
//       Map<String, dynamic> food,
//       String servingSize,
//       double servings,
//       ) async {
//     try {
//       final client = SupabaseService.instance.client;
//       final userId = client.auth.currentUser?.id;
//
//       if (userId == null) {
//         throw Exception('User not authenticated');
//       }
//
//       final calories = ((food['calories'] as num) * servings).round();
//       final protein = ((food['protein'] as num) * servings).round();
//       final carbs = ((food['carbs'] as num) * servings).round();
//       final fat = (food['fats'] as num) * servings;
//       final fiber = ((food['fiber'] as num?) ?? 0 * servings).round();
//
//       await client.from('logged_meals').insert({
//         'user_id': userId,
//         'food_name': food['name'],
//         'meal_type': _getCurrentMealType(),
//         'serving_size': servingSize,
//         'serving_grams': ((food['servingGrams'] as num?) ?? 100) * servings,
//         'calories': calories,
//         'protein_g': protein,
//         'carbs_g': carbs,
//         'fat_g': fat,
//         'fiber_g': fiber,
//       });
//     } catch (error) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to log meal: ${error.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//       rethrow;
//     }
//   }
//
//   String _getCurrentMealType() {
//     final hour = DateTime.now().hour;
//     if (hour < 11) return 'Breakfast';
//     if (hour < 16) return 'Lunch';
//     if (hour < 20) return 'Dinner';
//     return 'Snack';
//   }
//
//   String _normalizeFoodNameForImage(String foodName) {
//     return foodName
//         .toLowerCase()
//         .replaceAll(RegExp(r"['']"), '')
//         .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
//         .trim()
//         .replaceAll(RegExp(r'\s+'), '_');
//   }
//
//   String? _getFoodImageUrl(Map<String, dynamic> food) {
//     final foodName = food['name'] as String?;
//     final imageUrl = food['imageUrl'] as String?;
//
//     if (imageUrl != null && imageUrl.isNotEmpty) {
//       if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
//         return imageUrl;
//       } else {
//         final client = SupabaseService.instance.client;
//         return client.storage.from('food-images').getPublicUrl(imageUrl);
//       }
//     }
//
//     if (foodName != null && foodName.isNotEmpty) {
//       final normalizedName = _normalizeFoodNameForImage(foodName);
//       final client = SupabaseService.instance.client;
//       final constructedUrl = client.storage
//           .from('food-images')
//           .getPublicUrl('$normalizedName.jpg');
//       return constructedUrl;
//     }
//
//     return null;
//   }
//
//   Widget _animatedEntry({
//     required Animation<Offset> slide,
//     required Animation<double> fade,
//     required Widget child,
//   }) {
//     return FadeTransition(
//       opacity: fade,
//       child: SlideTransition(position: slide, child: child),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ✅ Header from TOP
//             _animatedEntry(
//               slide: _headerSlide,
//               fade: _headerFade,
//               child: _buildHeader(theme),
//             ),
//             SizedBox(height: 2.h),
//
//             // ✅ Search from TOP
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 4.w),
//               child: _animatedEntry(
//                 slide: _searchSlide,
//                 fade: _searchFade,
//                 child: _buildSearchBar(theme),
//               ),
//             ),
//
//             SizedBox(height: 2.h),
//
//             // ✅ Content from BOTTOM
//             Expanded(
//               child: _animatedEntry(
//                 slide: _contentSlide,
//                 fade: _contentFade,
//                 child: _isLoading
//                     ? _buildLoadingState()
//                     : _errorMessage != null
//                     ? _buildErrorState(theme)
//                     : _buildContent(theme),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoadingState() {
//     return const Center(child: CircularProgressIndicator());
//   }
//
//   Widget _buildErrorState(ThemeData theme) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
//           SizedBox(height: 2.h),
//           Text(
//             _errorMessage ?? 'Something went wrong',
//             style: theme.textTheme.bodyLarge,
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 2.h),
//           ElevatedButton(
//             onPressed: _loadFoodsFromSupabase,
//             child: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader(ThemeData theme) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.of(context, rootNavigator: true).pop(),
//             child: Container(
//               width: 12.w,
//               height: 12.w,
//               decoration: BoxDecoration(
//                 color: theme.colorScheme.surface,
//                 shape: BoxShape.circle,
//                 border: Border.all(color: theme.colorScheme.outline, width: 1),
//               ),
//               child: const Center(
//                 child: Icon(Icons.arrow_back_ios_new),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Center(
//               child: Text(
//                 'Food Logging',
//                 style: theme.textTheme.headlineSmall?.copyWith(
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 24),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSearchBar(ThemeData theme) {
//     return Container(
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surface,
//         borderRadius: BorderRadius.circular(12.0),
//         border: Border.all(
//           color: theme.colorScheme.outline.withAlpha(77),
//           width: 1,
//         ),
//       ),
//       child: TextField(
//         controller: _searchController,
//         focusNode: _searchFocusNode,
//         decoration: InputDecoration(
//           hintText: 'Search Nigerian foods...',
//           hintStyle: theme.textTheme.bodyMedium?.copyWith(
//             color: theme.colorScheme.onSurface.withAlpha(128),
//           ),
//           prefixIcon: Icon(
//             Icons.search,
//             color: theme.colorScheme.onSurface.withAlpha(128),
//           ),
//           suffixIcon: _searchQuery.isNotEmpty
//               ? IconButton(
//             icon: Icon(
//               Icons.clear,
//               color: theme.colorScheme.onSurface.withAlpha(128),
//             ),
//             onPressed: _clearSearch,
//           )
//               : null,
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(
//             horizontal: 4.w,
//             vertical: 1.5.h,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContent(ThemeData theme) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (_recentlyLogged.isNotEmpty) ...[
//             _buildRecentlyLoggedSection(theme),
//             SizedBox(height: 3.h),
//           ],
//           _buildRegionFilters(theme),
//           SizedBox(height: 2.h),
//           _buildFoodTypeFilters(theme),
//           SizedBox(height: 3.h),
//           _buildAllFoodsSection(theme),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRecentlyLoggedSection(ThemeData theme) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 4.w),
//           child: Text(
//             'Recently Logged',
//             style: theme.textTheme.titleLarge?.copyWith(
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),
//         SizedBox(height: 1.5.h),
//         SizedBox(
//           height: 15.h,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             padding: EdgeInsets.symmetric(horizontal: 4.w),
//             itemCount: _recentlyLogged.length,
//             itemBuilder: (context, index) {
//               final food = _recentlyLogged[index];
//               return GestureDetector(
//                 onTap: () {
//                   final fullFood = _allFoods.firstWhere(
//                         (f) => f['name'] == food['name'],
//                     orElse: () => food,
//                   );
//                   _onFoodTap(fullFood);
//                 },
//                 child: Container(
//                   width: 20.w,
//                   margin: EdgeInsets.only(right: 3.w),
//                   child: Column(
//                     children: [
//                       Container(
//                         width: 20.w,
//                         height: 20.w,
//                         decoration: BoxDecoration(
//                           color: theme.colorScheme.surface,
//                           borderRadius: BorderRadius.circular(12.0),
//                           border: Border.all(
//                             color: theme.colorScheme.outline.withAlpha(77),
//                             width: 1,
//                           ),
//                         ),
//                         child: _buildFoodImageFromFood(food, theme),
//                       ),
//                       SizedBox(height: 1.h),
//                       Text(
//                         food['name'],
//                         style: theme.textTheme.bodySmall?.copyWith(
//                           fontWeight: FontWeight.w600,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         textAlign: TextAlign.center,
//                       ),
//                       Text(
//                         '${food['calories']} cal',
//                         style: theme.textTheme.bodySmall?.copyWith(
//                           color: const Color(0xFF4CAF50),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildRegionFilters(ThemeData theme) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 4.w),
//           child: Row(
//             children: [
//               const Icon(Icons.location_on,
//                   color: Color(0xFF4CAF50), size: 20),
//               SizedBox(width: 1.w),
//               Text(
//                 'Filter by Region',
//                 style: theme.textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 1.h),
//         SizedBox(
//           height: 5.h,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             padding: EdgeInsets.symmetric(horizontal: 4.w),
//             itemCount: _regions.length,
//             itemBuilder: (context, index) {
//               final region = _regions[index];
//               final isSelected = _selectedRegion == region;
//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _selectedRegion = region;
//                     _applyFilters();
//                   });
//                 },
//                 child: Container(
//                   margin: EdgeInsets.only(right: 2.w),
//                   padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
//                   decoration: BoxDecoration(
//                     color: isSelected
//                         ? const Color(0xFF4CAF50)
//                         : theme.colorScheme.surface,
//                     borderRadius: BorderRadius.circular(20.0),
//                     border: Border.all(
//                       color: isSelected
//                           ? const Color(0xFF4CAF50)
//                           : theme.colorScheme.outline.withAlpha(77),
//                       width: 1,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.location_on,
//                         color: isSelected
//                             ? Colors.white
//                             : theme.colorScheme.onSurface.withAlpha(128),
//                         size: 16,
//                       ),
//                       SizedBox(width: 1.w),
//                       Text(
//                         region,
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           color: isSelected
//                               ? Colors.white
//                               : theme.colorScheme.onSurface,
//                           fontWeight:
//                           isSelected ? FontWeight.w600 : FontWeight.w400,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFoodTypeFilters(ThemeData theme) {
//     return SizedBox(
//       height: 5.h,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.symmetric(horizontal: 4.w),
//         itemCount: _foodTypes.length,
//         itemBuilder: (context, index) {
//           final foodType = _foodTypes[index];
//           final isSelected = _selectedFoodType == foodType;
//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 _selectedFoodType = foodType;
//                 _applyFilters();
//               });
//             },
//             child: Container(
//               margin: EdgeInsets.only(right: 2.w),
//               padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
//               decoration: BoxDecoration(
//                 color: isSelected
//                     ? const Color(0xFF4CAF50)
//                     : theme.colorScheme.surface.withAlpha(128),
//                 borderRadius: BorderRadius.circular(20.0),
//               ),
//               child: Center(
//                 child: Text(
//                   foodType,
//                   style: theme.textTheme.bodyMedium?.copyWith(
//                     color:
//                     isSelected ? Colors.white : theme.colorScheme.onSurface,
//                     fontWeight:
//                     isSelected ? FontWeight.w600 : FontWeight.w400,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildAllFoodsSection(ThemeData theme) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 4.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'All Foods',
//                 style: theme.textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               Text(
//                 '${_filteredFoods.length} foods',
//                 style: theme.textTheme.bodyMedium?.copyWith(
//                   color: theme.colorScheme.onSurface.withAlpha(128),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 2.h),
//           if (_filteredFoods.isEmpty)
//             Center(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 4.h),
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.search_off,
//                       size: 64,
//                       color: theme.colorScheme.onSurface.withAlpha(77),
//                     ),
//                     SizedBox(height: 2.h),
//                     Text(
//                       'No foods found',
//                       style: theme.textTheme.bodyLarge?.copyWith(
//                         color: theme.colorScheme.onSurface.withAlpha(153),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           else
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: _filteredFoods.length,
//               itemBuilder: (context, index) {
//                 final food = _filteredFoods[index];
//                 return _buildFoodItem(food, theme);
//               },
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFoodItem(Map<String, dynamic> food, ThemeData theme) {
//     return GestureDetector(
//       onTap: () => _onFoodTap(food),
//       child: Container(
//         margin: EdgeInsets.only(bottom: 2.h),
//         padding: EdgeInsets.all(3.w),
//         decoration: BoxDecoration(
//           color: theme.colorScheme.surface,
//           borderRadius: BorderRadius.circular(12.0),
//           border: Border.all(
//             color: theme.colorScheme.outline.withAlpha(77),
//             width: 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 15.w,
//               height: 15.w,
//               decoration: BoxDecoration(
//                 color: theme.colorScheme.surface,
//                 borderRadius: BorderRadius.circular(8.0),
//                 border: Border.all(
//                   color: theme.colorScheme.outline.withAlpha(77),
//                   width: 1,
//                 ),
//               ),
//               child: _buildFoodImageFromFood(food, theme),
//             ),
//             SizedBox(width: 3.w),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     food['name'],
//                     style: theme.textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.w600,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 0.5.h),
//                   Text(
//                     food['servingSize'] ?? '1 serving',
//                     style: theme.textTheme.bodySmall?.copyWith(
//                       color: theme.colorScheme.onSurface.withAlpha(128),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   '${food['calories']} cal',
//                   style: theme.textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.w700,
//                     color: const Color(0xFF4CAF50),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFoodImageFromFood(Map<String, dynamic> food, ThemeData theme) {
//     final imageUrl = _getFoodImageUrl(food);
//     return _buildFoodImage(imageUrl, theme);
//   }
//
//   Widget _buildFoodImage(String? imageUrl, ThemeData theme) {
//     if (imageUrl != null && imageUrl.isNotEmpty) {
//       String fullImageUrl;
//       if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
//         fullImageUrl = imageUrl;
//       } else {
//         final client = SupabaseService.instance.client;
//         fullImageUrl = client.storage.from('food-images').getPublicUrl(imageUrl);
//       }
//
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(8.0),
//         child: CachedNetworkImage(
//           imageUrl: fullImageUrl,
//           fit: BoxFit.cover,
//           placeholder: (context, url) => Center(
//             child: SizedBox(
//               width: 20,
//               height: 20,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: const Color(0xFF4CAF50),
//               ),
//             ),
//           ),
//           errorWidget: (context, url, error) => Icon(
//             Icons.restaurant,
//             color: theme.colorScheme.onSurface.withAlpha(128),
//             size: 24,
//           ),
//         ),
//       );
//     }
//
//     return Icon(
//       Icons.restaurant,
//       color: theme.colorScheme.onSurface.withAlpha(128),
//       size: 24,
//     );
//   }
// }














import 'package:flutter/material.dart';
import 'package:naijafit/presentation/food_logging_screen/widgets/food_detail_bottom_sheet_widget.dart';

// ─────────────────────────────────────────────
//  Dummy Data
// ─────────────────────────────────────────────
const List<Map<String, dynamic>> _dummyFoods = [
  {
    'name': 'Ofe Onugbu',
    'calories': 320,
    'protein': 18.0,
    'carbs': 22.0,
    'fats': 14.0,
    'servingSize': '1 bowl',
    'servingOptions': ['1 bowl', '2 bowls', 'Half bowl'],
    'category': 'Main',
    'region': 'South',
    'image':
    'https://images.unsplash.com/photo-1604329760661-e71dc83f8f26?w=400',
  },
  {
    'name': 'Suya',
    'calories': 260,
    'protein': 28.0,
    'carbs': 6.0,
    'fats': 14.0,
    'servingSize': '1 skewer',
    'servingOptions': ['1 skewer', '2 skewers', '3 skewers'],
    'category': 'Appetizer',
    'region': 'North',
    'image':
    'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400',
  },
  {
    'name': 'Akara',
    'calories': 180,
    'protein': 8.0,
    'carbs': 22.0,
    'fats': 7.0,
    'servingSize': '3 pieces',
    'servingOptions': ['3 pieces', '5 pieces', '1 piece'],
    'category': 'Breakfast',
    'region': 'West',
    'image':
    'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=400',
  },
  {
    'name': 'Puff Puff',
    'calories': 210,
    'protein': 4.0,
    'carbs': 30.0,
    'fats': 9.0,
    'servingSize': '4 pieces',
    'servingOptions': ['4 pieces', '6 pieces', '2 pieces'],
    'category': 'Bread/Snack',
    'region': 'South',
    'image':
    'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400',
  },
];

class FoodLoggingScreen extends StatefulWidget {
  const FoodLoggingScreen({super.key});

  @override
  State<FoodLoggingScreen> createState() => _FoodLoggingScreenState();
}

class _FoodLoggingScreenState extends State<FoodLoggingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedRegion = 'All Regions';
  String _selectedFoodType = 'All';

  List<Map<String, dynamic>> get _filteredFoods {
    return _dummyFoods.where((food) {
      final matchesSearch =
          _searchQuery.isEmpty ||
              (food['name'] as String)
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
      final matchesRegion =
          _selectedRegion == 'All Regions' || food['region'] == _selectedRegion;
      final matchesType =
          _selectedFoodType == 'All' || food['category'] == _selectedFoodType;
      return matchesSearch && matchesRegion && matchesType;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onFoodTap(Map<String, dynamic> food) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FoodDetailBottomSheetWidget(
        food: food,
        onAdd: (f, serving, servings) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Added ${f["name"]} to your food log',
                style: const TextStyle(fontFamily: "Poppins"),
              ),
              duration: const Duration(seconds: 2),
              backgroundColor: const Color(0xFF2E7D32),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────
            _buildHeader(theme),

            // ── Search ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildSearchBar(theme),
            ),

            // ── Scrollable Content ───────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // All Foods
                    _buildAllFoodsSection(theme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          left: 50,
          right: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // 🔥 TEXT BUBBLE
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDDE8D8), // light green like image
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  "Can't see your favorite meal on the list? Use AI Nutrition Coach to get calories details of your food and add it to your list",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 8,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // 🔥 RIGHT SIDE (ARROW + FAB)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔥 ARROW IMAGE (replace with your asset)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Image.asset(
                    "assets/images/errow.png", // 👈 yahan apni image laga dena
                    height: 28,
                    width: 28,
                  ),
                ),

                // 🔥 CIRCULAR FAB WITH SHADOW
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: FloatingActionButton(
                    onPressed: () {},
                    elevation: 0,
                    backgroundColor: const Color(0xFF1B7F3A),
                    shape: CircleBorder(), // dark green
                    child: const Icon(Icons.add, size: 30, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────
  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    'Food Logging',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    'Log Your Daily Food Intake',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Image(
            image: AssetImage("assets/images/LOGO.png"),
            height: 60,
            width: 60,
          )
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      height: 47,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: const TextStyle(fontFamily: "Poppins"),
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: const TextStyle(
            fontFamily: "Poppins",
            color: Colors.black38,
            fontSize: 15,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.black38),

          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: Colors.black38),
            onPressed: () => setState(() {
              _searchController.clear();
              _searchQuery = '';
            }),
          )
              : null,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),

          // 🔥 IMPORTANT FIX
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(width: 1, color: Colors.green),
          ),

          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  // ── All Foods Section ─────────────────────────
  Widget _buildAllFoodsSection(ThemeData theme) {
    final foods = _filteredFoods;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.9,
            ),
            itemCount: foods.length,
            itemBuilder: (_, index) => _buildFoodCard(foods[index]),
          ),
        ],
      ),
    );
  }

  // ── Food Card ─────────────────────────────────
  Widget _buildFoodCard(Map<String, dynamic> food) {
    return GestureDetector(
      onTap: () => _onFoodTap(food),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 01,
            color: Colors.grey.withOpacity(0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Food Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 9, left: 9),
                child: Container(
                  height: 83,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(food['image'] as String),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 9),

            // Food Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                food['name'] as String,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 9),

            // "See Portfolio" button style — matching image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 33,
                child: OutlinedButton(
                  onPressed: () => _onFoodTap(food),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2E7D32),
                    side: const BorderSide(
                      color: Color(0xFF2E7D32),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 14,
                    ),
                    minimumSize: const Size(double.infinity, 34),
                  ),
                  child: const Text(
                    'See Portfolio',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 11),
          ],
        ),
      ),
    );
  }
}