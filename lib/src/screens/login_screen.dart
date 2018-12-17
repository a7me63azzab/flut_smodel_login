import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scopped_models/main.dart';
import 'package:flut_smodel_login/src/widgets/login_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _fromData = {
    "email": null,
    "password": null,
  };

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

  Widget formCard() {
    return Container(
      width: 305,
      height: 200,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.fromLTRB(20.0, 10, 20.0, 20.0),
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
        child: Column(
          children: <Widget>[
            emailField(),
            SizedBox(
              height: 10,
            ),
            passwordField(),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.only(left: 120),
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/forgetpassword');
                },
                child: Text('Forget Password',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  submitButton(MainModel model) {
    if (!_formKey.currentState.validate()) {
      print('Form not valid');
      return;
    }
    _formKey.currentState.save();

    print('from login $_fromData');

    // send data to scopped model
    model
        .userLogin(_fromData)
        .then((value) => Navigator.pushNamed(context, '/user'))
        .catchError((err) => print(err));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Container(
          height: 500,
          margin: EdgeInsets.only(top: 100),
          child: ListView(
            children: <Widget>[
              Stack(
                overflow: Overflow.visible,
                alignment: AlignmentDirectional.topCenter,
                children: <Widget>[
                  formCard(),
                  Positioned(
                    top: 195,
                    left: 200,
                    child: FlatButton(
                      onPressed: () => submitButton(model),
                      child: LoginButton(model.loading),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'New User ?',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FlatButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/register'),
                    child: Text('Register',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline)),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
