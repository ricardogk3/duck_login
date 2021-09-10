import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duck_gun/models/produto_model.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// import '../controllers/user_controller.dart';
import 'package:duck_gun/controllers/user_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class AddProduto extends StatefulWidget {
  @override
  _AddProdutoState createState() => _AddProdutoState();
}

class _AddProdutoState extends State<AddProduto> {
  String produto = "", preco = "", quantidade = "";
  String categoria = "";
  String id = "";
  bool promocao = false;
  String descricao = "";
  Uint8List? file;

  String dropdownValue = 'Diversos';

  //final lowPrice = TextEditingController(); //before
  // final lowPrice = MoneyMaskedTextController(
  //     decimalSeparator: '.', thousandSeparator: ','); //after
  // var variavel = MaskTextInputFormatter( filter: {RegExp(r'[0-9]')});
  var maskFormatter = new MaskTextInputFormatter(
      mask: '#################', filter: {"#": RegExp(r'[0-9]')});
  // String a = 'R\$ ';
  final _formKey = GlobalKey<FormState>();

  late final userController = Provider.of<UserController>(
    context,
    listen: false,
  );

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4D734F),
        title: Text("Adicionar produto"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (String? texto) {
                    if (texto != null && texto.isNotEmpty) {
                      if (texto.length < 2) return 'Digite o nome do produto';
                    } else {
                      return 'Campo Obrigatório';
                    }
                  },
                  decoration: InputDecoration(
                    suffixIcon: Icon(Ionicons.cart_outline),
                    labelText: "Produto",
                  ),
                  onChanged: (texto) => produto = texto,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (String? texto) {
                    try {
                      var a = double.parse(
                          texto!.replaceAll('.', '').replaceAll(',', ''));
                      if (a == int || a == double) {
                        return ' ';
                      }
                    } catch (e) {
                      if (texto != null && texto.isNotEmpty) {
                        return 'Digite apenas numeros';
                      } else {
                        return 'Campo Obrigatório';
                      }
                    }
                  },
                  decoration: InputDecoration(
                    suffixIcon: Icon(Ionicons.cash_outline),
                    labelText: "Preço",
                  ),
                  onChanged: (texto) => {
                    preco = texto
                    // preco = a + texto,
                    // print(preco),
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (String? texto) {
                    if (texto != null && texto.isNotEmpty) {
                      if (texto.length < 2) return 'Digite a quantidade de produtos';
                    } else {
                      return 'Campo Obrigatório';
                    }
                  },
                  inputFormatters: [maskFormatter],
                  decoration: InputDecoration(
                    suffixIcon: Icon(Ionicons.add_circle_outline),
                    labelText: "Quantidade",
                  ),
                  onChanged: (texto) => quantidade = texto,
                ),
                Text('Categoria:'),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Color(0xFF4D734F)),
                  underline: Container(
                    height: 2,
                    color: Color(0xFF4D734F),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>[
                    'Diversos',
                    'Fuzil',
                    'Pistola',
                    'Aéreo',
                    'Tanque',
                    'Granadas',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

                // TextFormField(
                //   decoration: InputDecoration(
                //     // suffixIcon: Icon(Ionicons.add_circle_outline),
                //     labelText: "Categoria",
                //   ),
                //   onChanged: (texto) => categoria = texto,
                // ),
                TextFormField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(Ionicons.person_outline),
                    labelText: "Id",
                  ),
                  onChanged: (texto) => id = texto,
                ),
                // TextFormField(
                //   decoration: InputDecoration(
                //     suffixIcon: Icon(Icons.location_on),
                //     labelText: "promocao",
                //   ),
                //   onChanged: (texto) => promocao = texto,
                // ),
                Text('Item em promoção:'),
                Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.all(Color(0xFF4D734F)),
                    value: promocao,
                    onChanged: (bool? value) {
                      setState(() {
                        promocao = value!;
                      });
                    }),
                TextFormField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(Ionicons.newspaper_outline),
                    labelText: "Descrição",
                  ),
                  maxLines: 10,
                  onChanged: (texto) => descricao = texto,
                ),
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
                    final formState = _formKey.currentState;
                    if (_formKey.currentState?.validate() ?? false) {
                      final novoProduto = ProdutoModel(
                        ownerKey: userController.user!.uid,
                        produto: produto,
                        preco: preco,
                        quantidade: quantidade,
                        categoria: dropdownValue,
                        id: id,
                        promocao: promocao,
                        descricao: descricao,
                        imagem: file,
                      ).toMap();

                      print(novoProduto);

                      await FirebaseFirestore.instance
                          .collection('produtos')
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
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
