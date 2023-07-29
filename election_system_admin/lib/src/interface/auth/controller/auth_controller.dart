import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/admin.dart';
import '../../../models/security_log.dart';
import '../../../services/local_storage_service.dart';

enum AuthState {
  login,
  signup,
}

class AuthController extends GetxController {
  Map<String, String> authData = {
    'email': '',
    'password': '',
    'name': '',
  };

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  Rx<AuthState> authState = AuthState.login.obs;
  String errorMsg = '';

  void setEmail(String email) {
    authData['email'] = email;
  }

  void setPassword(String password) {
    authData['password'] = password;
  }

  void setName(String name) {
    authData['name'] = name;
  }

  void setAuthState(AuthState state) {
    authState.value = state;
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    update();
  }

  Future<bool?> signIn() async {
    try {
      final SupabaseClient supabaseClient = Supabase.instance.client;

      final res = await supabaseClient.auth.signInWithPassword(
        password: authData['password']!,
        email: authData['email']!,
      );
      String uid = '';

      if (res.user != null) {
        uid = res.user!.id;
        final data = await supabaseClient
            .from('admins')
            .select('admin_status')
            .eq('user_id', uid)
            .single();

        if (data['admin_status'] == 'accepted') {
          final adminData = await supabaseClient
              .from('admins')
              .select()
              .eq('user_id', uid)
              .single();

          final SecurityLog securityLog = SecurityLog(
              user_id: uid,
              action_description: 'Login to the system',
              log_date: DateTime.now());
          await supabaseClient
              .from('security_logs')
              .insert(securityLog.toMap());
          Admin admin = Admin.fromMap(adminData);
          LocalStorageService localStorageService = LocalStorageServiceImpl();
          await localStorageService.saveCurrentUser(admin: admin);
          return true;
        } else if (data['admin_status'] == 'pending') {
          await supabaseClient.auth.signOut();
          throw Exception('your login still not approved yet !');
        } else {
          await supabaseClient.auth.signOut();
          throw Exception('your not authorized to login here !');
        }
      } else {
        throw Exception('user not found !');
      }
    } on AuthException catch (e) {
      errorMsg = e.message;
      debugPrint(e.toString());
      return false;
    } on PostgrestException catch (e) {
      errorMsg = e.details;
      debugPrint(e.toString());
      return false;
    } catch (e) {
      debugPrint(e.toString());
      errorMsg = e.toString();
      return false;
    }
  }

  Future<bool> signUp() async {
    try {
      final SupabaseClient supabaseClient = Supabase.instance.client;
      final AuthResponse res = await supabaseClient.auth.signUp(
        email: authData['email'],
        password: authData['password']!,
      );

      final Admin admin = Admin(
          user_id: res.user!.id,
          full_name: authData['name']!,
          admin_status: 'pending');

      await supabaseClient
          .from('users')
          .insert({'user_id': admin.user_id, 'user_type': 'admin'});
      final adminData = admin.toMap();
      adminData.remove('admin_id');
      await supabaseClient.from('admins').insert(adminData);
      setAuthState(AuthState.login);
      throw Exception(
          "registred successfully you'll get notifed when your account get approved ");
    } on AuthException catch (e) {
      debugPrint(e.toString());
      errorMsg = e.message;
      if (e.statusCode == '429') {
        errorMsg = 'Email already linked to other account';
      }
      debugPrint(e.toString());
      return false;
    } on PostgrestException catch (e) {
      errorMsg = e.details;
      debugPrint(e.toString());
      return false;
    } on Exception catch (e) {
      debugPrint(e.toString());
      errorMsg = e.toString();
      return false;
    }
  }
}
