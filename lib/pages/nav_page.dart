// import 'package:duck_gun/pages/navegacao/perfil.dart';
import 'package:duck_gun/controllers/compras_controller.dart';
import 'package:duck_gun/controllers/user_controller.dart';
import 'package:duck_gun/pages/dashboard.dart';
import 'package:duck_gun/pages/historico.dart';
import 'package:duck_gun/pages/my_flutter_app_icons.dart';
import 'package:duck_gun/pages/perfil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:duck_gun/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

// import 'historico.dart';

class NavPage extends StatefulWidget {
  const NavPage({Key? key}) : super(key: key);

  @override
  _NavPageState createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  late final userController = Provider.of<UserController>(
    context,
    listen: false,
  );
  late final comprasController = Provider.of<UserController>(
    context,
    listen: false,
  );


  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  late List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Historico(),
    // Dashboard(
    //   // dados: comprasController.model
    //   ),
    Perfil(dados: userController.model),
  ]; 

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFA8BFB2),
      appBar: AppBar(
        backgroundColor: Color(0xFF4D734F),
        centerTitle: true,
        title: Text(
          'Duck Gun',
          style: GoogleFonts.pressStart2p(
            textStyle: TextStyle(
                fontSize: 32, fontWeight: FontWeight.w300, letterSpacing: -1.5),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await userController.logout();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Color(0xFF4D734F),
        selectedItemColor: Color(0xFFFFFFFF),
        unselectedItemColor: Color(0xFF0D0D0D),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              MyFlutterApp.mp5,
              size: 35,
            ),
            label: 'Produtos',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.history, size: 35),
          //   label: 'Histórico',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, size: 35),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.person_outline, size: 35),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
