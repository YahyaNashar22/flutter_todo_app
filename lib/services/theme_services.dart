// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// class ThemeServices {
//   final GetStorage _box = GetStorage();
//   final _key = "isDarkMode";

//   void _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

//   bool _loadThemeFromBox() => _box.read<bool>(_key) ?? false;

//   ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

//   void switchTheme() {
//     Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
//     _saveThemeToBox(!_loadThemeFromBox());
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices extends GetxController {
  final GetStorage _box = GetStorage();
  final _key = "isDarkMode";

  // Observable for theme mode
  final RxBool isDarkMode = false.obs;

  ThemeServices() {
    // Initialize with the stored theme value
    isDarkMode.value = _loadThemeFromBox();
  }

  void _saveThemeToBox(bool value) => _box.write(_key, value);

  bool _loadThemeFromBox() => _box.read<bool>(_key) ?? false;

  ThemeMode get theme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
    // Toggle the theme mode
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _saveThemeToBox(isDarkMode.value);
  }
}
