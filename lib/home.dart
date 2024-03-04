import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  late File _image;
  List _disasters = [];
  final ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  detectDisaster(File image) async {
    var prediction = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 4,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _disasters = prediction!;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _loadImageFromGallery() async {
    var imageFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile == null) {
      return null;
    } else {
      _image = File(imageFile.path);
    }
    detectDisaster(_image);
  }

  _loadImageUsingCamera() async {
    var imageFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (imageFile == null) {
      return null;
    } else {
      _image = File(imageFile.path);
    }
    detectDisaster(_image);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ML Model",
          style: GoogleFonts.roboto(),
        ),
      ),
      body: Container(
        height: height,
        width: width,
        color: Colors.grey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  _loadImageFromGallery();
                },
                child: Text(
                  "Choose from gallery",
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  _loadImageUsingCamera();
                },
                child: Text(
                  "Take a picture",
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            _loading == false
                ? Column(
                    children: [
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: Image.file(_image),
                      ),
                      Text(
                        // _disasters[0]['label'].toString().substring(2),
                        _disasters[0]['confidence'] > 0.865
                            ? _disasters[0]['label'].toString().substring(2)
                            : 'Mums cat',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Confidence: ${_disasters[0]['confidence']}",
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
