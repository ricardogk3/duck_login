import 'dart:typed_data';

import 'package:duck_gun/controllers/user_controller.dart';
import 'package:duck_gun/models/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:photo_view/photo_view.dart';
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
  var maskFormatter = new MaskTextInputFormatter(
      mask: '###.###.###/####-##', filter: {"#": RegExp(r'[0-9]')});

  late final nomeCont = TextEditingController()..text = widget.dados.nome;
  late final emailCont = widget.dados.email;
  late final cnpjCont = TextEditingController()..text = widget.dados.cnpj!;
  late final keyCont = widget.dados.key!;
  late Uint8List? file = widget.dados.fotoPerfil!;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (cnpjCont.text == null) {
      cnpjCont.text = '';
    }
    
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // margin: EdgeInsets.all(20),
                      // color: Colors.transparent,
                      // height: 250,
                      // width: 250,
                      // CircleAvatar(
                      //   radius: 160,
                      //   backgroundColor: Color(0xFFA8BFB2),
                      //   child: CircleAvatar(
                      //     // backgroundImage: AssetImage('images/pato2.png'),
                      //     backgroundColor: Colors.black,
                      //     // backgroundImage: NetworkImage(userController.user!.fotoPerfil!,),
                      //     backgroundImage: NetworkImage(widget.dados.fotoPerfil!),
                      //     radius: 150,

                      // ),
                      // ),
                      Container(
                        padding: EdgeInsetsDirectional.only(start: 123),
                        alignment: Alignment.center,
                        height: 180,
                        child: ListTile(
                          // minLeadingWidth: 300,
                          leading: file != null
                              ? Container(
                                  height: 50,
                                  width: 50,
                                  
                                  child: new PhotoView(
                                    imageProvider: MemoryImage(file!),
                                    initialScale:
                                        PhotoViewComputedScale.contained * 3,
                                    // minScale: PhotoViewComputedScale.contained * 3,
                                    // maxScale: 4.0,
                                  ))
                              // ? Image.memory(
                              //     file!,
                              //     // width: 220,
                              //     // height: double.maxFinite/3,
                              //     // width: double.maxFinite/3,
                              //     // height: 220,
                              //     // fit: BoxFit.fill,
                              //     scale: 8,
                              //   )
                              : Container(
                                  child: Icon(
                                    Icons.camera_alt,
                                    // color: Color(0xFFfff),
                                    color: Colors.white,
                                  ),
                                  // width: 72,
                                  height: double.maxFinite,
                                  // color: Colors.blue,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  userController.user!.email!,
                  style: TextStyle(
                      color: Color(0xff6C8C74),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: nomeCont,
                  validator: (String? texto) {
                    if (texto != null && texto.isNotEmpty) {
                      if (texto.length < 2) return 'Digite seu nome';
                    } else {
                      return 'Campo Obrigatório';
                    }
                  },
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.red.shade700),
                  ),
                ),
                SizedBox(height: 12),
                TextFormField(
                  // validator: (String? texto) {
                  //   if (texto != null && texto.isNotEmpty) {
                  //     if (texto.length < 19) {
                  //       // print('erro email');
                  //       return 'CNPJ incorreto!';
                  //     }
                  //   } else {
                  //     return 'Preencha os campos.';
                  //   }
                  // },

                  inputFormatters: [maskFormatter],
                  controller: cnpjCont,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      errorStyle: TextStyle(color: Colors.red.shade700),
                      hintText: '123.456.789/5555-10',
                      labelText: 'Informe seu CNPJ'),
                ),
                SizedBox(height: 12),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final result = await FilePicker.platform
                        .pickFiles(type: FileType.image);
                    if (result != null) {
                      setState(() {
                        final bytes = result.files.first.bytes;
                        file = bytes;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF4D734F), // background
                    onPrimary: Color(0xFF0D0D0D), // foreground
                  ),
                  child: Row(
                    children: [
                      Icon(file != null ? Icons.check : Icons.upload),
                      Text(
                        "Adicionar imagem",
                        style: TextStyle(
                          color: Color(0xFF0D0D0D),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (isLoading) CircularProgressIndicator(),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                      if (cnpjCont.text == null) {
                        cnpjCont.text = '';
                      }
                    });
                    // final formState = _formKey.currentState;
                    if (_formKey.currentState?.validate() ?? false) {
                      final novoUser = UserModel(
                        nome: nomeCont.text,
                        email: emailCont,
                        cnpj: cnpjCont.text,
                        key: userController.user!.uid,
                        fotoPerfil: file!,
                      ).toMap();

                      print(novoUser);

                      await FirebaseFirestore.instance
                          .collection('vendedor')
                          .doc(widget.dados.key)
                          .update(novoUser);
                      setState(() {
                        isLoading = true;
                      });

                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      var msg = 'Dados incorretos';

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(msg),
                        ),
                      );
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Mudar dados",
                      style: TextStyle(
                        color: Color(0xFF4D734F),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
