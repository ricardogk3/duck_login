import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// signed - usuario logado
// unsigned - usuario deslogado
// loading - usuário carregando
enum AuthState { signed, unsigned, loading }

class UserController extends ChangeNotifier {
  AuthState authState = AuthState.loading;
  late UserModel model;

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  User? get user => _auth.currentUser;

  UserController() { 
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        authState = AuthState.signed;
        final data = await _db.collection('vendedor').doc(user.uid).get();
        model = UserModel.fromMap(data.data()!);
      } else {
        authState = AuthState.unsigned;
      }
      notifyListeners();
    });
  }

  Future<void> login(String email, String senha) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: senha,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> signup(
    String email,
    String senha,
    // Map<String, dynamic>? payload,
    UserModel payload,
  ) async {
    final credentials = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );
    final uid = credentials.user?.uid;
    final data = payload.toMap();
    data['key'] = uid;

    final doc = _db.collection('vendedor').doc(uid);
    await doc.set(data);
  }
}

