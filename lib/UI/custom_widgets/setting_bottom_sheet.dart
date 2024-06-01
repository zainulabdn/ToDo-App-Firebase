import 'package:flutter/material.dart';
import 'package:haztech_task/UI/custom_widgets/custom_buttons.dart';
import 'package:haztech_task/UI/custom_widgets/custom_textfield.dart';

class SettingsBottomSheet extends StatelessWidget {
  final String username;
  final bool isstatistics;
  final Function(String) onUsernameChanged;
  final Function() onUpdatePressed;
  final Function() onLogoutPressed;
  final Function() onStatistics;

  const SettingsBottomSheet({
    super.key,
    required this.username,
    this.isstatistics = false,
    required this.onStatistics,
    required this.onUsernameChanged,
    required this.onUpdatePressed,
    required this.onLogoutPressed,
  });

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
            CustomTextField(
              controller: TextEditingController(text: username),
              hintText: username,
              prefixIcon: const Icon(Icons.person),
              onChanged: (value) {
                onUsernameChanged(value);
              },
            ),
            const SizedBox(height: 16.0),
            isstatistics
                ? MyButtonLong(name: 'Statistics', onTap: onStatistics)
                : const SizedBox(),
            isstatistics ? const SizedBox(height: 16.0) : const SizedBox(),
            MyButtonLong(name: 'Update Profile', onTap: onUpdatePressed),
            const SizedBox(height: 16.0),
            MyButtonLong(
              name: 'Logout',
              onTap: onLogoutPressed,
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
            MyButtonLong(name: 'Statistics', onTap: onStatistics),
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
