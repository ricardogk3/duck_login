import 'dart:html';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComprasModel {
  final String? keyCliente;
  final String? keyProduto;
  final String? keyVendedor;
  final String? quantidade;


  ComprasModel({
    this.keyCliente,
    this.keyProduto,
    this.keyVendedor,
    this.quantidade,

  });

  static ComprasModel fromMap(Map<String, dynamic> map) {
    return ComprasModel(
      keyCliente: map['keyCliente'],
      quantidade: map['quantidade'],
      keyVendedor: map['keyVendedor'],
      keyProduto: map['keyProduto'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'keyCliente': keyCliente,
      'quantidade': quantidade,
      'keyProduto': keyProduto,
      'keyVendedor': keyVendedor,
    };
  }
}
