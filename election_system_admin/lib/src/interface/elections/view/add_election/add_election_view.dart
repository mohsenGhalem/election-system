import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/widgets/loading_dialog.dart';
import '../../../../common/widgets/snack_bar.dart';
import '../../../../models/election.dart';
import '../../../../services/election_service.dart';

class AddElectionView extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  const AddElectionView({super.key, this.initialData});

  @override
  State<AddElectionView> createState() => _AddElectionViewState();
}

class _AddElectionViewState extends State<AddElectionView> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  File? _pickedImage;
  Map<String, dynamic> _formData = {};

  void _pickImage() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
    }
  }

  void _initializeFormData() {
    if (widget.initialData != null) {
      _formData = Map.from(widget.initialData!);

      _formData['start_date'] = DateTime.parse(_formData['start_date']);
      _formData['end_date'] = DateTime.parse(_formData['end_date']);
      _formData['deadline_date'] = DateTime.parse(_formData['deadline_date']);
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
          title: Text(
            _formData.isEmpty ? 'Adding Election' : 'Editing Election',
            style: const TextStyle(color: Colors.white),
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
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            initialValue: _formData,
            child: ListView(
              children: [
                InkWell(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _pickedImage == null
                        ? (_formData['election_image'] == null &&
                                _formData['election_image'] == '')
                            ? Image.network(
                                _formData['election_image'] ?? '',
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image,
                                        size: 60, color: Colors.grey),
                              )
                            : const Icon(Icons.image,
                                size: 60, color: Colors.grey)
                        : Image.file(_pickedImage!, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'election_name',
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Election Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'description',
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Election Description',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 10),
                FormBuilderDateTimePicker(
                  name: 'start_date',
                  inputType: InputType.date,
                  format: DateFormat('yyyy-MM-dd'),
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Start Date',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 10),
                FormBuilderDateTimePicker(
                  name: 'end_date',
                  inputType: InputType.date,
                  format: DateFormat('yyyy-MM-dd'),
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'End Date',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 10),
                FormBuilderDateTimePicker(
                  name: 'deadline_date',
                  inputType: InputType.date,
                  format: DateFormat('yyyy-MM-dd'),
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Deadline Date',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 10),
                FormBuilderSwitch(
                  name: 'is_active',
                  title: const Text('Active Election?'),
                  inactiveTrackColor: Colors.grey,
                  decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      Map<String, dynamic> formData =
                          _formKey.currentState!.value;

                      Election election = Election.fromMap(formData);

                      election.election_id = _formData['election_id'];

                      Get.dialog(
                        LoadingDialog(
                          future: _formData.isEmpty
                              ? addElection(
                                  election: election, image: _pickedImage)
                              : updateElection(
                                  election: election, image: _pickedImage),
                        ),
                        barrierDismissible: false,
                      ).then(
                        (value) {
                          if (value == true) {
                            Get.offNamedUntil('/home', (route) => false);
                            Get.showSnackbar(
                              buildSnackBar(
                                  title: 'Success',
                                  color: Colors.green,
                                  message: _formData.isEmpty
                                      ? 'Election added successfully'
                                      : 'Election updated successfully'),
                            );
                          } else {
                            Get.showSnackbar(
                              buildSnackBar(
                                  title: 'Error',
                                  color: Colors.red,
                                  message: _formData.isEmpty
                                      ? 'An error occured while adding election'
                                      : 'An error occured while updating election'),
                            );
                          }
                        },
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> addElection({required Election election, File? image}) async {
    ElectionService electionService =
        ElectionServiceImpl(client: Supabase.instance.client);

    final response =
        await electionService.createElection(election: election, image: image);
    if (response.isLeft()) {
      return false;
    }
    return true;
  }

  Future<bool> updateElection({required Election election, File? image}) async {
    ElectionService electionService =
        ElectionServiceImpl(client: Supabase.instance.client);

    final response =
        await electionService.updateElection(election: election, image: image);
    if (response.isLeft()) {
      return false;
    }
    return true;
  }
}
