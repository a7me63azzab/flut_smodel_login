import 'package:flutter/material.dart';
//import '../models/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:scoped_model/scoped_model.dart';
import '../scopped_models/main.dart';

class ProfileScreen extends StatefulWidget {
  final MainModel model;
  ProfileScreen(this.model);
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _imageFile;

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _updatePasswordController = TextEditingController();
  @override
  void initState() {
    if (widget.model.user == null) {
      widget.model.getCurrentUserData();
    }
    super.initState();
  }

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        _imageFile = image;
      });

      //upload Image
      widget.model.updateImage(image);

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

  updateFullName(BuildContext context) {
    _fullNameController.text = widget.model.user.fullName;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update FullName'),
            content: TextField(
              controller: _fullNameController,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('Update'),
                onPressed: () => widget.model
                    .updateUserData({'name': _fullNameController.text}).then(
                        (value) => Navigator.of(context).pop()),
              )
            ],
          );
        });
  }

  updateUserName(BuildContext context) {
    _userNameController.text = widget.model.user.userName;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update UserName'),
            content: TextField(
              controller: _userNameController,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('Update'),
                onPressed: () => widget.model.updateUserData({
                      'userName': _userNameController.text
                    }).then((value) => Navigator.of(context).pop()),
              )
            ],
          );
        });
  }

  Widget itemField(BuildContext context, String fieldName, String filedValue) {
    Widget editField;
    if (fieldName == 'User Name') {
      editField = IconButton(
        onPressed: () => updateUserName(context),
        icon: Icon(Icons.edit),
      );
    } else if (fieldName == 'Full Name') {
      editField = IconButton(
        onPressed: () => updateFullName(context),
        icon: Icon(Icons.edit),
      );
    } else {
      editField = SizedBox(
        width: 5,
      );
    }
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 20),
      margin: EdgeInsets.only(right: 15, left: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          Text(
            '$fieldName :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 50,
          ),
          Text(
            widget.model.user != null ? filedValue : '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 75,
          ),
          editField,
        ],
      ),
    );
  }

  Widget updatePassword() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(right: 15, left: 15, bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Change Passwrod :',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (String password) {
                  model.checkOldPassword(password).then((value) {
                    print('########## > $value');
                  });
                },
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter old password',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.red,
                    style: BorderStyle.solid,
                    width: 4,
                  )),
                  prefixIcon: model.isValid
                      ? Icon(
                          Icons.lock,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.lock,
                          color: Colors.red,
                        ),
                  suffixIcon: model.isValid
                      ? Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      enabled: model.isValid ? true : false,
                      controller: _updatePasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.red,
                          style: BorderStyle.solid,
                          width: 4,
                        )),
                        prefixIcon: model.isValid
                            ? Icon(
                                Icons.lock,
                                color: Colors.green,
                              )
                            : Icon(
                                Icons.lock,
                                color: Colors.red,
                              ),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            Map<String, dynamic> result = await model
                                .updatePassword(_updatePasswordController.text);
                            if (result['success']) {
                              Fluttertoast.showToast(
                                  msg: "Password updated successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIos: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Password updated failed",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIos: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            }
                          },
                          icon: model.isValid
                              ? Icon(
                                  Icons.send,
                                  color: Colors.green,
                                )
                              : Icon(Icons.send),
                        ),
                        hintText: 'New Password',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var userImage;

    if (_imageFile != null) {
      userImage = _imageFile;
    } else if (widget.model.user != null) {
      userImage = widget.model.user.imageUrl;
    } else {
      userImage = "https://i.imgur.com/BoN9kdC.png";
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 249, 241, 241),
      body: ListView(
        children: <Widget>[
          Stack(
            overflow: Overflow.visible,
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 10),
                  ),
                ]),
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/images/cover2.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 90,
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: Colors.white,
                      width: 4,
                    ),
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: (userImage is File)
                          ? FileImage(userImage)
                          : NetworkImage(userImage),
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(top: 60),
                    child: IconButton(
                      onPressed: () => imagePicker(context),
                      icon: Icon(Icons.camera_alt),
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          itemField(context, 'User Name', widget.model.user.userName),
          SizedBox(
            height: 20,
          ),
          itemField(context, 'Full Name', widget.model.user.fullName),
          SizedBox(
            height: 20,
          ),
          itemField(context, 'Email', widget.model.user.email),
          SizedBox(
            height: 20,
          ),
          itemField(context, 'Phone Num', widget.model.user.phoneNum),
          SizedBox(
            height: 20,
          ),
          updatePassword(),
        ],
      ),
    );
  }
}
