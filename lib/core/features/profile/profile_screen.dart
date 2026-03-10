import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/custom_svg_picture.dart';
import 'package:tasky/core/features/profile/user_details_screen.dart';
import 'package:tasky/core/features/welcome/welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String username;
  late String motivationQuote;
  String? userImagePath;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() {
      username = PreferencesManager().getString('username') ?? "";
      motivationQuote = PreferencesManager().getString('motivation_quote') ??
          "One task at a time. One step closer.";
      userImagePath = PreferencesManager().getString('user_image');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "My Profile",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            backgroundImage: userImagePath == null
                                ? AssetImage(
                                    "assets/images/Person.png",
                                  )
                                : FileImage(File(userImagePath!)),
                            radius: 55,
                            backgroundColor: Colors.transparent,
                          ),
                          GestureDetector(
                            onTap: () async {
                              showImageSourceDialog(context, (XFile file) {
                                // todo : save image
                                _saveImage(file);
                                setState(() {
                                  userImagePath = file.path;
                                });
                              });
                            },
                            child: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: Icon(
                                // color: Color(0xFFFFFCFC),
                                Icons.camera_alt_outlined,
                                size: 26,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        username,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        motivationQuote,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  'Profile Info',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                SizedBox(
                  height: 16,
                ),
                ListTile(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return UserDetailsScreen(
                            userName: username,
                            motivationQuote: motivationQuote,
                          );
                        },
                      ),
                    );
                    if (result != null && result) {
                      _loadData();
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                  leading:
                      CustomSvgPicture(path: 'assets/images/profile_icon.svg'),
                  title: Text(
                    'User Details',
                  ),
                  trailing:
                      CustomSvgPicture(path: 'assets/images/arrow_right.svg'),
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CustomSvgPicture(path: 'assets/images/moon-01.svg'),
                  title: Text(
                    'Dark Mode',
                  ),
                  trailing: ValueListenableBuilder(
                    valueListenable: ThemeController.themeNotifier,
                    builder: (context, value, Widget? child) {
                      return Switch(
                        value: value == ThemeMode.dark,
                        onChanged: (bool valu) async {
                          // Todo : Change Theme
                          ThemeController.toggelTheme();
                        },
                      );
                    },
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  onTap: () async {
                    PreferencesManager().remove('username');
                    PreferencesManager().remove('motivation_quote');
                    PreferencesManager().remove('tasks');
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return WelcomeScreen();
                        },
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: CustomSvgPicture(path: 'assets/images/log-out.svg'),
                  title: Text(
                    'Log Out',
                  ),
                  trailing:
                      CustomSvgPicture(path: 'assets/images/arrow_right.svg'),
                ),
              ],
            ),
          );
  }

  void _saveImage(XFile file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newFile = await File(file.path).copy('${appDir.path}/${file.name}');
    PreferencesManager().setString('user_image', newFile.path);
  }
}

void showImageSourceDialog(BuildContext context, Function(XFile) selectedFile) {
  showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            'Select Image Source',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.all(16),
              onPressed: () async {
                Navigator.pop(context);
                XFile? image =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                if (image != null) {
                  selectedFile(image);
                }
              },
              child: Row(
                children: [
                  Icon(Icons.camera_alt),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Camera')
                ],
              ),
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(16),
              onPressed: () async {
                Navigator.pop(context);
                XFile? image =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (image != null) {
                  selectedFile(image);
                }
              },
              child: Row(
                children: [
                  Icon(Icons.photo_library),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Gallery')
                ],
              ),
            ),
          ],
        );
      });
}
