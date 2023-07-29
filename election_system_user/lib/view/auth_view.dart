import 'package:election_system_user/widgets/loading_dialog.dart';
import 'package:election_system_user/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/auth_controller.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthContoller contoller = Get.put(AuthContoller());
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: const TabBar(
            tabs: [
              Tab(
                text: 'login',
                icon: Icon(Icons.person),
              ),
              Tab(
                text: 'register',
                icon: Icon(Icons.person_add),
              )
            ],
          ),
          backgroundColor: Colors.white,
          body: TabBarView(
            children: [
              LoginForm(contoller: contoller),
              RegisterForm(contoller: contoller),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
    required this.contoller,
  });

  final AuthContoller contoller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FormBuilder(
        key: contoller.registerFormKey,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            FormBuilderRadioGroup(
              name: 'role',
              initialValue: UserRole.voter,
              options: const [
                FormBuilderFieldOption(
                  value: UserRole.voter,
                  child: Text('Voter'),
                ),
                FormBuilderFieldOption(
                  value: UserRole.candidate,
                  child: Text('Candidate'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  contoller.changeRole(value);
                }
              },
              decoration: const InputDecoration(
                labelText: 'Select Role',
              ),
            ),
            const SizedBox(height: 10),
            FormBuilderTextField(
              name: 'email',
              decoration: const InputDecoration(
                labelText: 'Email',
                filled: true,
                border: OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ]),
            ),
            const SizedBox(height: 10),
            FormBuilderTextField(
              name: 'password',
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                filled: true,
                border: OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(6),
              ]),
            ),
            const SizedBox(height: 10),
            FormBuilderTextField(
              name: 'full_name',
              decoration: const InputDecoration(
                labelText: 'Full Name',
                filled: true,
                border: OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(height: 10),
            FormBuilderDateTimePicker(
              name: 'birth_date',
              inputType: InputType.date,
              format: DateFormat('yyyy-MM-dd'),
              decoration: const InputDecoration(
                labelText: 'Birth Date',
                filled: true,
                border: OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.required(),
            ),
            if (contoller.selectedRole.value == UserRole.candidate) ...[
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'party_affiliation',
                decoration: const InputDecoration(
                  labelText: 'Party Affiliation',
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'candidate_statement',
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Statement',
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                validator: FormBuilderValidators.required(),
              ),
            ] else ...[
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'address',
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                validator: FormBuilderValidators.required(),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (contoller.registerFormKey.currentState!.saveAndValidate()) {
                  Get.dialog(
                    LoadingDialog(
                      future: contoller.register(),
                    ),
                  ).then(
                    (value) {
                      if (value == true) {
                        Get.offAllNamed('/home');
                      } else {
                        Get.showSnackbar(
                          buildSnackBar(
                            title: 'Error',
                            color: Colors.red,
                            message: 'Register failed',
                          ),
                        );
                      }
                    },
                  );
                }
              },
              child: const Text(
                'Register',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.contoller,
  });

  final AuthContoller contoller;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: contoller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Online Election System', style: Get.textTheme.headlineSmall),
            const SizedBox(height: 20),
            FormBuilderTextField(
              name: 'email',
              decoration: const InputDecoration(
                labelText: 'Email',
                filled: true,
                border: OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ]),
            ),
            const SizedBox(height: 10),
            FormBuilderTextField(
              name: 'password',
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                filled: true,
                border: OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(6),
              ]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (contoller.loginFormKey.currentState!.saveAndValidate()) {
                  Get.dialog(
                    LoadingDialog(
                      future: contoller.login(),
                    ),
                  ).then(
                    (value) {
                      if (value == true) {
                        Get.offAllNamed('/home');
                      } else {
                        Get.showSnackbar(
                          buildSnackBar(
                            title: 'Error',
                            color: Colors.red,
                            message: 'Login failed',
                          ),
                        );
                      }
                    },
                  );
                }
              },
              child: const Text(
                'login',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
