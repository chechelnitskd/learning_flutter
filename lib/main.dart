import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

void main() {
  runApp(MaterialApp(home: MyHomePage()));
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  File? _image;
  List? _result;
  bool _isImageLoaded = true;

  String _confidence = "";
  String _name = "";
  //String _numbers = "";

  final _picker = ImagePicker();

  loadMyModel() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
    );
    print("Loaded");
  }

  applyModelOnImage(File file) async {
    var res = await Tflite.runModelOnImage(
      path: file.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5
    );

    setState(() {
      _result = res;
      String str = _result![0]['label'];
      _name = str.substring(2);
      _confidence = (_result![0]['confidence']*100.0).toString().substring(0,2) + "%";
    });
  }

  Future getImageFromGallery() async {
    print("before await");
    var tempStore = await _picker.getImage(source: ImageSource.gallery);
    print("after await");

    setState(() {
      if (tempStore == null) {
        return;
      } else {
        _isImageLoaded = true;
        _image = File(tempStore.path);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadMyModel().then((value) {
      setState(() {});
    });
  }

  /*@override
  void dispose() {
    super.dispose();
    Tflite.close();
  }*/

  @override
  //reruns every time set state is called
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("Test"),
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              getImageFromGallery();
            },
            child: Icon(Icons.photo_album),
          ),

          body: Container(
            child: Column(
              children: [
                SizedBox(height: 80),
                _isImageLoaded
                  ? Center(
                    child: Container(
                      height: 350,
                      width: 350,
                      decoration: BoxDecoration(
                        image:  DecorationImage(
                          image: FileImage(File(_image!.path)),
                          fit: BoxFit.contain)),
                    ),
                )
                 : Center(
                    child: Image(image: AssetImage('assets/wahwah.jpeg'))
                  ),
                Text("Name : $_name\n Confidence: $_confidence"),
                Text("isImageLoaded: $_isImageLoaded"),
              ],
            ),
          ),
      )
    );
  }
}
