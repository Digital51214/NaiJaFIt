class UserProfile {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final String? fitnessGoal;
  final String? weightUnit;
  final String? stripeCustomerId;
  final String? subscriptionPlan;
  final String? subscriptionStatus;
  final DateTime? trialEndsAt;
  final DateTime? subscriptionEndsAt;
  final DateTime? trialStartedAt;
  final bool hasUsedTrial;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserProfile({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.fitnessGoal,
    this.weightUnit,
    this.stripeCustomerId,
    this.subscriptionPlan,
    this.subscriptionStatus,
    this.trialEndsAt,
    this.subscriptionEndsAt,
    this.trialStartedAt,
    this.hasUsedTrial = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      fitnessGoal: json['fitness_goal'] as String?,
      weightUnit: json['weight_unit'] as String?,
      stripeCustomerId: json['stripe_customer_id'] as String?,
      subscriptionPlan: json['subscription_plan'] as String?,
      subscriptionStatus: json['subscription_status'] as String?,
      trialEndsAt: json['trial_ends_at'] != null
          ? DateTime.parse(json['trial_ends_at'] as String)
          : null,
      subscriptionEndsAt: json['subscription_ends_at'] != null
          ? DateTime.parse(json['subscription_ends_at'] as String)
          : null,
      trialStartedAt: json['trial_started_at'] != null
          ? DateTime.parse(json['trial_started_at'] as String)
          : null,
      hasUsedTrial: json['has_used_trial'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'fitness_goal': fitnessGoal,
      'weight_unit': weightUnit,
      'stripe_customer_id': stripeCustomerId,
      'subscription_plan': subscriptionPlan,
      'subscription_status': subscriptionStatus,
      'trial_ends_at': trialEndsAt?.toIso8601String(),
      'subscription_ends_at': subscriptionEndsAt?.toIso8601String(),
      'trial_started_at': trialStartedAt?.toIso8601String(),
      'has_used_trial': hasUsedTrial,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
    String? fitnessGoal,
    String? weightUnit,
    String? stripeCustomerId,
    String? subscriptionPlan,
    String? subscriptionStatus,
    DateTime? trialEndsAt,
    DateTime? subscriptionEndsAt,
    DateTime? trialStartedAt,
    bool? hasUsedTrial,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      weightUnit: weightUnit ?? this.weightUnit,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      trialEndsAt: trialEndsAt ?? this.trialEndsAt,
      subscriptionEndsAt: subscriptionEndsAt ?? this.subscriptionEndsAt,
      trialStartedAt: trialStartedAt ?? this.trialStartedAt,
      hasUsedTrial: hasUsedTrial ?? this.hasUsedTrial,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
