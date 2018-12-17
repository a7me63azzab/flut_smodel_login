import 'package:flutter/material.dart';
import 'dart:io';
import 'package:scoped_model/scoped_model.dart';
import 'package:flut_smodel_login/src/widgets/add_image.dart';
import '../scopped_models/main.dart';
import 'package:flut_smodel_login/src/widgets/login_button.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _fromData = {
    "userName": null,
    "fullName": null,
    "phoneNum": null,
    "email": null,
    "password": null,
    "image": null
  };

  Widget userNameField() {
    return TextFormField(
      onSaved: (String value) {
        _fromData['userName'] = value;
      },
      validator: (String value) {
        if (value.isEmpty || value.length < 4) {
          return 'userName not valid';
        }
      },
      style: new TextStyle(
        color: Color.fromARGB(255, 100, 115, 207),
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
      ),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'User Name',
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 173, 182, 196),
        ),
      ),
    );
  }

  Widget fullNameField() {
    return TextFormField(
      onSaved: (String value) {
        _fromData['fullName'] = value;
      },
      validator: (String value) {
        if (value.isEmpty || value.length < 4) {
          return 'fullName not valid';
        }
      },
      style: new TextStyle(
        color: Color.fromARGB(255, 100, 115, 207),
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
      ),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Full Name',
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 173, 182, 196),
        ),
      ),
    );
  }

  Widget phoneNumberField() {
    return TextFormField(
      onSaved: (String value) {
        _fromData['phoneNum'] = value;
      },
      validator: (String value) {
        if (value.isEmpty || value.length < 11) {
          return 'Please enter a valid number';
        }
      },
      style: new TextStyle(
        color: Color.fromARGB(255, 100, 115, 207),
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
      ),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 173, 182, 196),
        ),
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      onSaved: (String value) {
        _fromData['email'] = value;
      },
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      style: new TextStyle(
        color: Color.fromARGB(255, 100, 115, 207),
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
      ),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email Address',
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 173, 182, 196),
        ),
      ),
    );
  }

  Widget passwordField() {
    return TextFormField(
      controller: _passwordTextController,
      onSaved: (String value) {
        _fromData['password'] = value;
      },
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password not valid';
        }
      },
      style: new TextStyle(
        color: Color.fromARGB(255, 100, 115, 207),
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
      ),
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 173, 182, 196),
        ),
      ),
    );
  }

  Widget passwordConfirmField() {
    return TextFormField(
      onSaved: (String value) {},
      validator: (String value) {
        if (_passwordTextController.text != value) {
          print('Password do not match');
          return 'Password do not match!';
        }
      },
      style: new TextStyle(
        color: Color.fromARGB(255, 100, 115, 207),
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
      ),
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password Confirm',
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 173, 182, 196),
        ),
      ),
    );
  }

  Widget formCard() {
    return Container(
      width: 305,
      height: 358,
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(4.0, 4.0),
            blurRadius: 7.0,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            userNameField(),
            fullNameField(),
            phoneNumberField(),
            emailField(),
            passwordField(),
            passwordConfirmField()
          ],
        ),
      ),
    );
  }

  _setImage(File image) {
    print('from auth screen ====> $image');
    _fromData['image'] = image;
  }

  submitButton(MainModel model) {
    if (!_formKey.currentState.validate()) {
      print('Form not valid');
      return;
    }
    _formKey.currentState.save();

    // send data to scopped model
    model
        .register(_fromData)
        .then((value) => Navigator.pushNamed(context, '/user'))
        .catchError((err) => print(err));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Center(
          child: Stack(
            overflow: Overflow.visible,
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              formCard(),
              AddImage(_setImage),
              Positioned(
                top: 382.0,
                left: 190.0,
                child: FlatButton(
                  onPressed: () => submitButton(model),
                  child: LoginButton(model.loading),
                ),
              ),
              Positioned(
                top: 440,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Already have an account ?',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    FlatButton(
                      onPressed: ()  {
                        print('Clicked');
                        Navigator.of(context).pushNamed('/login');
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
