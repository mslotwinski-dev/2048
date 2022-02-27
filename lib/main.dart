import 'package:flutter/material.dart';
import 'package:mslotwinski_2048/widgets/content.dart';

void main() => runApp(const Game());

class Game extends StatelessWidget {
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey, fontFamily: 'Rubik'),
      home: const GameContent(),
    );
  }
}
