import 'package:duck_gun/controllers/user_controller.dart';
import 'package:duck_gun/pages/splash_animation.dart';
// import 'package:duck_gun/pages/splash_animation.dart';
import 'package:duck_gun/pages/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserController(),
      child: MaterialApp(
        title: 'Duck Gun',
        theme: ThemeData(
          primaryColor: Color(0xFFA8BFB2),
          accentColor: Color(0xFF4D734F),
          appBarTheme: AppBarTheme(backgroundColor: Color(0x36402C)),
        ),
      // #A8BFB2 - verde mais clarinho
      // #6C8C74 - verde musgo
      // #4D734F- verde militar
      // #36402C- verde acinzentado 
      // #0D0D0D- preto
        debugShowCheckedModeBanner: false,
        home: SplashAnimation(),
        // home: SplashPage(),
      ),
    );
  }
}



