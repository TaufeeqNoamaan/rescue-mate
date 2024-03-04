import 'package:flutter/material.dart';
import 'package:mlmodel/auth/auth_1.dart';
import 'package:mlmodel/auth/auth_page.dart';
import 'package:mlmodel/home.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ML Model',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,

      home: const AuthPage(),
      routes: {
        '/home':(context) => Home(),
        '/auth':(context) => AuthPage()
      },
    );
  }
}
