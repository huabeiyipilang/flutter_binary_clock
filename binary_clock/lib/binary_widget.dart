import 'dart:math';

import 'package:flutter/material.dart';

const double ITEM_SIZE = 100;

abstract class BinaryItemWidget extends StatelessWidget {
  final int value;

  const BinaryItemWidget({Key key, this.value}) : super(key: key);
}

class CircleBinaryItemWidget extends BinaryItemWidget {
  CircleBinaryItemWidget({int value}) : super(value: value);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CellPainter(value, context),
      size: Size(ITEM_SIZE, ITEM_SIZE),
    );
  }
}

class CellPainter extends CustomPainter {
  int value;
  Paint circlePaint;

  CellPainter(this.value, BuildContext context) {
    circlePaint = Paint();
    circlePaint.color = Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Colors.white70;
    circlePaint.strokeWidth = 3;
  }

  @override
  void paint(Canvas canvas, Size size) {
    circlePaint.style = value == 1 ? PaintingStyle.fill : PaintingStyle.stroke;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        min(size.width, size.height) / 2.5, circlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    CellPainter old = oldDelegate;
    return value != old.value;
  }
}

abstract class BinaryContainer extends StatelessWidget {
  final int count = 6;

  const BinaryContainer({Key key}) : super(key: key);

  List<int> getNumList() {
    List<int> values = new List();
    for (int i = count - 1; i >= 0; i--) {
      values.add(pow(2, i));
    }
    return values;
  }

  static int pow(num x, int n) {
    if (n == 0) {
      return 1;
    } else {
      int res = x;
      for (int i = 1; i < n; i++) {
        res = res * x;
      }
      return res;
    }
  }

  Widget getTextWidget(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.white70,
          fontSize: 24,
          fontWeight: FontWeight.bold),
    );
  }
}

class BinaryTitleContainer extends BinaryContainer {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List();
    widgets.add(Container(
      width: ITEM_SIZE,
      height: ITEM_SIZE,
      child: Center(
        child: getTextWidget("", context),
      ),
    ));
    widgets.addAll(getNumList().map((i) {
      return Container(
        width: ITEM_SIZE,
        height: ITEM_SIZE,
        child: Center(
          child: getTextWidget("$i", context),
        ),
      );
    }));
    return new Row(
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }
}

class BinaryListContainer extends BinaryContainer {
  final int value;

  const BinaryListContainer({Key key, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List();
    widgets.add(Container(
      width: ITEM_SIZE,
      height: ITEM_SIZE,
      child: Center(
        child: getTextWidget(value.toString(), context),
      ),
    ));
    widgets.addAll(getNumList().map((i) {
      return CircleBinaryItemWidget(value: ((i & value) == i ? 1 : 0));
    }));

    return new Row(
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }
}
