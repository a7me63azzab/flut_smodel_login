import 'package:flutter/material.dart';
import '../widgets/loaders/loader.dart';
import '../widgets/loaders/dot_type.dart';

class LoginButton extends StatelessWidget {
  final bool loading;
  LoginButton(this.loading);
  @override
  Widget build(BuildContext context) {
    Widget loginButton = Container(
      width: 80.0,
      height: 52.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          image: DecorationImage(
              fit: BoxFit.none, image: AssetImage('assets/images/arrow.png')),
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 95, 149, 234),
              Color.fromARGB(255, 188, 96, 205),
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            stops: [
              0.0,
              1.0,
            ],
            tileMode: TileMode.clamp,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 12.0),
              blurRadius: 23.0,
              spreadRadius: 1,
            )
          ]),
    );

    if (loading == true) {
      loginButton = Container(
        width: 80.0,
        height: 52.0,
        child: Loader(
          dotOneColor: Colors.red,
          dotTwoColor: Colors.yellow,
          dotThreeColor: Colors.white,
          dotType: DotType.circle,
          dotIcon: Icon(Icons.adjust),
          duration: Duration(seconds: 2),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 95, 149, 234),
                Color.fromARGB(255, 188, 96, 205),
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              stops: [
                0.0,
                1.0,
              ],
              tileMode: TileMode.clamp,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 12.0),
                blurRadius: 23.0,
                spreadRadius: 1,
              )
            ]),
      );
    }
    return loginButton;
  }
}
