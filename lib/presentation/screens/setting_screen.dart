import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isSoundOn = true;
  bool isVibrateOn = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSoundOn = prefs.getBool('sound') ?? true;
      isVibrateOn = prefs.getBool('vibrate') ?? true;
    });
  }

  Future<void> _saveSoundSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('sound', value);
  }

  Future<void> _saveVibrateSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('vibrate', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Sound'),
            secondary: const Icon(Icons.volume_up),
            value: isSoundOn,
            onChanged: (value) {
              setState(() {
                isSoundOn = value;
              });
              _saveSoundSetting(value);
            },
          ),
          SwitchListTile(
            title: const Text('Vibrate'),
            secondary: const Icon(Icons.vibration),
            value: isVibrateOn,
            onChanged: (value) {
              setState(() {
                isVibrateOn = value;
              });
              _saveVibrateSetting(value);
            },
          ),
        ],
      ),
    );
  }
}
