import 'dart:typed_data';

import 'package:duck_gun/controllers/user_controller.dart';
import 'package:duck_gun/models/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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
      mask: '#################', filter: {"#": RegExp(r'[0-9]')});


  late final nomeCont = TextEditingController()..text = widget.dados.nome;
  late final emailCont = TextEditingController()..text = widget.dados.email;
  late final cnpjCont = TextEditingController()..text = widget.dados.cnpj!;
  late final keyCont = widget.dados.key!;
  late Uint8List? file = widget.dados.fotoPerfil;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Color(0xFFfff),
                                      ),
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
                        onChanged: (texto) => email = texto,
                        keyboardType: TextInputType.emailAddress,
                        validator: (String? texto) {
                          if (texto != null && texto.isNotEmpty) {
                            if (!texto.contains('@') ||
                                texto.length < 8 ||
                                !texto.contains('.com'))
                              return 'Digite um e-mail válido.';
                          } else {
                            return 'Campo Obrigatório';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          errorStyle: TextStyle(color: Colors.red.shade700),
                        ),
                      ),

                      SizedBox(height: 12),
                      // TextFormField(
                      //   onChanged: (texto) => registro = texto,
                      //   keyboardType: TextInputType.number,
                      //   decoration: InputDecoration(
                      //     labelText: 'Registro',
                      //     border: OutlineInputBorder(),
                      //     errorStyle: TextStyle(color: Colors.red.shade700),
                      //   ),
                      // ),
                      // SizedBox(height: 12),

                      TextFormField(
                        // controller: textEditingController,
                        validator: (String? texto) {
                          if (texto != null && texto.isNotEmpty) {
                            if (texto.length < 19) {
                              // print('erro email');
                              return 'CNPJ incorreto!';
                            }
                          } else {
                            return 'Preencha os campos.';
                          }
                        },
                        inputFormatters: [maskFormatter],
                        onChanged: (texto) => cnpjCont = texto,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            errorStyle: TextStyle(color: Colors.red.shade700),
                            hintText: '123.456.789/5555-10',
                            labelText: 'Informe seu CNPJ'),
                      ),
                      SizedBox(height: 12),
                      // prefixIcon: Icon(Icons.lock),
                      // suffixIcon: Icon(Icons.visibility)

                      // TextFormField(
                      //   obscureText: true,
                      //   onChanged: (texto) => senha = texto,
                      //   keyboardType: TextInputType.number,
                      //   decoration: InputDecoration(
                      //     labelText: 'Senha',
                      //     border: OutlineInputBorder(),
                      //     errorStyle: TextStyle(color: Colors.red.shade700),
                      //   ),
                      // ),

              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final result =
                      await FilePicker.platform.pickFiles(type: FileType.image);

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
                    // Icon(Icons.upload),
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
                    isLoading = false;
                  });
                  // final formState = _formKey.currentState;
                  if (_formKey.currentState?.validate() ?? false) {
                    final novoProduto = UserModel(
                      nome: nomeCont.text,
                      email: emailCont.text,
                      cnpj: cnpjCont.text,
                      key: userController.user!.uid,
                      fotoPerfil: file,
                    ).toMap();

                    print(novoProduto);

                    await FirebaseFirestore.instance
                        .collection('vendedor')
                        .add(novoProduto);
                    setState(() {
                      isLoading = true;
                    });

                    Navigator.pop(context);
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
                    "Adicionar produto",
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
    );
  }
}
