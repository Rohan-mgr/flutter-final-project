import 'package:flutter/material.dart';

class EditProfileDialog extends StatefulWidget {
  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  String firstName = "";
  String lastName = "";
  String profilePicUrl = "";

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Update user profile or perform actions here with the data
      print(
          'First Name: $firstName, Last Name: $lastName, Profile Picture: $profilePicUrl');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'First Name',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
              onSaved: (value) => firstName = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Last Name',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
              onSaved: (value) => lastName = value!,
            ),
            Row(
              children: [
                Text(
                  profilePicUrl.isEmpty
                      ? 'Change Profile Picture'
                      : profilePicUrl,
                  style: const TextStyle(fontSize: 14),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {
                    // Implement logic to choose a profile picture (e.g., using image picker)
                    // Update profilePicUrl with the chosen image url
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: submitForm,
          child: const Text('Update'),
        ),
      ],
    );
  }
}
