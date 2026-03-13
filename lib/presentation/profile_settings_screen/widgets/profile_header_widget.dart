import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final String membershipStatus;
  final VoidCallback onAvatarTap;
  final File? selectedImage;

  const ProfileHeaderWidget({
    super.key,
    this.avatarUrl,
    required this.name,
    required this.membershipStatus,
    required this.onAvatarTap,
    this.selectedImage, // ✅ FIXED (proper assignment)
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isPremium =
        membershipStatus.toLowerCase().contains('active') ||
            membershipStatus.toLowerCase().contains('premium');

    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Stack(
            children: [

              /// 🔥 Avatar Container
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: _buildProfileImage(theme),
                ),
              ),

              /// 🔥 Camera Icon
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onAvatarTap,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 1.5.h),

          /// 🔥 Name
          Text(
            name.isEmpty ? 'User@gmail.com' : name,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          /// 🔥 Membership
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPremium ? Icons.workspace_premium : Icons.person,
                size: 14,
                color: isPremium
                    ? const Color(0xFF8B5CF6)
                    : theme.colorScheme.secondary,
              ),
              SizedBox(width: 1.w),
              Text(
                isPremium ? 'Premium Member' : 'Free Member',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isPremium
                      ? const Color(0xFF8B5CF6)
                      : theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔥 IMAGE LOGIC (Most Important Part)
  Widget _buildProfileImage(ThemeData theme) {

    // 1️⃣ If user selected new image from gallery/camera
    if (selectedImage != null) {
      return Image.file(
        selectedImage!,
        fit: BoxFit.cover,
      );
    }

    // 2️⃣ If image exists from network
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return Image.network(
        avatarUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _buildDefaultAvatar(theme);
        },
      );
    }

    // 3️⃣ Default icon
    return _buildDefaultAvatar(theme);
  }

  Widget _buildDefaultAvatar(ThemeData theme) {
    return Container(
      color: theme.colorScheme.primary.withValues(alpha: 0.1),
      child: Icon(
        Icons.person,
        size: 40,
        color: theme.colorScheme.primary,
      ),
    );
  }
}