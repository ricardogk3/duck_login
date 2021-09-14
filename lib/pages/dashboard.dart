import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duck_gun/controllers/user_controller.dart';
import 'package:duck_gun/models/compras_model.dart';
import 'package:duck_gun/models/produto_model.dart';
import 'package:duck_gun/pages/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  // final ComprasModel dados;

  // Dashboard({required this.dados});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late final userController = Provider.of<UserController>(
    context,
    listen: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('carrinho')
            .where('keyVendedor', isEqualTo: userController.user!.uid)
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
                    Icon(Ionicons.cash_outline),
                    Text(produto.preco),
                  ],
                ),
                leading: produto.imagem != null
                    ? Image.memory(
                        produto.imagem!,
                        width: 100,
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
              );
            },
          );
        },
      ),
    );
  }
}

