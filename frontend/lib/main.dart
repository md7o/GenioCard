import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genio_card/pages/home/HomePage.dart';
import 'package:genio_card/provider/ThemeProvider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Flutter App',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light, // Set the theme mode
      darkTheme: ThemeData.dark(), // Dark theme
      theme: ThemeData.light(), // Light theme
      home: const HomePage(),
    );
  }
}
