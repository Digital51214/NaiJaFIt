import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naijafit/presentation/Privacy_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../models/user_profile.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import './widgets/notification_settings_widget.dart';
import './widgets/preference_toggle_widget.dart';
import './widgets/profile_field_widget.dart';
import './widgets/profile_header_widget.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  UserProfile? _userProfile;
  String? _avatarUrl;
  File? _selectedImage;

  // Preferences
  bool _useKg = true;
  bool _useCm = true;
  String _activityLevel = 'moderate';

  // Notification settings
  bool _mealReminders = true;
  bool _progressUpdates = true;
  bool _streakNotifications = true;
  bool _weeklyReports = false;

  // Theme
  String _themeMode = 'light';

  // ✅ Animations (same pattern as previous screens)
  late final AnimationController _controller;

  // Top (upar se neeche)
  late final Animation<Offset> _appBarSlide;
  late final Animation<double> _appBarFade;

  // Body sections (neeche se upar) - stagger one by one
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerFade;

  late final Animation<Offset> _profileInfoSlide;
  late final Animation<double> _profileInfoFade;

  late final Animation<Offset> _prefsSlide;
  late final Animation<double> _prefsFade;

  late final Animation<Offset> _notificationsSlide;
  late final Animation<double> _notificationsFade;

  late final Animation<Offset> _privacySlide;
  late final Animation<double> _privacyFade;

  late final Animation<Offset> _actionsSlide;
  late final Animation<double> _actionsFade;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadPreferences();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    // ✅ AppBar from top
    _appBarSlide = Tween<Offset>(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.18, curve: Curves.easeOutCubic),
      ),
    );

    _appBarFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.18, curve: Curves.easeOut),
      ),
    );

    // ✅ Body header
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.18, 0.34, curve: Curves.easeOutCubic),
      ),
    );

    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.18, 0.34, curve: Curves.easeOut),
      ),
    );

    // ✅ Profile info
    _profileInfoSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.28, 0.48, curve: Curves.easeOutCubic),
      ),
    );

    _profileInfoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.28, 0.48, curve: Curves.easeOut),
      ),
    );

    // ✅ Preferences
    _prefsSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 0.64, curve: Curves.easeOutCubic),
      ),
    );

    _prefsFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 0.64, curve: Curves.easeOut),
      ),
    );

    // ✅ Notifications
    _notificationsSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.54, 0.80, curve: Curves.easeOutCubic),
      ),
    );

    _notificationsFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.54, 0.80, curve: Curves.easeOut),
      ),
    );

    // ✅ Privacy/Support
    _privacySlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 0.90, curve: Curves.easeOutCubic),
      ),
    );

    _privacyFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 0.90, curve: Curves.easeOut),
      ),
    );

    // ✅ Actions (Save/Logout/Delete/Version)
    _actionsSlide = Tween<Offset>(
      begin: const Offset(0, 0.40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.78, 1.00, curve: Curves.easeOutCubic),
      ),
    );

    _actionsFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.78, 1.00, curve: Curves.easeOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);

    try {
      final user = AuthService.instance.currentUser;
      if (user != null) {
        final profile = await AuthService.instance.getUserProfile(user.id);
        if (profile != null && mounted) {
          setState(() {
            _userProfile = profile;
            _nameController.text = profile.fullName ?? '';
            _emailController.text = profile.email;
            _avatarUrl = profile.avatarUrl;
            _useKg = profile.weightUnit != 'lbs';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _useKg = prefs.getBool('use_kg') ?? true;
        _useCm = prefs.getBool('use_cm') ?? true;
        _activityLevel = prefs.getString('activity_level') ?? 'moderate';
        _mealReminders = prefs.getBool('meal_reminders') ?? true;
        _progressUpdates = prefs.getBool('progress_updates') ?? true;
        _streakNotifications = prefs.getBool('streak_notifications') ?? true;
        _weeklyReports = prefs.getBool('weekly_reports') ?? false;
        _themeMode = prefs.getString('theme_mode') ?? 'light';
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final user = AuthService.instance.currentUser;
      if (user != null) {
        await AuthService.instance.updateUserProfile(
          userId: user.id,
          fullName: _nameController.text.trim(),
          avatarUrl: _avatarUrl,
          weightUnit: _useKg ? 'kg' : 'lbs',
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('use_kg', _useKg);
        await prefs.setBool('use_cm', _useCm);
        await prefs.setString('activity_level', _activityLevel);
        await prefs.setBool('meal_reminders', _mealReminders);
        await prefs.setBool('progress_updates', _progressUpdates);
        await prefs.setBool('streak_notifications', _streakNotifications);
        await prefs.setBool('weekly_reports', _weeklyReports);
        await prefs.setString('theme_mode', _themeMode);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile updated successfully'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Image Source",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                    onTap: () async {
               Navigator.pop(context);
               await _openImage(ImageSource.camera);
             },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white60,
                          border: Border.all(
                            width: 1,
                            color: Colors.green,
                          )
                        ),
                        child: Icon(Icons.camera_alt,size: 30,color: Colors.black,),
                      ),
                    ),
                    SizedBox(width: 20,),
                    GestureDetector(
                      onTap: () async {
                             Navigator.pop(context);
                             await _openImage(ImageSource.gallery);
                           },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white60,
                            border: Border.all(
                              width: 1,
                              color: Colors.green,
                            ),
                        ),
                        child: Icon(Icons.photo_library,size: 30,color: Colors.black,),
                      ),
                    ),
                  ],
                )

                // 📷 Camera Option
                // ListTile(
                //   leading: const Icon(Icons.camera_alt),
                //   title: const Text("Camera"),
                //   onTap: () async {
                //     Navigator.pop(context);
                //     await _openImage(ImageSource.camera);
                //   },
                // ),
                //
                // // 🖼 Gallery Option
                // ListTile(
                //   leading: const Icon(Icons.photo_library),
                //   title: const Text("Gallery"),
                //   onTap: () async {
                //     Navigator.pop(context);
                //     await _openImage(ImageSource.gallery);
                //   },
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
  Future<void> _openImage(ImageSource source) async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Logout',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await AuthService.instance.signOut();
        if (mounted) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.signIn, (route) => false);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logout failed: ${e.toString()}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  Widget _animatedEntry({
    required Animation<Offset> slide,
    required Animation<double> fade,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // ✅ Animated AppBar (UI same)
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _animatedEntry(
          slide: _appBarSlide,
          fade: _appBarFade,
          child: AppBar(
            title: Text(
              'Profile & Settings',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            actions: [
              if (_isSaving)
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadUserProfile,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Header animated
                _animatedEntry(
                  slide: _headerSlide,
                  fade: _headerFade,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileHeaderWidget(
                        avatarUrl: _avatarUrl,
                        selectedImage: _selectedImage,
                        name: _nameController.text,
                        membershipStatus: _userProfile?.subscriptionStatus ?? 'Free',
                        onAvatarTap: _pickImage,
                      ),
                      SizedBox(height: 3.h),
                    ],
                  ),
                ),

                // ✅ Profile info animated
                _animatedEntry(
                  slide: _profileInfoSlide,
                  fade: _profileInfoFade,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(theme, 'Profile Information'),
                      SizedBox(height: 1.5.h),
                      ProfileFieldWidget(
                        label: 'Full Name',
                        controller: _nameController,
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 1.5.h),
                      ProfileFieldWidget(
                        label: 'Email',
                        controller: _emailController,
                        icon: Icons.email_outlined,
                      ),
                      SizedBox(height: 1.5.h),
                      ProfileFieldWidget(
                        label: 'Phone (Optional)',
                        controller: _phoneController,
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 3.h),
                    ],
                  ),
                ),

                // ✅ Preferences animated
                _animatedEntry(
                  slide: _prefsSlide,
                  fade: _prefsFade,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(theme, 'Preferences'),
                      SizedBox(height: 1.5.h),
                      PreferenceToggleWidget(
                        title: 'Weight Unit',
                        leftOption: 'kg',
                        rightOption: 'lbs',
                        isLeftSelected: _useKg,
                        onToggle: (isLeft) {
                          setState(() => _useKg = isLeft);
                        },
                      ),
                      SizedBox(height: 1.5.h),
                      PreferenceToggleWidget(
                        title: 'Height Unit',
                        leftOption: 'cm',
                        rightOption: 'ft',
                        isLeftSelected: _useCm,
                        onToggle: (isLeft) {
                          setState(() => _useCm = isLeft);
                        },
                      ),
                      SizedBox(height: 1.5.h),
                      _buildActivityLevelSelector(theme),
                      SizedBox(height: 3.h),
                    ],
                  ),
                ),

                // ✅ Notifications animated
                _animatedEntry(
                  slide: _notificationsSlide,
                  fade: _notificationsFade,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(theme, 'Notifications'),
                      SizedBox(height: 1.5.h),
                      NotificationSettingsWidget(
                        mealReminders: _mealReminders,
                        progressUpdates: _progressUpdates,
                        streakNotifications: _streakNotifications,
                        weeklyReports: _weeklyReports,
                        onMealRemindersChanged: (value) {
                          setState(() => _mealReminders = value);
                        },
                        onProgressUpdatesChanged: (value) {
                          setState(() => _progressUpdates = value);
                        },
                        onStreakNotificationsChanged: (value) {
                          setState(() => _streakNotifications = value);
                        },
                        onWeeklyReportsChanged: (value) {
                          setState(() => _weeklyReports = value);
                        },
                      ),
                      SizedBox(height: 3.h),
                    ],
                  ),
                ),

                // ✅ Privacy animated
                _animatedEntry(
                  slide: _privacySlide,
                  fade: _privacyFade,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(theme, 'Privacy/Support'),
                      SizedBox(height: 1.5.h),
                      _buildPrivacySupportLink(theme),
                      SizedBox(height: 3.h),
                    ],
                  ),
                ),

                // ✅ Actions animated
                _animatedEntry(
                  slide: _actionsSlide,
                  fade: _actionsFade,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSaveButton(theme),
                      SizedBox(height: 2.h),
                      _buildLogoutButton(theme),
                      SizedBox(height: 2.h),
                      _buildDeleteAccountButton(theme),
                      SizedBox(height: 2.h),
                      _buildAppVersion(theme),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildActivityLevelSelector(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity Level',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          DropdownButtonFormField<String>(
            initialValue: _activityLevel,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 3.w,
                vertical: 1.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'sedentary', child: Text('Sedentary')),
              DropdownMenuItem(value: 'light', child: Text('Light Activity')),
              DropdownMenuItem(
                value: 'moderate',
                child: Text('Moderate Activity'),
              ),
              DropdownMenuItem(value: 'active', child: Text('Very Active')),
              DropdownMenuItem(
                value: 'extreme',
                child: Text('Extremely Active'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _activityLevel = value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySupportLink(ThemeData theme) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyPolicy()));
      },
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: theme.dividerColor),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyPolicy()));

          },
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
            child: Row(
              children: [
                Icon(
                  Icons.privacy_tip_outlined,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Privacy/Support',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 0.h),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
        ),
        child: _isSaving
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.onPrimary,
            ),
          ),
        )
            : Text(
          'Save Changes',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton(
        onPressed: _handleLogout,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 0.h),
          side: BorderSide(color: theme.colorScheme.error),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(
          'Logout',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.error,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
  Widget _buildDeleteAccountButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton(
        onPressed: (){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account deletion feature coming soon'),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 0.h),
          side: BorderSide(color: theme.colorScheme.error),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(
          'Delete Account',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.error,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }


  Widget _buildAppVersion(ThemeData theme) {
    return Center(
      child: Text(
        'NaijaFit v1.0.0',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}