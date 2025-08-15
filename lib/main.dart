import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/ui/sreen/login/login_screen.dart';
import 'package:loving/ui/theme.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loving',
      theme: ThemeData(
        colorScheme: colorScheme(context),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          color: const Color(0xFF717DBA),
          titleTextStyle: textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontSize: 20,
          ),
          actionsIconTheme: const IconThemeData(color: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
