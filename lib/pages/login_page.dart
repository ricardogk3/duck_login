import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

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
  String error = "";

  final _formKey = GlobalKey<FormState>();

  late final UserController userController =
      Provider.of<UserController>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4D734F),
        title: Text('DUCK GUN',
            style: GoogleFonts.pressStart2p(
                textStyle: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -1.5))),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(20),
                color: Colors.transparent,
                child: CircleAvatar(
                  radius: 110,
                  backgroundColor: Color(0xFFA8BFB2),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('images/pato2.png'),
                    backgroundColor: Colors.black,
                    radius: 100,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [ 
                        Text(
                          'Seja Bem-Vindo',
                          style: textStyles.headline5,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          validator: (String? texto) {
                            if (texto != null && texto.isNotEmpty) {
                              if (!texto.contains('@') ||
                                  texto.length < 6 ||
                                  !texto.contains('.com'))
                                return 'Digite um e-mail válido.';
                            } else {
                              return 'Campo Obrigatório';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (texto) => email = texto,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          validator: (String? texto) {
                            if (texto != null && texto.isNotEmpty) {
                              if (texto.length < 6)
                                return 'Digite uma senha com 8 caracteres ou mais';
                            } else {
                              return 'Campo obrigatório';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          onChanged: (texto) => senha = texto,
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF4D734F), // background
                              onPrimary: Color(0xFF0D0D0D), // foreground
                            ),
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                try {
                                  await userController.login(email, senha);
                                } on FirebaseAuthException catch (e) {
                                  var msg = '';
                                  print(e.code);
                                  if (e.code == 'wrong-password') {
                                    msg = 'A senha está incorreta';
                                  } else if (e.code == 'invalid-email') {
                                    msg = 'Email inválido';
                                  } else if (e.code == 'user-not-found') {
                                    msg = 'Usuário não encontrado';
                                  } else {
                                    msg = 'Ocorreu um erro';
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(msg),
                                    ),
                                  );
                                }
                              } else{

                                var msg = 'Dados incorretos';

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(msg),
                                  ),
                                );
                            }


                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                'Login',
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Se deseja criar conta,',
                              style: TextStyle(
                                color: Color(0xFF4D734F),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignupPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  " CLIQUE AQUI!",
                                  style: TextStyle(
                                    color: Color(0xFF4D734F),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
