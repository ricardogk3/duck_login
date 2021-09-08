import 'package:firebase_auth/firebase_auth.dart';

import '../controllers/user_controller.dart';
import 'signup_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String senha = "";
  String error = '';

  late final UserController userController =
      Provider.of<UserController>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (texto) => email = texto,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                onChanged: (texto) => senha = texto,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  // await userController.login(email, senha);
                  try {
                    await userController.login(email, senha);
                  } on FirebaseAuthException catch (e) {
                    var msg = '';

                    if (e.code == 'wrong-password') {
                      msg = 'A senha está incorreta';
                    } else if (e.code == 'invalid-email') {
                      msg = 'Email inválido';
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
                child: Text("Login"),
              ),
              SizedBox(height: 10),
              Text("OU"),
              SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignupPage(),
                    ),
                  );
                },
                child: Text("Criar conta"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
