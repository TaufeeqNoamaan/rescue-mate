import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class Auth1 extends StatefulWidget {
  const Auth1({super.key});

  @override
  State<Auth1> createState() => _Auth1State();
}

class _Auth1State extends State<Auth1> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/auth');
                    },
                    child: Text('Take a snap!')))
          ],
        ),
      ),
    );
  }
}

