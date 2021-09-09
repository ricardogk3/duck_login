import 'dart:html';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String nome;
  final String? key;
  final String? cnpj;
  final String email;
  final Uint8List? fotoPerfil;


  UserModel({
    required this.nome,
    required this.email,
    this.cnpj,
    this.key,
    this.fotoPerfil,
  });

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      nome: map['nome'],
      key: map['key'],
      cnpj: map['cnpj'],
      email: map['email'],
      fotoPerfil: map['fotoPerfil']?.bytes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'key': key,
      'email': email,
      'cnpj': cnpj,
      'fotoPerfil': fotoPerfil != null ? Blob(fotoPerfil!) : null,
    };
  }
}
