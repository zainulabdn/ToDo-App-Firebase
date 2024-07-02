import 'package:flutter/material.dart';
import 'package:haztech_task/Core/Constants/colors.dart';
import 'package:haztech_task/Core/Constants/extension.dart';

import 'package:haztech_task/UI/custom_widgets/custom_buttons.dart';
import 'package:haztech_task/UI/custom_widgets/custom_textfield.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';

class SettingsBottomSheet extends StatefulWidget {
  final String fname;
  final String lname;
  final String age;
  final String gender;
  final bool isstatistics;
  final String profilePicture;
  final Function(String) onUsernameChanged;
  final Function(String) onlUsernameChanged;

  final Function(String) onAgeChanged;
  final Function(String) onGenderChanged;
  final Function() onUpdatePressed;
  final Function() onUpdateChangePassword;
  final Function() onUpdateChangeCategories;

  final Function() onLogoutPressed;
  final Function(File) onProfilePictureUpdate;

  final Function() onStatistics;

  const SettingsBottomSheet({
    super.key,
    required this.fname,
    required this.lname,
    this.isstatistics = false,
    required this.onStatistics,
    required this.profilePicture,
    required this.onUsernameChanged,
    required this.onlUsernameChanged,
    required this.onAgeChanged,
    required this.onGenderChanged,
    required this.onProfilePictureUpdate,
    required this.onUpdateChangePassword,
    required this.age,
    required this.gender,
    required this.onUpdatePressed,
    required this.onLogoutPressed,
    required this.onUpdateChangeCategories,
  });

