import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flut_smodel_login/src/screens/auth_screen.dart';
import 'package:flut_smodel_login/src/screens/login_screen.dart';
import 'package:flut_smodel_login/src/screens/profile_screen.dart';
import '../src/screens/forget_password_screen.dart';
import '../src/scopped_models/main.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MainModel mainModel = MainModel();

    return ScopedModel<MainModel>(
      model: mainModel,
      child: MaterialApp(
        title: 'Auth app',
        home: Scaffold(
          resizeToAvoidBottomPadding: true,
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 113, 39, 143),
                      Color.fromARGB(255, 94, 149, 235),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)),
            child: LoginScreen(),
          ),
        ),
        routes: {
          '/user': (BuildContext context) => ProfileScreen(mainModel),
          '/register': (BuildContext context) => Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 113, 39, 143),
                            Color.fromARGB(255, 94, 149, 235),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp)),
                  child: AuthScreen(),
                ),
              ),
          '/login': (BuildContext context) => Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 113, 39, 143),
                            Color.fromARGB(255, 94, 149, 235),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp)),
                  child: LoginScreen(),
                ),
              ),
          '/forgetpassword': (BuildContext context) => Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 113, 39, 143),
                            Color.fromARGB(255, 94, 149, 235),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp)),
                  child: ForgetPasswordScreen(),
                ),
              ),
        },
      ),
    );
  }
}
