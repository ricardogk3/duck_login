import 'package:duck_gun/controllers/user_controller.dart';
import 'package:duck_gun/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String nome = "";
  String email = "";
  String senha = "";

  late final userController = Provider.of<UserController>(
    context,
    listen: false,
  );

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar conta"),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (isLoading) CircularProgressIndicator(),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                onChanged: (texto) => nome = texto,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (texto) => email = texto,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                onChanged: (texto) => senha = texto,
              ),
              ElevatedButton(
                // onPressed: () async {
                //   final user = UserModel(nome: nome);
                //   await userController.signup(email, senha, user);
                //   Navigator.pop(context);
                // },
                onPressed: () async {
                  try {
                    final user = UserModel(nome: nome);
                    setState(() {
                      isLoading = true;
                    });
                    await userController.signup(email, senha, user);
                    Navigator.pop(context);
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    var msg = '';

                    if (e.code == 'weak-password') {
                      msg = 'Senha fraca!';
                    } else if (e.code == 'email-already-in-use') {
                      msg = 'Email já cadastrado';
                    } else {
                      msg = 'Ocorreu um erro';
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(msg),
                      ),
                    );
                  }
                },
                child: Text("Criar conta"),
              ),

              // ElevatedButton(
              //   onPressed: () async {
              //     final payload = {
              //       'nome': nome,
              //     };
              //     // await userController.signup(email, senha, payload);
              //     await userController.signup(email, senha, payload);

              //     Navigator.pop(context);
              //   },
              //   child: Text("Criar conta"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
