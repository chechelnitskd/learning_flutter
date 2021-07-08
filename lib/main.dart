import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

void main() {
  runApp(MaterialApp(home: MyHomePage()));
}

/*class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}*/
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  File? _image;
  List? _result;
  bool isImageLoaded = false;

  String _confidence = "";
  String _name = "";
  String numbers = "";

  final _picker = ImagePicker();

  loadMyModel() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
    );
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
    //may need future b/c don't know if async finishes
    // look into "printv" (printing for ui)
    print("get image yay");
    //var tempStore = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      print("DID IT SET");
      isImageLoaded = true;
      print("is it: $isImageLoaded");
      _image = convertToFile(Image(image: AssetImage('assets/sadyeehaw.jpeg')));
      /*if (tempStore == null) {
        _image = Image(image: AssetImage('assets/sadyeehaw.jpeg')) as File;
        return;
      } else {
        isImageLoaded = true;
        _image = File(tempStore.path);
      }*/
    });
  }

  @override
  void initState() {
    super.initState();
    loadMyModel().then((value) {
      setState(() {});
    });
  }

/*  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }*/

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("Test"),
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              print("pressed woo");
              getImageFromGallery();
              print("for funsies");
            },
            child: Icon(Icons.photo_album),
          ),

          body: Container(
            child: Column(
              children: [
                SizedBox(height: 80),
                isImageLoaded
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
                Text("isImageLoaded: $isImageLoaded"),
              ],
            ),
          ),
      )
    );
  }
}
