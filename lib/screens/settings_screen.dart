import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mood_pal/providers/mood_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedTone = 'soft'; // Default tone
  bool _isDarkMode = false;
  bool _isNotificationEnabled = true;
  String _appVersion = '';
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
    _getAppVersion();
  }
  
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedTone = prefs.getString('app_tone') ?? 'soft';
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
      _isNotificationEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }
  
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_tone', _selectedTone);
    await prefs.setBool('dark_mode', _isDarkMode);
    await prefs.setBool('notifications_enabled', _isNotificationEnabled);
  }
  
  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Switch between light and dark theme'),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
              _saveSettings();
            },
          ),
          _buildSectionHeader(context, 'Personality'),
          _buildToneSelector(),
          const Divider(),
          _buildSectionHeader(context, 'Notifications'),
          SwitchListTile(
            title: const Text('Daily Reminders'),
            subtitle: const Text('Remind me to log my mood daily'),
            value: _isNotificationEnabled,
            onChanged: (value) {
              setState(() {
                _isNotificationEnabled = value;
              });
              _saveSettings();
            },
          ),
          _buildSectionHeader(context, 'Data Management'),
          ListTile(
            title: const Text('Export Data'),
            subtitle: const Text('Export your mood history as a CSV file'),
            leading: const Icon(Icons.upload_file_rounded),
            onTap: () {
              // Implement data export
              _showComingSoonDialog(context);
            },
          ),
          ListTile(
            title: const Text('Clear All Data'),
            subtitle: const Text('Delete all your mood entries and creatures'),
            leading: const Icon(Icons.delete_forever_rounded, color: Colors.red),
            onTap: () {
              _showClearDataConfirmationDialog(context);
            },
          ),
          _buildSectionHeader(context, 'About'),
          ListTile(
            title: const Text('Privacy Policy'),
            leading: const Icon(Icons.privacy_tip_rounded),
            onTap: () {
              // Open privacy policy URL
              _showComingSoonDialog(context);
            },
          ),
          ListTile(
            title: const Text('Terms of Service'),
            leading: const Icon(Icons.description_rounded),
            onTap: () {
              // Open terms of service URL
              _showComingSoonDialog(context);
            },
          ),
          ListTile(
            title: const Text('Contact Support'),
            leading: const Icon(Icons.contact_support_rounded),
            onTap: () {
              // Open email client or support URL
              _showComingSoonDialog(context);
            },
          ),
          ListTile(
            title: Text('App Version: $_appVersion'),
            leading: const Icon(Icons.info_outline_rounded),
            enabled: false,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildToneSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
          child: Text(
            'MoodPal\'s Tone',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Choose how MoodPal communicates with you',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        _buildToneOption(
          'soft', 
          'Soft Mode', 
          'Gentle, supportive tone for comfort and reassurance',
          Icons.favorite_rounded,
        ),
        _buildToneOption(
          'hype', 
          'Hype Bestie', 
          'Enthusiastic, energetic tone for motivation and cheerleading',
          Icons.celebration_rounded,
        ),
        _buildToneOption(
          'honest', 
          'Honest Goblin', 
          'Direct, slightly chaotic tone for straight talk and tough love',
          Icons.psychology_rounded,
        ),
      ],
    );
  }

  Widget _buildToneOption(String value, String title, String description, IconData icon) {
    final isSelected = _selectedTone == value;
    
    return RadioListTile<String>(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(description),
      secondary: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      value: value,
      groupValue: _selectedTone,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedTone = value;
          });
          _saveSettings();
        }
      },
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Coming Soon'),
          content: const Text(
            'This feature is coming in a future update. Stay tuned!'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showClearDataConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear All Data?'),
          content: const Text(
            'This will permanently delete all your mood entries and creatures. This action cannot be undone.'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('mood_entries');
                await prefs.remove('mood_creatures');
                await prefs.remove('streak_count');
                await prefs.remove('last_entry_date');
                
                // Notify provider to reload empty state
                final moodProvider = Provider.of<MoodProvider>(context, listen: false);
                moodProvider.notifyListeners();
                
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All data has been cleared'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Clear All Data'),
            ),
          ],
        );
      },
    );
  }
}