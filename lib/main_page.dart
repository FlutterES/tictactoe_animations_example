import 'package:tictactoe_animations_example/marker.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  MarkerType playerAtual = MarkerType.CIRCLE;

  List<List<MarkerType>> matrix = [
    [MarkerType.NONE, MarkerType.NONE, MarkerType.NONE],
    [MarkerType.NONE, MarkerType.NONE, MarkerType.NONE],
    [MarkerType.NONE, MarkerType.NONE, MarkerType.NONE]
  ];

  void makePlay(int col, int row) {
    if (matrix[col][row] != MarkerType.NONE) return;

    setState(() {
      matrix[col][row] = playerAtual;

      playerAtual = playerAtual == MarkerType.CIRCLE
          ? MarkerType.CROSS
          : MarkerType.CIRCLE;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Animações!")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < matrix.length; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var j = 0; j < matrix[i].length; j++)
                    GestureDetector(
                      onTap: () => makePlay(i, j),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey[300],
                          ),
                        ),
                        child: Marker(
                          enabled: matrix[i][j] != MarkerType.NONE,
                          type: matrix[i][j],
                          gradient: SweepGradient(
                            colors: [Colors.blue, Colors.red],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
