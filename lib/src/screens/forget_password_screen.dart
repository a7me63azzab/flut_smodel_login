import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scopped_models/main.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForgetPasswordScreenState();
  }
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  bool resetPassword = false;
  TextEditingController _forgetPasswordController = TextEditingController();
  TextEditingController _tokenController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  showResetPassword() {
    setState(() {
      resetPassword = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _forgetPasswordController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.white,
                    style: BorderStyle.solid,
                    width: 4,
                  )),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.green,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      model.forgetPassword(_forgetPasswordController.text);
                      showResetPassword();
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.green,
                    ),
                  ),
                  hintText: 'Enter your E-mail',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              resetPassword
                  ? Container(
                      height: 150,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: _tokenController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                                style: BorderStyle.solid,
                                width: 4,
                              )),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.green,
                              ),
                              hintText: 'Enter Token',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: _newPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                                style: BorderStyle.solid,
                                width: 4,
                              )),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.green,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  await model.resetPassword(
                                      _newPasswordController.text,
                                      _tokenController.text);
                                  setState(() {
                                    resetPassword = false;
                                  });

                                  // model.resetPasswordSuccess
                                  //     ? Fluttertoast.showToast(
                                  //         msg: "Password updated successfully",
                                  //         toastLength: Toast.LENGTH_SHORT,
                                  //         gravity: ToastGravity.CENTER,
                                  //         timeInSecForIos: 1,
                                  //         backgroundColor: Colors.green,
                                  //         textColor: Colors.white)
                                  //     : Fluttertoast.showToast(
                                  //         msg: "Password updated failed",
                                  //         toastLength: Toast.LENGTH_SHORT,
                                  //         gravity: ToastGravity.CENTER,
                                  //         timeInSecForIos: 1,
                                  //         backgroundColor: Colors.red,
                                  //         textColor: Colors.white);
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.green,
                                ),
                              ),
                              hintText: 'New Password',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}