  @override
  _SettingsBottomSheetState createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        widget.onProfilePictureUpdate(_image!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'User Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: _pickImage,
              child: Builder(
                builder: (context) {
                  ImageProvider<Object> backgroundImage;
                  if (_image != null) {
                    backgroundImage = FileImage(_image!);
                  } else if (widget.profilePicture.isNotEmpty) {
                    backgroundImage = NetworkImage(widget.profilePicture);
                  } else {
                    backgroundImage = const NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWPqHdKoi3FugPVXdZeLRj93CsVmfC6CLPxVf2qnDcqj5ShJJLztAha5HslKYfU9TcakI&usqp=CAU');
                  }

                  return CircleAvatar(
                    radius: 50,
                    backgroundImage: backgroundImage,
                    child: _image == null && (widget.profilePicture.isEmpty)
                        ? const Icon(Icons.camera_alt, color: kWhite)
                        : null,
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: TextEditingController(text: widget.fname),
                    hintText: widget.fname,
                    prefixIcon: const Icon(Icons.person),
                    onChanged: (value) {
                      widget.onUsernameChanged(value);
                    },
                  ),
                ),
                20.widthBox,
                Expanded(
                  child: CustomTextField(
                    controller: TextEditingController(text: widget.lname),
                    hintText: widget.lname,
                    prefixIcon: const Icon(Icons.person),
                    onChanged: (value) {
                      widget.onlUsernameChanged(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: TextEditingController(text: widget.age),
              hintText: widget.age,
              prefixIcon: const Icon(Icons.cake),
              onChanged: (value) {
                widget.onAgeChanged(value);
              },
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: TextEditingController(text: widget.gender),
              hintText: widget.gender,
              prefixIcon: const Icon(Icons.person_outline),
              onChanged: (value) {
                widget.onGenderChanged(value);
              },
            ),
            const SizedBox(height: 16.0),
            widget.isstatistics
                ? MyButtonLong(
                    name: 'Statistics & Achievements',
                    onTap: widget.onStatistics)
                : const SizedBox(),
            widget.isstatistics
                ? const SizedBox(height: 16.0)
                : const SizedBox(),
            MyButtonLong(name: 'Update Profile', onTap: widget.onUpdatePressed),
            const SizedBox(height: 16.0),
            MyButtonLong(
                name: 'Change Password', onTap: widget.onUpdateChangePassword),
            const SizedBox(height: 16.0),
            widget.isstatistics
                ? const SizedBox()
                : MyButtonLong(
                    name: 'Edit Selected Categories',
                    onTap: widget.onUpdateChangeCategories),
            const SizedBox(height: 16.0),
            MyButtonLong(
              name: 'Logout',
              onTap: widget.onLogoutPressed,
              color: Colors.red,
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

class OtherSettingsBottomSheet extends StatelessWidget {
  final Function() onStatistics;
  final Function() onHistory;

  final Function() onFeedback;

  const OtherSettingsBottomSheet({
    super.key,
    required this.onStatistics,
    required this.onFeedback,
    required this.onHistory,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Settings',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            const SizedBox(height: 16.0),
            MyButtonLong(
                name: 'Statistics & Achievements', onTap: onStatistics),
            const SizedBox(height: 16.0),
            MyButtonLong(name: 'History', onTap: onHistory),
            const SizedBox(height: 16.0),
            MyButtonLong(name: 'FeedBack', onTap: onFeedback),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

/// admin dialog
class AdminSettingsBottomSheet extends StatefulWidget {
  final String fname;
  final String lname;
  final String age;
  final String gender;
  final bool isstatistics;
  final String profilePicture;
  final Function(String) onUsernameChanged;
  final Function(String) onlUsernameChanged;

  final Function(String) onAgeChanged;
  final Function(String) onGenderChanged;
  final Function() onUpdatePressed;
  final Function() onUpdateChangePassword;
  final Function() onUpdateChangeCategories;

  final Function() onLogoutPressed;
  final Function(File) onProfilePictureUpdate;

  final Function() onStatistics;

  const AdminSettingsBottomSheet({
    super.key,
    required this.fname,
    required this.lname,
    this.isstatistics = false,
    required this.onStatistics,
    required this.profilePicture,
    required this.onUsernameChanged,
    required this.onlUsernameChanged,
    required this.onAgeChanged,
    required this.onGenderChanged,
    required this.onProfilePictureUpdate,
    required this.onUpdateChangePassword,
    required this.age,
    required this.gender,
    required this.onUpdatePressed,
    required this.onLogoutPressed,
    required this.onUpdateChangeCategories,
  });

  @override
  _AdminSettingsBottomSheetState createState() =>
      _AdminSettingsBottomSheetState();
}

class _AdminSettingsBottomSheetState extends State<AdminSettingsBottomSheet> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        widget.onProfilePictureUpdate(_image!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Admin Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: _pickImage,
              child: Builder(
                builder: (context) {
                  ImageProvider<Object> backgroundImage;
                  if (_image != null) {
                    backgroundImage = FileImage(_image!);
                  } else if (widget.profilePicture.isNotEmpty) {
                    backgroundImage = NetworkImage(widget.profilePicture);
                  } else {
                    backgroundImage = const NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWPqHdKoi3FugPVXdZeLRj93CsVmfC6CLPxVf2qnDcqj5ShJJLztAha5HslKYfU9TcakI&usqp=CAU');
                  }

                  return CircleAvatar(
                    radius: 40,
                    backgroundImage: backgroundImage,
                    child: _image == null && (widget.profilePicture.isEmpty)
                        ? const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          )
                        : null,
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: TextEditingController(text: widget.fname),
                    hintText: widget.fname,
                    prefixIcon: const Icon(Icons.person),
                    onChanged: (value) {
                      widget.onUsernameChanged(value);
                    },
                  ),
                ),
                20.widthBox,
                Expanded(
                  child: CustomTextField(
                    controller: TextEditingController(text: widget.lname),
                    hintText: widget.lname,
                    prefixIcon: const Icon(Icons.person),
                    onChanged: (value) {
                      widget.onlUsernameChanged(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: TextEditingController(text: widget.age),
              hintText: widget.age,
              prefixIcon: const Icon(Icons.cake),
              onChanged: (value) {
                widget.onAgeChanged(value);
              },
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: TextEditingController(text: widget.gender),
              hintText: widget.gender,
              prefixIcon: const Icon(Icons.person_outline),
              onChanged: (value) {
                widget.onGenderChanged(value);
              },
            ),
            const SizedBox(height: 16.0),
            widget.isstatistics
                ? MyButtonLong(
                    name: 'Statistics & Achievements',
                    onTap: widget.onStatistics)
                : const SizedBox(),
            widget.isstatistics
                ? const SizedBox(height: 16.0)
                : const SizedBox(),
            MyButtonLong(name: 'Update Profile', onTap: widget.onUpdatePressed),
            const SizedBox(height: 16.0),
            MyButtonLong(
                name: 'Change Password', onTap: widget.onUpdateChangePassword),
            const SizedBox(height: 16.0),
            MyButtonLong(
              name: 'Logout',
              onTap: widget.onLogoutPressed,
              color: Colors.red,
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
