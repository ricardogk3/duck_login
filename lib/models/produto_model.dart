import 'dart:html';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProdutoModel {
  final String? key;
  final String ownerKey;
  final String produto;
  final String preco;
  final String quantidade;
  



  // final String? key;
  // final String ownerKey;
  // final String titulo;
  // final String autor;
  // final String local;
  // final String diario;
  // final Uint8List? imagem;

  ProdutoModel({



    this.key,
    required this.ownerKey,
    required this.produto,
    required this.preco,
    required this.quantidade,



    // required this.ownerKey,
    // required this.titulo,
    // required this.autor,
    // required this.local,
    // required this.diario,
    // this.imagem,
  });

  static ProdutoModel fromMap(Map<String, dynamic> map, [String? key]) =>
      ProdutoModel(
        key: key,
        ownerKey: map['ownerKey'],
        produto: map['produto'],
        preco: map['preco'],
        quantidade: map['quantidade'],

        // titulo: map['titulo'],
        // autor: map['autor'],
        // local: map['local'],
        // diario: map['diario'],
        // imagem: map['imagem']?.bytes,
      );

  Map<String, dynamic> toMap() => {
        'ownerKey': ownerKey,
        'produto': produto,
        'preco': preco,
        'quantidade': quantidade,
 
        // 'titulo': titulo,
        // 'autor': autor,
        // 'local': local,
        // 'diario': diario,
        // 'imagem': imagem != null ? Blob(imagem!) : null,
      };
}
