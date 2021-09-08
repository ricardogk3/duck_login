import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duck_gun/models/produto_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class EditProdutoPage extends StatefulWidget {
  final ProdutoModel produto;

  EditProdutoPage({required this.produto});

  @override
  _EditProdutoPageState createState() => _EditProdutoPageState();
}

class _EditProdutoPageState extends State<EditProdutoPage> {
  @override
  late final produtoCont = TextEditingController()..text = widget.produto.produto;
  // late final autorCont = TextEditingController()..text = widget.produto.autor;
  late final precoCont = TextEditingController()..text = widget.produto.preco;
  late final quantidadeCont = TextEditingController()..text = widget.produto.quantidade;
  // late Uint8List? file = widget.produto.imagem;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar diário'),
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
          child: Column(
            children: [
              TextField(
                controller: produtoCont,
                decoration: InputDecoration(
                  labelText: "Produto",
                ),
              ),
              // TextField(
              //   controller: autorCont,
              //   decoration: InputDecoration(
              //     suffixIcon: Icon(Icons.person),
              //     labelText: "Autor",
              //   ),
              // ),
              TextField(
                controller: quantidadeCont,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.location_on),
                  labelText: "Quantidade",
                ),
              ),
              TextField(
                controller: precoCont,
                decoration: InputDecoration(
                  labelText: "Preco",
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     final result =
              //         await FilePicker.platform.pickFiles(type: FileType.image);

              //     if (result != null) {
              //       setState(() {
              //         final bytes = result.files.first.bytes;
              //         file = bytes;
              //       });
              //     }
              //   },
              //   child: Row(
              //     children: [
              //       // Icon(Icons.upload),
              //       Icon(file != null ? Icons.check : Icons.upload),
              //       Text("Adicionar imagem"),
              //     ],
              //   ),
              // ),
              const SizedBox(
                height: 8,
              ),
              OutlinedButton(
                onPressed: () async {
                  final atualizado = ProdutoModel(
                    ownerKey: widget.produto.ownerKey,
                    produto: produtoCont.text,
                    // autor: autorCont.text,
                    preco: widget.produto.preco,
                    quantidade: quantidadeCont.text,

                    // imagem: file,
                  ).toMap();

                  await FirebaseFirestore.instance
                      .collection('produtos')
                      .doc(widget.produto.key)
                      .update(atualizado);

                  Navigator.pop(context);
                },
                child: Text('Atualizar diário'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
