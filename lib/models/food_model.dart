class FoodModel {
  final String foodName;
  final String? nigerianName;
  final String? region;
  final String? culture;
  final String? category;
  final String? description;
  final String? typicalServingSize;
  final int? servingGrams;
  final int? estimatedCalories;
  final int? proteinG;
  final int? carbsG;
  final double? fatG;
  final int? fiberG;
  final String? preparationMethod;
  final String? diasporaAvailability;
  final String? healthySwapOption;
  final int? swapCaloriesSaved;
  final String? imageUrl;

  FoodModel({
    required this.foodName,
    this.nigerianName,
    this.region,
    this.culture,
    this.category,
    this.description,
    this.typicalServingSize,
    this.servingGrams,
    this.estimatedCalories,
    this.proteinG,
    this.carbsG,
    this.fatG,
    this.fiberG,
    this.preparationMethod,
    this.diasporaAvailability,
    this.healthySwapOption,
    this.swapCaloriesSaved,
    this.imageUrl,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      foodName: json['FoodName'] as String,
      nigerianName: json['NigerianName'] as String?,
      region: json['Region'] as String?,
      culture: json['Culture'] as String?,
      category: json['Category'] as String?,
      description: json['Description'] as String?,
      typicalServingSize: json['TypicalServingSize'] as String?,
      servingGrams: (json['ServingGrams'] as num?)?.toInt(),
      estimatedCalories: (json['EstimatedCalories'] as num?)?.toInt(),
      proteinG: (json['Protein_g'] as num?)?.toInt(),
      carbsG: (json['Carbs_g'] as num?)?.toInt(),
      fatG: (json['Fat_g'] as num?)?.toDouble(),
      fiberG: (json['Fiber_g'] as num?)?.toInt(),
      preparationMethod: json['PreparationMethod'] as String?,
      diasporaAvailability: json['DiasporaAvailability'] as String?,
      healthySwapOption: json['HealthySwapOption'] as String?,
      swapCaloriesSaved: (json['SwapCaloriesSaved'] as num?)?.toInt(),
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FoodName': foodName,
      'NigerianName': nigerianName,
      'Region': region,
      'Culture': culture,
      'Category': category,
      'Description': description,
      'TypicalServingSize': typicalServingSize,
      'ServingGrams': servingGrams,
      'EstimatedCalories': estimatedCalories,
      'Protein_g': proteinG,
      'Carbs_g': carbsG,
      'Fat_g': fatG,
      'Fiber_g': fiberG,
      'PreparationMethod': preparationMethod,
      'DiasporaAvailability': diasporaAvailability,
      'HealthySwapOption': healthySwapOption,
      'SwapCaloriesSaved': swapCaloriesSaved,
      'image_url': imageUrl,
    };
  }

  // Helper method to convert to UI format
  Map<String, dynamic> toUIFormat() {
    return {
      'name': foodName,
      'category': category ?? 'Other',
      'calories': estimatedCalories ?? 0,
      'protein': proteinG ?? 0,
      'carbs': carbsG ?? 0,
      'fats': fatG ?? 0.0,
      'fiber': fiberG ?? 0,
      'servingSize': typicalServingSize ?? '1 serving',
      'servingGrams': servingGrams ?? 100,
      'description': description ?? '',
      'nigerianName': nigerianName,
      'region': region,
      'imageUrl': imageUrl,
    };
  }
}
