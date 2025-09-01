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
      
      final response = await SupabaseConfig.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
        },
      );
      
      if (response.user != null) {
        // Create user profile in the database
        await SupabaseConfig.client.from('profiles').insert({
          'id': response.user!.id,
          'email': email,
          'full_name': fullName,
          'avatar_url': null,
          'created_at': DateTime.now().toIso8601String(),
        });
        
        await _fetchUserProfile();
        return true;
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
    final userId = SupabaseConfig.client.auth.currentUser?.id;
    
    if (userId == null) {
      _currentUser = null;
      return;
    }
    
    final data = await SupabaseConfig.client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    
    _currentUser = UserModel.fromJson(data);
  }

  /// Clear any error messages
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
