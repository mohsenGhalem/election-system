import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/candidate.dart';
import '../models/voter.dart';
import '../services/local_storage_service.dart';

enum UserRole { voter, candidate }

class AuthContoller extends GetxController {
  final GlobalKey<FormBuilderState> registerFormKey =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> loginFormKey =
      GlobalKey<FormBuilderState>();
  Rx<UserRole> selectedRole = UserRole.voter.obs;

  void changeRole(UserRole role) {
    selectedRole.value = role;
    update();
  }

  Future<bool> login() async {
    try {
      Map<String, dynamic> formData = loginFormKey.currentState!.value;

      var client = Supabase.instance.client;
      var response = await client.auth.signInWithPassword(
        email: formData['email'],
        password: formData['password'],
      );

      String user_id = response.user!.id;
      Map<String, dynamic> userType = await client
          .from('users')
          .select('user_type')
          .eq('user_id', user_id)
          .single();
      LocalStorageService localStorageService = LocalStorageServiceImpl();

      if (userType['user_type'] == 'voter') {
        List<dynamic> voter_data =
            await client.from('voters').select().eq('user_id', user_id);

        Voter voter = Voter.fromMap(voter_data[0]);
        await localStorageService.saveCurrentUser(voter: voter);
      } else if (userType['user_type'] == 'candidate') {
        Map<String, dynamic> candidate_data = await client
            .from('candidates')
            .select('*')
            .eq('user_id', user_id)
            .single() as Map<String, dynamic>;

        Candidate candidate = Candidate.fromMap(candidate_data);
        await localStorageService.saveCurrentUser(candidate: candidate);
      } else if (userType['user_type'] == 'admin') {
        client.auth.signOut();
        return false;
      }

      return true;
    } catch (e) {
      var client = Supabase.instance.client;
      client.auth.signOut();
      debugPrint('login ERROR: $e');
      return false;
    }
  }

  Future<bool> register() async {
    try {
      Map<String, dynamic> formData = registerFormKey.currentState!.value;

      var client = Supabase.instance.client;
      await client.auth.signUp(
        email: formData['email'],
        password: formData['password'],
      );
      String user_id = client.auth.currentUser!.id;
      if (selectedRole.value == UserRole.voter) {
        Voter voter = Voter.fromMap(formData);

        await client.from('users').insert({
          'user_id': user_id,
          'user_type': 'voter',
        });

        final data = voter.toMap();

        data['user_id'] = user_id;
        data.remove('voter_id');
        await client.from('voters').insert(data);

        LocalStorageService localStorageService = LocalStorageServiceImpl();
        await localStorageService.saveCurrentUser(voter: voter);
      }
      if (selectedRole.value == UserRole.candidate) {
        Candidate candidate = Candidate.fromMap(formData);

        await client.from('users').insert({
          'user_id': user_id,
          'user_type': 'candidate',
        });

        final data = candidate.toMap();
        data['user_id'] = user_id;
        data.remove('candidate_id');
        await client.from('candidates').insert(data);

        LocalStorageService localStorageService = LocalStorageServiceImpl();
        await localStorageService.saveCurrentUser(candidate: candidate);
      }
      return true;
    } catch (e) {
      debugPrint('register ERROR: $e');
      return false;
    }
  }
}
