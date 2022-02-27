import 'package:flutter/material.dart';
import 'package:mslotwinski_2048/config/index.dart';
import 'package:mslotwinski_2048/widgets/box.dart';

class GameContent extends StatelessWidget {
  const GameContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
              child: Text(Config.name, style: TextStyle(fontSize: 25)))),
      body: const GameBox(),
    );
  }
}
