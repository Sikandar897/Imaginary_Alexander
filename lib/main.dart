import 'package:flutter/material.dart';
import 'package:imaginary_alexander/views/splash_screen.dart';
import 'package:provider/provider.dart';
import 'viewmodels/prompt_viewmodel.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PromptViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
          elevation: 0,
        ),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey.shade900,
      ),
      home: const SplashScreen(),
    );
  }
}
