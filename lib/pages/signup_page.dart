import 'package:duck_gun/controllers/user_controller.dart';
import 'package:duck_gun/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String nome = "";
  String email = "";
  String senha = "";
  String cnpj = "";
  // var textEditingController = TextEditingController(text: "123.456.789/5555-10");
  var maskFormatter = new MaskTextInputFormatter(
      mask: '###.###.###/####-##', filter: {"#": RegExp(r'[0-9]')});
  // textEditingController.value = maskFormatter.updateMask(mask: "##-##-##-##"); // -> "12-34-56-78"

  late final userController = Provider.of<UserController>(
    context,
    listen: false,
  );

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: 12),
            Container(
              child: Form(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Cadastro',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(height: 12),
                      if (isLoading) CircularProgressIndicator(),

                      // TextFormField(
                      //   onChanged: (texto) => nome = texto,
                      //   keyboardType: TextInputType.name,
                      //   decoration: InputDecoration(
                      //     labelText: 'Nome Completo',
                      //     border: OutlineInputBorder(),
                      //     errorStyle: TextStyle(color: Colors.red.shade700),
                      //   ),
                      // ),

                      TextFormField(
                        onChanged: (texto) => nome = texto,
                        validator: (String? texto) {
                          if (texto != null && texto.isNotEmpty) {
                            if (texto.length < 2) return 'Digite seu nome';
                          } else {
                            return 'Campo Obrigatório';
                          }
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          border: OutlineInputBorder(),
                          errorStyle: TextStyle(color: Colors.red.shade700),
                        ),
                      ),

                      SizedBox(height: 12),

                      // TextFormField(
                      //   onChanged: (texto) => email = texto,
                      //   keyboardType: TextInputType.emailAddress,
                      //   decoration: InputDecoration(
                      //     labelText: 'Email',
                      //     border: OutlineInputBorder(),
                      //     errorStyle: TextStyle(color: Colors.red.shade700),
                      //   ),
                      // ),

                      TextFormField(
                        onChanged: (texto) => email = texto,
                        keyboardType: TextInputType.emailAddress,
                        validator: (String? texto) {
                          if (texto != null && texto.isNotEmpty) {
                            if (!texto.contains('@') ||
                                texto.length < 8 ||
                                !texto.contains('.com'))
                              return 'Digite um e-mail válido.';
                          } else {
                            return 'Campo Obrigatório';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          errorStyle: TextStyle(color: Colors.red.shade700),
                        ),
                      ),

                      SizedBox(height: 12),
                      // TextFormField(
                      //   onChanged: (texto) => registro = texto,
                      //   keyboardType: TextInputType.number,
                      //   decoration: InputDecoration(
                      //     labelText: 'Registro',
                      //     border: OutlineInputBorder(),
                      //     errorStyle: TextStyle(color: Colors.red.shade700),
                      //   ),
                      // ),
                      // SizedBox(height: 12),

                      TextFormField(
                        // controller: textEditingController,
                        inputFormatters: [maskFormatter],
                        onChanged: (texto) => cnpj = texto,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            errorStyle: TextStyle(color: Colors.red.shade700),
                            hintText: '123.456.789/5555-10',
                            labelText: 'Informe seu CNPJ'),
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        obscureText: true,
                        onChanged: (texto) => senha = texto,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          border: OutlineInputBorder(),
                          errorStyle: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 18),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF4D734F), // background
                            onPrimary: Color(0xFF0D0D0D), // foreground
                          ),
                          onPressed: () async {
                            try {
                              final user = UserModel(nome: nome, email: email);
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
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              'Criar conta',
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



























//     Scaffold(
//       appBar: AppBar(
//         title: Text("Criar conta"),
//       ),
//       body: Form(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               if (isLoading) CircularProgressIndicator(),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Nome'),
//                 onChanged: (texto) => nome = texto,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Email'),
//                 onChanged: (texto) => email = texto,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'CNPJ'),
//                 onChanged: (texto) => cnpj = texto,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Senha'),
//                 obscureText: true,
//                 onChanged: (texto) => senha = texto,
//               ),
//               ElevatedButton(
//                 // onPressed: () async {
//                 //   final user = UserModel(nome: nome);
//                 //   await userController.signup(email, senha, user);
//                 //   Navigator.pop(context);
//                 // },
//                 onPressed: () async {
//                   try {
//                     final user = UserModel(nome: nome, email: email);
//                     setState(() {
//                       isLoading = true;
//                     });
//                     await userController.signup(email, senha, user);
//                     Navigator.pop(context);
//                   } on FirebaseAuthException catch (e) {
//                     setState(() {
//                       isLoading = false;
//                     });
//                     var msg = '';

//                     if (e.code == 'weak-password') {
//                       msg = 'Senha fraca!';
//                     } else if (e.code == 'email-already-in-use') {
//                       msg = 'Email já cadastrado';
//                     } else {
//                       msg = 'Ocorreu um erro';
//                     }

//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(msg),
//                       ),
//                     );
//                   }
//                 },
//                 child: Text("Criar conta"),
//               ),

//               // ElevatedButton(
//               //   onPressed: () async {
//               //     final payload = {
//               //       'nome': nome,
//               //     };
//               //     // await userController.signup(email, senha, payload);
//               //     await userController.signup(email, senha, payload);

//               //     Navigator.pop(context);
//               //   },
//               //   child: Text("Criar conta"),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
