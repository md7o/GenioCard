import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final themeProvider = StateProvider<bool>((ref) {
  final box = Hive.box('localBox');
  return box.get('isDarkMode', defaultValue: false);
});
