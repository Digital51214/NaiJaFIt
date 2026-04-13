//







import 'package:flutter/material.dart';
import 'package:naijafit/presentation/Edit_profile_screen.dart';
import 'package:naijafit/presentation/Privacy_screen.dart';

import '../../models/user_profile.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool _isLoading = true;
  UserProfile? _userProfile;
  String? _avatarUrl;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);

    try {
      final user = AuthService.instance.currentUser;

      if (user != null) {
        final profile = await AuthService.instance.getUserProfile(user.id);

        if (mounted) {
          setState(() {
            _userProfile = profile;
            _nameController.text =
            (profile?.fullName != null &&
                profile!.fullName!.trim().isNotEmpty)
                ? profile.fullName!
                : 'Henry Wick';

            _emailController.text =
            (profile?.email != null && profile!.email.trim().isNotEmpty)
                ? profile.email
                : 'example@mail.com';

            _avatarUrl = profile?.avatarUrl;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _nameController.text = 'Henry Wick';
            _emailController.text = 'example@mail.com';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _nameController.text = 'Henry Wick';
          _emailController.text = 'example@mail.com';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load profile: ${e.toString()}',
              style: const TextStyle(fontFamily: "Poppins"),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _goToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          initialName: _nameController.text,
          initialEmail: _emailController.text,
          initialAvatarUrl: _avatarUrl,
        ),
      ),
    );

    if (result == true) {
      _loadUserProfile();
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(fontFamily: "Poppins"),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontFamily: "Poppins"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: "Poppins"),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await AuthService.instance.signOut();
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.signIn,
                (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Logout failed: ${e.toString()}',
                style: const TextStyle(fontFamily: "Poppins"),
              ),
            ),
          );
        }
      }
    }
  }

  void _onAccountSettings() {
    _goToEditProfile();
  }

  void _onPreferences() {
    final width = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(width * 0.06),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Preferences',
                  style: TextStyle(
                    fontFamily: "bold",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Preference options like measurement units and nutrition display settings can be managed here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                _buildBottomSheetTile(
                  icon: Icons.straighten,
                  title: 'Measurement Units',
                  subtitle: 'Kg/lbs, ft/cm, yrs/months',
                ),
                _buildBottomSheetTile(
                  icon: Icons.restaurant_menu,
                  title: 'Meal Display Preferences',
                  subtitle: 'Nutrition and calorie preferences',
                ),
                _buildBottomSheetTile(
                  icon: Icons.language,
                  title: 'Region Preference',
                  subtitle: 'Nigeria / Diaspora experience',
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onNotificationSettings() {
    final width = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(width * 0.06),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Progress & Notifications',
                  style: TextStyle(
                    fontFamily: "bold",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Users should be able to access their progress-related reminders and tracking prompts from here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                _buildBottomSheetTile(
                  icon: Icons.monitor_weight_outlined,
                  title: 'Weekly Weight Tracker',
                  subtitle: 'Prompt user to enter weight every week',
                ),
                _buildBottomSheetTile(
                  icon: Icons.local_fire_department_outlined,
                  title: 'Daily Food Log Reminders',
                  subtitle: 'Bring users back daily to log meals',
                ),
                _buildBottomSheetTile(
                  icon: Icons.check_circle_outline,
                  title: 'Consistency Tracking',
                  subtitle: 'Track daily food logging consistency',
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3FAF4),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF026F1A).withOpacity(0.10),
                    ),
                  ),
                  child: const Text(
                    'Note: Dedicated progress screens can be connected here later. For now, this section acts as the profile-side entry point for those features.',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE4E4E4)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF5ED),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF026F1A),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: "bold",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12.5,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _buildAvatarImage() {
    if (_avatarUrl != null && _avatarUrl!.isNotEmpty) {
      return NetworkImage(_avatarUrl!);
    } else {
      return const AssetImage('assets/images/profile (2).png');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final width = size.width;
    final height = size.height;
    final textScale = mediaQuery.textScaleFactor;

    double responsiveFont(double fontSize) {
      double scale = width / 375;
      double responsiveSize = fontSize * scale;
      return responsiveSize.clamp(fontSize * 0.85, fontSize * 1.20);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.06),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.02),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Profile Settings',
                              style: TextStyle(
                                fontFamily: "bold",
                                fontSize: responsiveFont(18) / textScale,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Image.asset(
                            'assets/images/LOGO.png',
                            height: height * 0.07,
                            width: width * 0.14,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.02),

                      CircleAvatar(
                        radius: width * 0.19,
                        backgroundColor: Colors.transparent,
                        backgroundImage: _buildAvatarImage(),
                      ),

                      SizedBox(height: height * 0.012),

                      Text(
                        _nameController.text.isNotEmpty
                            ? _nameController.text
                            : 'Henry Wick',
                        style: TextStyle(
                          fontFamily: "bold",
                          fontSize: responsiveFont(13) / textScale,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),

                      SizedBox(height: height * 0.005),

                      Text(
                        _emailController.text.isNotEmpty
                            ? _emailController.text
                            : 'example@mail.com',
                        style: TextStyle(
                          fontFamily: "semibold",
                          fontSize: responsiveFont(11) / textScale,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF9A9A9A),
                        ),
                      ),

                      SizedBox(height: height * 0.025),

                      SizedBox(
                        width: width * 0.45,
                        height: height * 0.058,
                        child: ElevatedButton.icon(
                          onPressed: _goToEditProfile,
                          icon: Icon(
                            Icons.edit,
                            size: width * 0.05,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontFamily: "bold",
                              fontSize: responsiveFont(11) / textScale,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF026F1A),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(width * 0.11),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 2),
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.03),

                      _buildMenuCard(
                        icon: Icons.account_circle_outlined,
                        title: 'Account Settings',
                        onTap: _onAccountSettings,
                        width: width,
                        height: height,
                        textScale: textScale,
                        responsiveFont: responsiveFont,
                      ),

                      SizedBox(height: height * 0.01),

                      _buildMenuCard(
                        icon: Icons.tune,
                        title: 'Preferences',
                        onTap: _onPreferences,
                        width: width,
                        height: height,
                        textScale: textScale,
                        responsiveFont: responsiveFont,
                      ),

                      SizedBox(height: height * 0.01),

                      _buildMenuCard(
                        icon: Icons.notifications_active_outlined,
                        title: 'Progress & Notifications',
                        onTap: _onNotificationSettings,
                        width: width,
                        height: height,
                        textScale: textScale,
                        responsiveFont: responsiveFont,
                      ),

                      SizedBox(height: height * 0.038),

                      _buildLogoutButton(
                        width: width,
                        height: height,
                        textScale: textScale,
                        responsiveFont: responsiveFont,
                      ),

                      SizedBox(height: height * 0.015),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrivacyPolicy(),
                            ),
                          );
                        },
                        child: Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontFamily: "semibold",
                            fontSize: responsiveFont(12) / textScale,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.02),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required double width,
    required double height,
    required double textScale,
    required double Function(double) responsiveFont,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(width * 0.064),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(width * 0.064),
        child: Container(
          height: height * 0.07,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: height * 0.02,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(width * 0.048),
            border: Border.all(
              color: const Color(0xFFD1D1D1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: width * 0.065,
                color: Colors.black,
              ),
              SizedBox(width: width * 0.04),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: "bold",
                    fontSize: responsiveFont(11.5) / textScale,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF7D7D7D),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: width * 0.045,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton({
    required double width,
    required double height,
    required double textScale,
    required double Function(double) responsiveFont,
  }) {
    return SizedBox(
      width: double.infinity,
      height: height * 0.055,
      child: ElevatedButton(
        onPressed: _handleLogout,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          side: const BorderSide(
            color: Color(0xFFD84A4A),
            width: 1.5,
          ),
          padding: EdgeInsets.symmetric(vertical: height * 0.002),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * 0.11),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              color: const Color(0xFFC62828),
              size: width * 0.05,
            ),
            SizedBox(width: width * 0.02),
            Text(
              'Logout',
              style: TextStyle(
                fontFamily: "bold",
                fontSize: responsiveFont(10) / textScale,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFC62828),
              ),
            ),
          ],
        ),
      ),
    );
  }
}