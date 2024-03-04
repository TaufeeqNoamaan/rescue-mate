import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  File? images;
  String scan = "";
  String base = "";
  String name = "";
  String age = "";
  String gender = "";
  String aad = "";
  String add = "";
  String fname = "";
  String sname = "";

  Future<void> i() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.camera);
      scan = "";
      final tex = await GoogleMlKit.vision
          .textRecognizer()
          .processImage(InputImage.fromFilePath(img!.path));
      setState(() {
        aad = "";
        fname = "";
        sname = "";
        age = "";
        gender = "";
        name = "";
        images = File(img.path);
        final lines = tex.text.split('\n');

        for (final line in lines) {
          if (line.toLowerCase().contains('dob') ||
              line.toLowerCase().contains("year")) {
            var s = line.split(": ");
            var tl = s[1];
            if (tl.contains("/")) {
              var r = tl.split("/");

              String p = r[0] + r[1] + r[2];
              age = p;
            } else {
              age = tl;
            }
          }
          if (line.toLowerCase().contains("male") ||
              line.toLowerCase().contains("female")) {
            line.toLowerCase().contains('male') ? gender = "MALE" : null;
            line.toLowerCase().contains('female') ? gender = "FEMALE" : null;
          }
          if (line.length == 14 && !line.toLowerCase().contains("a")) {
            add = line;

            var l = line.split(" ");
            aad = l[0] + l[1] + l[2];
          }
          if (!line.toLowerCase().contains("male") &&
              !line.toLowerCase().contains("female") &&
              !line.toLowerCase().contains('year') &&
              !line.toLowerCase().contains("government of india") &&
              !line.toLowerCase().contains('aadhar') &&
              !line.toLowerCase().contains('/') &&
              !line.toLowerCase().contains('-') &&
              !line.toLowerCase().contains('1') &&
              !line.toLowerCase().contains('2') &&
              !line.toLowerCase().contains('qr') &&
              !line.toLowerCase().contains('photo') &&
              !line.toLowerCase().contains('signature')) {
            name = "";
            fname = "";
            sname = "";
            var h = line.split(" ");

            fname = h[0];
            print(h.length);
            for (int i = 1; i <= h.length - 1; i++) {
              sname = sname + " " + h[i];
            }

            name = line.toString();
          } else {
            scan = "$scan$line\n";
          }
        }
      });
    } catch (e) {
      setState(() {
        images = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Test'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 70,
              ),
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(21)),
                child: images != null ? Image.file(images!) : null,
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                      onPressed: () async {
                        i();

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => next(
                        //               scan: scan,
                        //               img: images!,
                        //             )));
                      },
                      icon: Icon(Icons.camera),
                      label: Text("Scan")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/home');
                      },
                      child: Text('Home page'))
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
                    color: Colors.grey),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    fname == "" ? Text("") : Text(fname),
                    sname == "" ? Text("") : Text(sname),
                    name == "" ? Text("") : Text(name),
                    age == "" ? Text("") : Text(age),
                    gender == "" ? Text("") : Text(gender),
                    aad == "" ? Text("") : Text(aad),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
