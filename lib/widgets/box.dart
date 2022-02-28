import 'package:collection/collection.dart';
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
  Iterable<List<Tile>> get cols =>
      List.generate(4, (x) => List.generate(4, (y) => grid[y][x]));

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        for (var element in flattenedGrid) {
          element.resetAnimations();
        }
      }
    });

    grid[1][0].val = 2;
    grid[1][1].val = 4;
    grid[1][2].val = 8;
    grid[1][3].val = 2;
    grid[2][0].val = 4;
    grid[2][1].val = 2;

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
            child: GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dy < -250 &&
                      canSwipeUp()) {
                    doSwipe(swipeUp);
                  } else if (details.velocity.pixelsPerSecond.dy > 250 &&
                      canSwipeDown()) {
                    doSwipe(swipeDown);
                  }
                },
                onHorizontalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dx < -250 &&
                      canSwipeLeft()) {
                    doSwipe(swipeLeft);
                  } else if (details.velocity.pixelsPerSecond.dx > 250 &&
                      canSwipeRight()) {
                    doSwipe(swipeRight);
                  }
                },
                child: Stack(
                  children: stackItems,
                ))));
  }

  void doSwipe(void Function() swipeFn) {
    setState(() {
      swipeFn();
      controller.forward(from: 0);
    });
  }

  bool canSwipeLeft() => grid.any(canSwipe);
  bool canSwipeRight() => grid.map((e) => e.reversed.toList()).any(canSwipe);
  bool canSwipeUp() => cols.any(canSwipe);
  bool canSwipeDown() => cols.map((e) => e.reversed.toList()).any(canSwipe);

  bool canSwipe(List<Tile> tiles) {
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i].val == 0) {
        if (tiles.skip(i + 1).any((e) => e.val != 0)) {
          return true;
        }
      } else {
        Tile? nextNonZero =
            tiles.skip(i + 1).firstWhereOrNull((e) => e.val != 0);
        if (nextNonZero != null && nextNonZero.val == tiles[i].val) {
          return true;
        }
      }
    }
    return false;
  }

  void swipeLeft() => grid.forEach(mergeTiles);
  void swipeRight() => grid.map((e) => e.reversed.toList()).forEach(mergeTiles);
  void swipeUp() => cols.forEach(mergeTiles);
  void swipeDown() => cols.map((e) => e.reversed.toList()).forEach(mergeTiles);

  void mergeTiles(List<Tile> tiles) {
    for (int i = 0; i < tiles.length; i++) {
      Iterable<Tile> toCheck =
          tiles.skip(i).skipWhile((value) => value.val == 0);

      if (toCheck.isNotEmpty) {
        Tile t = toCheck.first;
        Tile? merge = toCheck.skip(1).firstWhereOrNull((t) => t.val != 0);
        if (merge != null && merge.val != t.val) {
          merge = null;
        }

        if (tiles[i] != t || merge != null) {
          int resultValue = t.val;

          if (merge != null) {
            resultValue += merge.val;
            merge.val = 0;
          }

          t.val = 0;
          tiles[i].val = resultValue;
        }
      }
    }
  }
}
