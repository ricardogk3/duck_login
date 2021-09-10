import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duck_gun/models/produto_model.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditProdutoPage extends StatefulWidget {
  final ProdutoModel produto;

  EditProdutoPage({required this.produto});

  @override
  _EditProdutoPageState createState() => _EditProdutoPageState();
}

class _EditProdutoPageState extends State<EditProdutoPage> {
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '#################', filter: {"#": RegExp(r'[0-9]')});

  @override
  late final produtoCont = TextEditingController()
    ..text = widget.produto.produto;
  // late final autorCont = TextEditingController()..text = widget.produto.autor;
  late final precoCont = TextEditingController()..text = widget.produto.preco;
  late final quantidadeCont = TextEditingController()
    ..text = widget.produto.quantidade;
  late final categoriaCont = TextEditingController()
    ..text = widget.produto.categoria;
  late final idCont = TextEditingController()..text = widget.produto.id;
  late bool? promocaoCont = widget.produto.promocao;
  late final descricaoCont = TextEditingController()
    ..text = widget.produto.descricao;

  late Uint8List? file = widget.produto.imagem;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4D734F),
        title: Text('Editar Produto'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('produtos')
                  .doc(widget.produto.key)
                  .delete();

              Navigator.pop(context);
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (String? produtoCont) {
                    if (produtoCont != null && produtoCont.isNotEmpty) {
                      if (produtoCont.length < 2)
                        return 'Digite o nome do produto';
                    } else {
                      return 'Campo Obrigatório';
                    }
                  },
                  controller: produtoCont,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Ionicons.cart_outline),
                    labelText: "Produto",
                  ),
                ),
                // TextFormField(
                //   controller: autorCont,
                //   decoration: InputDecoration(
                //     suffixIcon: Icon(Icons.person),
                //     labelText: "Autor",
                //   ),
                // ),
                TextFormField(
                  controller: precoCont,
                  decoration: InputDecoration(
                    labelText: "Preco",
                  ),
                  validator: (String? precoCont) {
                    try {
                      var a = double.parse(
                          precoCont!.replaceAll('.', '').replaceAll(',', ''));
                      if (a == int || a == double) {
                        return ' ';
                      }
                    } catch (e) {
                      if (precoCont != null && precoCont.isNotEmpty) {
                        return 'Digite apenas numeros';
                      } else {
                        return 'Campo Obrigatório';
                      }
                    }
                  },
                ),

                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: quantidadeCont,
                  inputFormatters: [maskFormatter],
                  decoration: InputDecoration(
                    suffixIcon: Icon(Ionicons.cash_outline),
                    labelText: "Quantidade",
                  ),
                  validator: (String? quantidadeCont) {
                    if (quantidadeCont != null && quantidadeCont.isNotEmpty) {
                      if (quantidadeCont.length < 2)
                        return 'Digite a quantidade de produtos';
                    } else {
                      return 'Campo Obrigatório';
                    }
                  },
                ),

                Text('Descrição:'),
                DropdownButton<String>(
                  value: categoriaCont.text,
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
                      categoriaCont.text = newValue!;
                    });
                  },
                  items: <String>[
                    'Fuzil',
                    'Pistola',
                    'Aéreo',
                    'Tanque',
                    'Granadas',
                    'Diversos',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

                // TextFormField(
                //   controller: categoriaCont,
                //   decoration: InputDecoration(
                //     labelText: "Categoria",
                //   ),
                // ),
                TextFormField(
                  controller: idCont,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Ionicons.person_outline),
                    labelText: "Id",
                  ),
                ),
                // TextFormField(
                //   controller: promocaoCont,
                //   decoration: InputDecoration(
                //     labelText: "promocao",
                //   ),
                // ),
                Text('Item em promoção:'),
                Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.all(Color(0xFF4D734F)),
                    value: promocaoCont,
                    onChanged: (bool? value) {
                      setState(() {
                        promocaoCont = value!;
                      });
                    }),
                TextFormField(
                  controller: descricaoCont,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Ionicons.newspaper_outline),
                    labelText: "Descrição",
                  ),
                  maxLines: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
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
                const SizedBox(
                  height: 8,
                ),
                OutlinedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      final atualizado = ProdutoModel(
                        ownerKey: widget.produto.ownerKey,
                        produto: produtoCont.text,
                        // autor: autorCont.text,
                        preco: precoCont.text,
                        quantidade: quantidadeCont.text,
                        categoria: categoriaCont.text,
                        id: idCont.text,
                        // promocao: promocaoCont.text,
                        promocao: false,
                        descricao: descricaoCont.text,
                        imagem: file,
                      ).toMap();

                      await FirebaseFirestore.instance
                          .collection('produtos')
                          .doc(widget.produto.key)
                          .update(atualizado);

                      Navigator.pop(context);
                    } else {
                      var msg = 'Dados incorretos';

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(msg),
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Atualizar produto',
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
