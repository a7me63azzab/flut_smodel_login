import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddImage extends StatefulWidget {
  final Function setImage;
  AddImage(this.setImage);
  @override
  State<StatefulWidget> createState() {
    return _AddImageState();
  }
}

class _AddImageState extends State<AddImage> {
  File _imageFile;
  Widget uploadedImage(BuildContext context) {
    return Container(
      width: 95.0,
      height: 95.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        image: DecorationImage(
          fit: _imageFile != null ? BoxFit.fill : BoxFit.none,
          image: _imageFile != null
              ? FileImage(_imageFile)
              : AssetImage('assets/images/user.png'),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 4.0),
            blurRadius: 7.0,
          )
        ],
      ),
    );
  }

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        _imageFile = image;
      });

      widget.setImage(image);
      Navigator.pop(context);
    });
  }

  void imagePicker(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 120.0,
              width: 100.0,
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Pick an image',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 100, 115, 207),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      FlatButton.icon(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Color.fromARGB(255, 255, 140, 0),
                        ),
                        label: Text(
                          'Camera',
                          style: TextStyle(
                            color: Color.fromARGB(255, 100, 115, 207),
                          ),
                        ),
                        onPressed: () => _getImage(context, ImageSource.camera),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      FlatButton.icon(
                        icon: Icon(
                          Icons.image,
                          color: Color.fromARGB(255, 255, 140, 0),
                        ),
                        label: Text(
                          'Gallery',
                          style: TextStyle(
                            color: Color.fromARGB(255, 100, 115, 207),
                          ),
                        ),
                        onPressed: () =>
                            _getImage(context, ImageSource.gallery),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget addButton(BuildContext context) {
    return GestureDetector(
      onTap: () => imagePicker(context),
      child: Container(
        width: 26.0,
        height: 26.0,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 188, 96, 205),
            // color: Colors.yellow,
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.none,
              image: AssetImage('assets/images/add.png'),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(4.0, 2.0),
                blurRadius: 7.0,
              )
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        uploadedImage(context),
        Positioned(
          top: 15.0,
          left: 75.0,
          child: addButton(context),
        ),
      ],
    );
  }
}
