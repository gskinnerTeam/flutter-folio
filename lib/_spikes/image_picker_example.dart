import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//import 'init.dart';
final cloudinary = CloudinaryPublic('flutterfoliodemo', 'ujszrrfn', cache: false);

class ImagePickerExample extends StatefulWidget {
  @override
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  final picker = ImagePicker();
  PickedFile _pickedFile;
  bool _uploading = false;

  Future getImage() async {
    final image = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _pickedFile = image;
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(child: _buildBody()),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget _buildBody() {
    if (_pickedFile == null) return Text('No image selected.');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildImage(),
        TextButton(
          onPressed: _uploading ? null : _upload,
          child: _uploading ? Text('Uploading...') : Text('Upload'),
        ),
      ],
    );
  }

  Future<void> _upload() async {
    setState(() {
      _uploading = true;
    });

    try {
      final res = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          _pickedFile.path,
        ),
      );
      print(res);
    } on CloudinaryException catch (e) {
      print(e.message);
      print(e.request);
    }

    setState(() {
      _uploading = false;
    });
  }

  Widget _buildImage() {
    if (kIsWeb) {
      return Image.network(_pickedFile.path);
    }
    return Image.file(File(_pickedFile.path));
  }
}
