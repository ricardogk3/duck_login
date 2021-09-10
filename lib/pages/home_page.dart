import 'package:duck_gun/models/user_model.dart';
import 'package:duck_gun/pages/add_produto.dart';
import 'package:duck_gun/pages/edit_produto_page.dart';
import 'package:duck_gun/pages/my_flutter_app_icons.dart';
// import 'package:duck_gun/pages/todos_produtos.dart';
// import 'package:duck_gun/pages/todos_users.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/produto_model.dart';




class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final userController = Provider.of<UserController>(
    context,
    listen: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color(0xFF4D734F),
      //   title: Text("Home"),
      //   actions: [
      //     IconButton(
      //       onPressed: () async {
      //         await userController.logout();
      //       },
      //       icon: Icon(Icons.exit_to_app), 
      //     )
      //   ],
      // ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userController.model.nome),
              accountEmail: Text(userController.user!.email!),
              currentAccountPicture: CircleAvatar(
                radius: 60.0,
                backgroundColor: const Color(0xFF778899),
                // backgroundImage: NetworkImage(userController.user!.fotoPerfil!,), // for Network image
              ),
            ),

            // ListTile(
            //   leading: Icon(Icons.list_alt),
            //   title: const Text('Todos os diários'),
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => TodosProdutos(),
            //         ));
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.list_alt),
            //   title: const Text('Todos os usuários'),
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => TodosUsers(),
            //         ));
            //   },
            // ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('produtos')
            .where('ownerKey', isEqualTo: userController.user!.uid)
            // .orderBy('produto')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final produtos = snapshot.data!.docs.map((map) {
            final data = map.data();
            return ProdutoModel.fromMap(data, map.id);
          }).toList();

          return ListView.builder(
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              final produto = produtos[index];
              return ListTile(
                title: Text(produto.produto),
                subtitle: Row(
                  children: [
                    // Icon(Ionicons.cart_outline),
                    Icon(MyFlutterApp.mp5),
                    Text(produto.quantidade),
                  ],
                ),
                leading: produto.imagem != null
                    ? Image.memory(
                        produto.imagem!,
                        width: 72,
                      )
                    : Container(
                        // child: Icon(Icons.location_on),
                        child: Icon(
                          // Ionicons.cart_outline,
                          Icons.camera_alt,
                          size: 35,
                        ),
                        width: 72,
                        height: double.maxFinite,
                        color: Color(0xFF4D734F),
                      ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProdutoPage(
                        produto: produto,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProduto(),
            ),
          );
        },
      ),
    );
  }
}




