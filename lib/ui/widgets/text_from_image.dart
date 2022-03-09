import 'dart:io';

import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextFromImage extends StatefulWidget {
  const TextFromImage({Key? key}) : super(key: key);

  @override
  State<TextFromImage> createState() => _TextFromImageState();
}

class _TextFromImageState extends State<TextFromImage> {
  String result = '';
  File? _image;
  ImagePicker? _imagePicker;

  getImageFromGallery() async {
    try {
      XFile? _pickedFile =
          await _imagePicker!.pickImage(source: ImageSource.gallery);
      _image = File(_pickedFile!.path);
      setState(() {
        _image;
        performImageLabeling();
      });
    } catch (e) {
      return e.toString();
    }
  }

  getImageFromCamera() async {
    try {
      XFile? _pickedFile =
          await _imagePicker!.pickImage(source: ImageSource.camera);
      _image = File(_pickedFile!.path);
      setState(() {
        _image;
        performImageLabeling();
      });
    } catch (e) {
      return e.toString();
    }
  }

  performImageLabeling() async {
    final inputImage = InputImage.fromFile(_image!);
    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText recognisedText =
        await textDetector.processImage(inputImage);

    result = '';
    setState(() {
      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            result += element.text + ' ';
          }
        }
        result += '\n';
      }
    });
    if (_image != null && result.isEmpty) {
      result = 'Make sure that you have picked a picture that has text on it';
    }
  }

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    final textThemeStyle = Theme.of(context).textTheme;

    return Column(
      children: [
        TextButton(
            onPressed: getImageFromGallery,
            onLongPress: getImageFromCamera,
            child: Container(
              child: _image != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.file(
                          _image!,
                          height: 250.0,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SelectableText(result , style: textThemeStyle.bodyText2),
                      ],
                    )
                  : SizedBox(
                      height: 190.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.black,
                          ),
                          Text('Press to pick picture \nLong press to capture ')
                        ],
                      ),
                    ),
            )),
        Visibility(
            visible: result.isEmpty ? false : true,
            child: TextButton(onPressed: (){
              setState(() {
                _image = null ;
                result = '';
              });
            }, child: Text('Reset' , style: textThemeStyle.bodyText1,)))
      ],
    );
  }
}
