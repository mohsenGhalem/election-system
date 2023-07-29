import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../common/widgets/loading_dialog.dart';
import '../../common/widgets/snack_bar.dart';
import '../../models/admin.dart';
import '../../services/admin_services.dart';
import '../requests/controller/request_controller.dart';

class AdminProfileView extends StatefulWidget {
  final Map<String, dynamic> userData;
  const AdminProfileView({super.key, required this.userData});

  @override
  State<AdminProfileView> createState() => _AdminProfileViewState();
}

class _AdminProfileViewState extends State<AdminProfileView> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  File? _pickedImage;
  Map<String, dynamic> _initialData = {};

  void _pickImage() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
        _initialData['admin_image'] = _pickedImage;
      });
    }
  }

  @override
  void initState() {
    _initialData = widget.userData;
    _initialData.addAll(
        {'email': Supabase.instance.client.auth.currentUser?.email ?? ''});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: const Text(
          'Admin Profile',
          style: TextStyle(color: Colors.white),
        ),
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FormBuilder(
          key: _formKey,
          initialValue: _initialData,
          child: Column(
            children: [
              InkWell(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _pickedImage == null
                      ? _initialData['admin_image'] != null
                          ? CircleAvatar(
                              backgroundImage: Image.network(
                                _initialData['admin_image'],
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.person,
                                        size: 60, color: Colors.grey),
                              ).image,
                            )
                          : const Icon(Icons.person,
                              size: 60, color: Colors.grey)
                      : CircleAvatar(
                          backgroundImage: FileImage(
                            _initialData['admin_image'],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'full_name',
                decoration: const InputDecoration(
                    labelText: 'Full Name',
                    filled: true,
                    border: OutlineInputBorder()),
                validator: FormBuilderValidators.required(),
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
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.saveAndValidate()) {
                    bool op1 = true;
                    bool op2 = true;
                    bool op3 = true;
                    bool op4 = true;
                    File? imageToUpload = _pickedImage;
                    Map<String, dynamic> formData =
                        _formKey.currentState!.value;
                    Get.dialog(const LoadingDialog(future: null));
                    final RequestController controller = Get.put(
                      RequestController(
                        adminService: AdminServiceImple(
                            supabase: Supabase.instance.client),
                      ),
                    );
                    if (_initialData['full_name']
                            .toString()
                            .trim()
                            .toLowerCase() !=
                        formData['full_name'].toString().trim().toLowerCase()) {
                      Admin admin = Admin(
                          admin_id: _initialData['admin_id'],
                          full_name: formData['full_name'],
                          user_id: _initialData['user_id'],
                          admin_status: 'accepted');
                      op1 = await controller.updatePersonalInfo(
                          id: admin.admin_id!,
                          admin: admin,
                          image: imageToUpload);
                      imageToUpload = null;
                    }
                    if (_initialData['email'].toString().trim().toLowerCase() !=
                        formData['email'].toString().trim().toLowerCase()) {
                      op2 = await controller.updateEmail(
                          email: formData['email']);
                    }
                    if (formData['password'] != null &&
                        formData['password'].toString().isNotEmpty) {
                      op3 = await controller.changePassword(
                          password: formData['Password']);
                    }
                    if (imageToUpload != null) {
                      Admin admin = Admin(
                          admin_id: _initialData['admin_id'],
                          full_name: formData['full_name'],
                          user_id: _initialData['user_id'],
                          admin_status: 'accepted');
                      op4 = await controller.updatePersonalInfo(
                        id: admin.admin_id!,
                        admin: admin,
                        image: imageToUpload,
                      );
                    }

                    Get.back();
                    if (op1 && op2 && op3 && op4) {
                      Get.showSnackbar(buildSnackBar(
                        title: 'Sucess',
                        color: Colors.green,
                        message: 'Profile Updated Successfully',
                      ));
                    } else {
                      Get.showSnackbar(buildSnackBar(
                        title: 'Error',
                        color: Colors.red,
                        message: 'Something went wrong',
                      ));
                    }
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
