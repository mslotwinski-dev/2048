import 'package:flutter/material.dart';
import 'package:mslotwinski_2048/data/tile.dart';
import 'package:mslotwinski_2048/data/colors.dart';

class GameBox extends StatefulWidget {
  const GameBox({Key? key}) : super(key: key);

  @override
  State<GameBox> createState() => _GameBoxState();
}

class _GameBoxState extends State<GameBox> with TickerProviderStateMixin {
  late AnimationController controller;

  List<List<Tile>> grid =
      List.generate(4, (y) => List.generate(4, (x) => Tile(x, y, 0)));
  Iterable<Tile> get flattenedGrid => grid.expand((e) => e);
  List<Widget> stackItems = [];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration());

    grid[1][0].val = 2;
    grid[1][1].val = 4;
    grid[1][2].val = 8;
    grid[1][3].val = 16;
    grid[2][0].val = 32;
    grid[2][1].val = 64;
    grid[2][2].val = 128;
    grid[2][3].val = 256;
    grid[3][0].val = 512;
    grid[3][1].val = 1024;
    grid[3][2].val = 2048;

    for (var element in flattenedGrid) {
      element.resetAnimations();
    }
  }

  @override
  Widget build(BuildContext context) {
    var gridSize = MediaQuery.of(context).size.width - 16.0 * 2;
    var tileSize = (gridSize - 4.0 * 2) / 4;

    stackItems.addAll(flattenedGrid.map((e) => Positioned(
        top: e.x * tileSize,
        left: e.y * tileSize,
        width: tileSize,
        height: tileSize,
        child: Center(
            child: Container(
                width: tileSize - 4.0 * 2,
                height: tileSize - 4.0 * 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[300],
                ))))));

    stackItems.addAll(flattenedGrid.map((e) => AnimatedBuilder(
        animation: controller,
        builder: (context, child) => e.animatedValue.value == 0
            ? const SizedBox()
            : Positioned(
                top: e.x * tileSize,
                left: e.y * tileSize,
                width: tileSize,
                height: tileSize,
                child: Center(
                    child: Container(
                        width: tileSize - 4.0 * 2,
                        height: tileSize - 4.0 * 2,
                        child: Center(
                            child: Text("${e.animatedValue.value}",
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 24.0,
                                        color: Color.fromARGB(125, 0, 0, 0),
                                      ),
                                    ]))),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: tileColor[e.animatedValue.value],
                        )))))));

    return Center(
        child: Container(
            width: gridSize,
            height: gridSize,
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey[400],
            ),
            child: Stack(
              children: stackItems,
            )));
  }
}
