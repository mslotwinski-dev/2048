import 'package:flutter/material.dart';

class GameBox extends StatefulWidget {
  const GameBox({Key? key}) : super(key: key);

  @override
  State<GameBox> createState() => _GameBoxState();
}

class _GameBoxState extends State<GameBox> {
  @override
  Widget build(BuildContext context) {
    var gridSize = MediaQuery.of(context).size.width - 32.0;

    return Center(
        child: Container(
            width: gridSize,
            height: gridSize,
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[400]),
            child: Table(children: const [])));
  }
}
