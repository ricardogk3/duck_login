import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duck_gun/models/produto_model.dart';

// import '../controllers/user_controller.dart';
import 'package:duck_gun/controllers/user_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProduto extends StatefulWidget {
  @override
  _AddProdutoState createState() => _AddProdutoState();
}

class _AddProdutoState extends State<AddProduto> {
  String produto = "", preco = "", quantidade = "";
  // Uint8List? file;

  late final userController = Provider.of<UserController>(
    context,
    listen: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar produto"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Produto",
                ),
                onChanged: (texto) => produto = texto,
              ),
              TextField(
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.location_on),
                  labelText: "Preço",
                ),
                onChanged: (texto) => preco = texto,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Quantidade",
                ),
                onChanged: (texto) => quantidade = texto,
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () async {
                  // final user = await FirebaseFirestore.instance
                  //     .collection('produtos')
                  //     .doc(userController.user!.uid)
                  //     .get();

                  // final data = user.data()!;

                  final novoProduto = ProdutoModel(
                    ownerKey: userController.user!.uid,
                    produto: produto,
                    preco: preco,
                    quantidade: quantidade,
                  ).toMap();

                  print(novoProduto);

                  await FirebaseFirestore.instance
                      .collection('produtos')
                      .add(novoProduto);

                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Adicionar produto"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
