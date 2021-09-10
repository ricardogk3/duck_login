import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Dashboard extends StatefulWidget {

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

Material myItems(IconData icon, String heading, int color) {
  return Material(
    color: Colors.white,
    elevation: 14.0,
    shadowColor: Color(0x802196F3),
    borderRadius: BorderRadius.circular(24.0),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.all(8.0),
                    child: Text(
                      heading,
                        style: TextStyle(
                          color: new Color(color),
                            fontSize: 20.0,
                    ),
                  ),
                ),
                Material(
                  color: new Color(color),
                  borderRadius: BorderRadius.circular(24.0),
                  child: Padding(
                     padding: const EdgeInsets.all(16.0),
                     child: Icon(
                       icon, 
                       color: Colors.white,
                       size: 30.0,
                     ),
                  ),
                ),            
              ],
            )
          ],
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: <Widget>[
        myItems(Icons.graphic_eq, 'Fuzil', 0xFF6c8c74),
        myItems(Icons.graphic_eq, 'Pistola', 0xFF6c8c74),
        myItems(Icons.graphic_eq, 'Granadas', 0xFF6c8c74),
        myItems(Icons.graphic_eq, 'Aéreo', 0xFF6c8c74),
        myItems(Icons.graphic_eq, 'Tanque', 0xFF6c8c74),
        myItems(Icons.graphic_eq, 'Diversos', 0xFF6c8c74),
        myItems(Icons.graphic_eq, 'Receita', 0xFF6c8c74),
      ],
      staggeredTiles: [
        StaggeredTile.extent(2, 130.0),
        StaggeredTile.extent(2, 130.0),
        StaggeredTile.extent(1, 130.0),
        StaggeredTile.extent(1, 130.0),
        StaggeredTile.extent(1, 130.0),
        StaggeredTile.extent(1, 130.0),
        StaggeredTile.extent(2, 240.0),
      ],
        ),
    );
  }
}