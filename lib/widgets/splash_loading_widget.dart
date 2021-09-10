import 'package:duck_gun/pages/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';

class SplashLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.airplanemode_active,
                color: Color(0xFFA8BFB2),
              ),
              
              Icon(
                MyFlutterApp.mp5,
                size: 35,
                color: Color(0xFFA8BFB2),
              ),
            ],
          ),
          Text("Duck Gun"),
          SizedBox(
            height: 10,
          ),
          LinearProgressIndicator(),
        ],
      ),
    );
  }
}
