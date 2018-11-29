import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  ProfileScreen(this.user);
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    print('from profile screen ${widget.user}');
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            overflow: Overflow.visible,
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/images/cover2.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                width: 70,
                height: 70,
                top: 169,
                child: CircleAvatar(
                  backgroundImage: widget.user != null
                      ? NetworkImage(widget.user.imageUrl)
                      : AssetImage('assets/images/cover.jpg'),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 70,
          ),
          Text(widget.user != null ? widget.user.userName : 'User name'),
          SizedBox(
            height: 30,
          ),
          Text(widget.user != null ? widget.user.phoneNum : 'Full name'),
        ],
      ),
    );
  }
}
