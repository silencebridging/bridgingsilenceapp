import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/user_model.dart';

/// Authentication service for managing user authentication
class AuthService with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  /// Get the current user
  UserModel? get currentUser => _currentUser;
  
  /// Check if a user is signed in
  bool get isSignedIn => _currentUser != null;
  
  /// Check if authentication is in progress
  bool get isLoading => _isLoading;
  
  /// Get the current error message
  String? get errorMessage => _errorMessage;

  /// Initialize the auth service
  Future<void> initialize() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Check if user is already signed in
      final session = SupabaseConfig.client.auth.currentSession;
      
      if (session != null) {
        await _fetchUserProfile();
      }
    } catch (e) {
      _errorMessage = 'Error initializing authentication: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign in with email and password
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      final response = await SupabaseConfig.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        await _fetchUserProfile();
        return true;
      } else {
        _errorMessage = 'Unknown error occurred during sign in';
        return false;
      }
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Error signing in: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Register with email and password
  Future<bool> registerWithEmail(String email, String password, String fullName) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      // Sign up the user with their metadata
      final response = await SupabaseConfig.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
        },
      );
      
      if (response.user != null) {
        print('User created successfully with ID: ${response.user?.id}');
        // Rely solely on the database trigger to create the profile
        // No manual profile creation needed
        
        // Check if email confirmation is required
        if (response.session != null) {
          print('Session created, no email confirmation required');
          // Email confirmation not required or already confirmed
          try {
            await _fetchUserProfile();
            print('User profile fetched successfully');
          } catch (e) {
            print('Error fetching profile: $e');
            // Continue even if profile fetch fails - the trigger might need time
          }
          return true;
        } else {
          print('Email confirmation required');
          // Email confirmation required
          _errorMessage = 'Please check your email to confirm your account';
          return true; // We return true but show a message about email confirmation
        }
      } else {
        _errorMessage = 'Unknown error occurred during registration';
        return false;
      }
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Error registering: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await SupabaseConfig.client.auth.signOut();
      _currentUser = null;
    } catch (e) {
      _errorMessage = 'Error signing out: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      if (_currentUser == null) {
        _errorMessage = 'No user is signed in';
        return false;
      }
      
      final updates = <String, dynamic>{};
      
      if (fullName != null) updates['full_name'] = fullName;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      
      await SupabaseConfig.client
          .from('profiles')
          .update(updates)
          .eq('id', _currentUser!.id);
      
      await _fetchUserProfile();
      return true;
    } catch (e) {
      _errorMessage = 'Error updating profile: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      await SupabaseConfig.client.auth.resetPasswordForEmail(email);
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Error resetting password: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch user profile from the database
  Future<void> _fetchUserProfile() async {
    try {
      final userId = SupabaseConfig.client.auth.currentUser?.id;
      
      if (userId == null) {
        _currentUser = null;
        print('No current user found');
        return;
      }
      
      print('Fetching profile for user ID: $userId');
      
      try {
        // Try to fetch the user's profile
        final response = await SupabaseConfig.client
            .from('profiles')
            .select()
            .eq('id', userId)
            .maybeSingle(); // Use maybeSingle instead of single to prevent errors
        
        print('Profile fetch response: $response');
        
        if (response != null) {
          print('Converting profile response to UserModel');
          _currentUser = UserModel.fromJson(response);
          print('User profile successfully loaded');
        } else {
          print('No profile found, creating minimal user object');
          // Profile might not exist yet, especially if the database trigger isn't set up
          // Create a minimal user object based on auth data
          final authUser = SupabaseConfig.client.auth.currentUser!;
          _currentUser = UserModel(
            id: authUser.id,
            email: authUser.email ?? '',
            fullName: authUser.userMetadata?['full_name'] as String?,
            createdAt: DateTime.parse(authUser.createdAt),
          );
          print('Created minimal user object: ${_currentUser?.fullName}');
        }
      } catch (profileError) {
        print('Error fetching profile from database: $profileError');
        // Even if profile fetch fails, create a minimal user from auth data
        final authUser = SupabaseConfig.client.auth.currentUser!;
        _currentUser = UserModel(
          id: authUser.id,
          email: authUser.email ?? '',
          fullName: authUser.userMetadata?['full_name'] as String?,
          createdAt: DateTime.parse(authUser.createdAt),
        );
        print('Created fallback minimal user object due to fetch error');
      }
    } catch (e) {
      print('Critical error in _fetchUserProfile: $e');
      _errorMessage = 'Error fetching user profile: $e';
      _currentUser = null;
    }
  }

  /// Clear any error messages
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
