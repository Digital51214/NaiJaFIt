import 'dart:io';
import 'package:flutter/material.dart';
import 'package:naijafit/presentation/Edit_profile_screen.dart';
import 'package:naijafit/presentation/Privacy_screen.dart';
import 'package:sizer/sizer.dart';

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
            (profile?.fullName != null && profile!.fullName!.trim().isNotEmpty)
                ? profile.fullName!
                : 'Henry wick';

            _emailController.text =
            (profile?.email != null && profile!
                .email
                .trim()
                .isNotEmpty)
                ? profile.email
                : 'Exmple@mail.com';

            _avatarUrl = profile?.avatarUrl;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _nameController.text = 'Henry wick';
            _emailController.text = 'Exmple@mail.com';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _nameController.text = 'Henry wick';
          _emailController.text = 'Exmple@mail.com';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load profile: ${e.toString()}',
              style: TextStyle(fontFamily: "Poppins"),
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
        builder: (context) =>
            EditProfileScreen(
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
      builder: (context) =>
          AlertDialog(
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
                style: TextStyle(fontFamily: "Poppins"),
              ),
            ),
          );
        }
      }
    }
  }

  void _onAccountSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Account Settings tapped',
          style: TextStyle(fontFamily: "Poppins"),
        ),
      ),
    );
  }

  void _onPreferences() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Preferences tapped',
          style: TextStyle(fontFamily: "Poppins"),
        ),
      ),
    );
  }

  void _onNotificationSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Notifications Settings tapped',
          style: TextStyle(fontFamily: "Poppins"),
        ),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 3.h),

                      Align(
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          'assets/images/LOGO.png',
                          height: 7.h,
                          width: 14.w,
                          fit: BoxFit.contain,
                        ),
                      ),

                      SizedBox(height: 1.5.h),

                      CircleAvatar(
                        radius: 19.w,
                        backgroundColor: Colors.transparent,
                        backgroundImage: _buildAvatarImage(),
                      ),
                      Text(
                        _nameController.text.isNotEmpty
                            ? _nameController.text
                            : 'Henry wick',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 0.5.h,),

                      Text(
                        _emailController.text.isNotEmpty
                            ? _emailController.text
                            : 'Exmple@mail.com',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF9A9A9A),
                        ),
                      ),

                      SizedBox(height: 2.5.h),

                      SizedBox(
                        width: 45.w,
                        height: 45,
                        child: ElevatedButton.icon(
                          onPressed: _goToEditProfile,
                          icon: const Icon(
                            Icons.edit,
                            size: 15,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF067A16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 3.h),

                      _buildMenuCard(
                        icon: Icons.account_circle_outlined,
                        title: 'Account Settings',
                        onTap: _onAccountSettings,
                      ),

                      SizedBox(height: 1.h),

                      _buildMenuCard(
                        icon: Icons.tune,
                        title: 'Preferences',
                        onTap: _onPreferences,
                      ),

                      SizedBox(height: 1.h),

                      _buildMenuCard(
                        icon: Icons.notifications,
                        title: 'Notifications Settings',
                        onTap: _onNotificationSettings,
                      ),

                      SizedBox(height: 3.8.h),

                      _buildLogoutButton(),

                      SizedBox(height: 1.5.h),

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
                            fontFamily: "Poppins",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      SizedBox(height: 2.h),
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
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 56,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFD1D1D1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 25,
                color: Colors.black,
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF7D7D7D),
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 45,
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
          padding: EdgeInsets.symmetric(vertical: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout,
              color: Color(0xFFC62828),
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Logout',
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 10.sp,
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