import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase client configuration
class SupabaseConfig {
  // TODO: Replace with your actual Supabase URL and anon key
  static const String supabaseUrl = 'https://ucwjaozjvjvlktcqgjci.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVjd2phb3pqdmp2bGt0Y3FnamNpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY3MjQyNDEsImV4cCI6MjA3MjMwMDI0MX0.60SXClUG7cRUn4LwyUDKDzzzzW2tMXr09KQaoi5Sbb8';
  
  /// Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
  
  /// Get instance of Supabase client
  static SupabaseClient get client => Supabase.instance.client;
}
