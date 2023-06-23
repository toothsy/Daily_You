import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:daily_you/entries_database.dart';
import 'package:daily_you/theme_mode_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _showThemeSelectionPopup(ThemeModeProvider themeModeProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Theme:'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Follow System'),
                onTap: () => setState(() {
                  ConfigManager().setField('theme', 'system');
                  _updateTheme(themeModeProvider, ThemeMode.system);
                }),
              ),
              ListTile(
                title: const Text('Dark Theme'),
                onTap: () => setState(() {
                  ConfigManager().setField('theme', 'dark');
                  _updateTheme(themeModeProvider, ThemeMode.dark);
                }),
              ),
              ListTile(
                  title: const Text('Light Theme'),
                  onTap: () => setState(() {
                        ConfigManager().setField('theme', 'light');
                        _updateTheme(themeModeProvider, ThemeMode.light);
                      })),
            ],
          ),
        );
      },
    );
  }

  void _updateTheme(ThemeModeProvider themeModeProvider, ThemeMode mode) {
    themeModeProvider.themeMode = mode;
    // setState(() {
    //   currentThemeMode = mode;
    // });
    Navigator.pop(context); // Close the popup
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const Row(
            children: [
              Text(
                "Appearance",
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Theme",
                  style: TextStyle(fontSize: 18),
                ),
                ElevatedButton.icon(
                  icon: Icon(
                    themeProvider.themeMode == ThemeMode.system
                        ? Icons.brightness_medium
                        : themeProvider.themeMode == ThemeMode.light
                            ? Icons.brightness_high
                            : Icons.brightness_2_rounded,
                  ),
                  label: themeProvider.themeMode == ThemeMode.system
                      ? const Text("System")
                      : themeProvider.themeMode == ThemeMode.light
                          ? const Text("Light")
                          : const Text("Dark"),
                  onPressed: () async {
                    ConfigManager().setField('theme', 'system');
                    _showThemeSelectionPopup(themeProvider);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          const Row(
            children: [
              Text(
                "Storage",
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Database Path",
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.folder_copy_rounded,
                      ),
                      label: const Text("Set Database Path..."),
                      onPressed: () async {
                        if (Platform.isAndroid) {
                          var status =
                              await Permission.manageExternalStorage.request();
                          if (status.isDenied || status.isPermanentlyDenied) {
                            return;
                          }
                        }
                        EntriesDatabase.instance.selectDatabaseLocation();
                      },
                    ),
                    IconButton(
                        onPressed: () async {
                          EntriesDatabase.instance.resetDatabaseLocation();
                        },
                        icon: const Icon(Icons.refresh_rounded))
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Image Folder",
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.folder_copy_rounded,
                      ),
                      label: const Text("Set Image Folder..."),
                      onPressed: () async {
                        if (Platform.isAndroid) {
                          var status =
                              await Permission.manageExternalStorage.request();
                          if (status.isDenied || status.isPermanentlyDenied) {
                            return;
                          }
                        }
                        EntriesDatabase.instance.selectImageFolder();
                      },
                    ),
                    IconButton(
                        onPressed: () async {
                          EntriesDatabase.instance.resetImageFolderLocation();
                        },
                        icon: const Icon(Icons.refresh_rounded))
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          const Row(
            children: [
              Text(
                "About",
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Version",
                  style: TextStyle(fontSize: 18),
                ),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.new_releases_rounded,
                  ),
                  label: const Text("v1.0"),
                  onPressed: () async {
                    await launchUrl(Uri.https("github.com", "/Demizo/Jotterly"),
                        mode: LaunchMode.externalApplication);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "License",
                  style: TextStyle(fontSize: 18),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.gavel_rounded),
                  label: const Text("GPL v3"),
                  onPressed: () async {
                    await launchUrl(Uri.https("github.com", "/Demizo/Jotterly"),
                        mode: LaunchMode.externalApplication);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Source Code",
                  style: TextStyle(fontSize: 18),
                ),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.code_rounded,
                  ),
                  label: const Text("Github"),
                  onPressed: () async {
                    await launchUrl(Uri.https("github.com", "/Demizo/Jotterly"),
                        mode: LaunchMode.externalApplication);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
