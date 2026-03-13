import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile.dart';
import './supabase_service.dart';

class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();

  AuthService._();

  final SupabaseClient _client = SupabaseService.instance.client;

  // Get current user
  User? get currentUser => _client.auth.currentUser;

  // Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  // Auth state stream
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      if (response.user != null) {
        // Create user profile
        await _createUserProfile(
          userId: response.user!.id,
          email: email,
          fullName: fullName,
        );
      }

      return response;
    } on AuthException catch (e) {
      debugPrint('Auth signup error: ${e.message} (${e.statusCode})');
      rethrow;
    } catch (e) {
      debugPrint('Signup error: $e');
      rethrow;
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw AuthException('Sign in failed - no user returned');
      }

      debugPrint('Sign in successful for user: ${response.user!.id}');
      return response;
    } on AuthException catch (e) {
      debugPrint('Auth sign-in error: ${e.message} (${e.statusCode})');
      rethrow;
    } catch (e) {
      debugPrint('Sign-in error: $e');
      rethrow;
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web OAuth flow
        return await _client.auth.signInWithOAuth(OAuthProvider.google);
      } else {
        // Native flow
        const webClientId = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');
        final googleSignIn = GoogleSignIn(serverClientId: webClientId);

        GoogleSignInAccount? user = await googleSignIn.signInSilently();
        user ??= await googleSignIn.signIn();

        if (user == null) return false;

        final googleAuth = await user.authentication;
        final idToken = googleAuth.idToken;

        if (idToken == null) throw AuthException('No ID Token found');

        final response = await _client.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: googleAuth.accessToken,
        );

        if (response.user != null) {
          // Check if profile exists, create if not
          final profile = await getUserProfile(response.user!.id);
          if (profile == null) {
            await _createUserProfile(
              userId: response.user!.id,
              email: response.user!.email!,
              fullName: response.user!.userMetadata?['full_name'] as String?,
            );
          }
        }

        return response.user != null;
      }
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        final googleSignIn = GoogleSignIn();
        if (await googleSignIn.isSignedIn()) {
          await googleSignIn.signOut();
        }
      }
      await _client.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  // Get user profile
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final response = await _client
          .from('user_profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;

      return UserProfile.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile
  Future<UserProfile> updateUserProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
    String? fitnessGoal,
    String? weightUnit,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (fullName != null) updates['full_name'] = fullName;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (fitnessGoal != null) updates['fitness_goal'] = fitnessGoal;
      if (weightUnit != null) updates['weight_unit'] = weightUnit;

      final response = await _client
          .from('user_profiles')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Private: Create user profile
  Future<void> _createUserProfile({
    required String userId,
    required String email,
    String? fullName,
  }) async {
    try {
      await _client.from('user_profiles').insert({
        'id': userId,
        'email': email,
        'full_name': fullName,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Profile might already exist, ignore error
      debugPrint('Profile creation error (might already exist): $e');
    }
  }
}
