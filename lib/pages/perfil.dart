import 'dart:typed_data';

import 'package:duck_gun/controllers/user_controller.dart';
import 'package:duck_gun/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Perfil extends StatefulWidget {
  final UserModel dados;

  Perfil({required this.dados});

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  late final userController = Provider.of<UserController>(
    context,
    listen: false,
  );

  final _formKey = GlobalKey<FormState>();

  late final nomeCont = TextEditingController()..text = widget.dados.nome;
  late final emailCont = TextEditingController()..text = widget.dados.email;
  late final cnpjCont = TextEditingController()..text = widget.dados.cnpj!;
  late final keyCont = widget.dados.key!;
  late Uint8List? file = widget.dados.fotoPerfil;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container(
              //   margin: EdgeInsets.all(20),
              //   color: Colors.transparent,
              //   child: CircleAvatar(
              //     radius: 110,
              //     backgroundColor: Color(0xFFA8BFB2),
              //     child: CircleAvatar(
              //       backgroundImage: AssetImage('images/pato2.png'),
              //       backgroundColor: Colors.black,
              //       radius: 100,
              //     ),
              //   ),
              // ),
              Container(
                padding: EdgeInsets.all(10),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [ 
                        Container(
                  margin: EdgeInsets.all(20),
                  color: Colors.transparent,
                  child: CircleAvatar(
                    radius: 110,
                    backgroundColor: Color(0xFFA8BFB2),
                    child: CircleAvatar(
                      // backgroundImage: AssetImage('images/pato2.png'),
                      backgroundColor: Colors.black,
                      radius: 100,
                      child: ListTile(
                        leading: file != null
                            ? Image.memory(
                                file!,
                                width: 72,
                              )
                            : Container(
                                child: Icon(Icons.camera_alt,
                                color: Color(0xFFfff),),
                                // width: 72,
                                height: double.maxFinite,
                                color: Colors.blue,
                              ),
                      ),
                    ),
                  ),
                ),
              
                      ],
                      ),
                      ),
                      ),
                      ],
                      ),
                      ),
                      ),
                      );
                      }
                      }
