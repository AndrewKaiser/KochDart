// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:math';
import 'lib/koch.dart';

int maxDepth = 0;
Shape original;
List<num> oAngles;

void main() {
  CanvasElement canvas = querySelector('#koch');
  CanvasRenderingContext2D context = canvas.context2D;
  original  = new Shape.Original(canvas);
  original.start();
//  canvas.onContextMenu.listen((MouseEvent e) => e.preventDefault());
  var fracButton = querySelector("#depth");
  fracButton.onClick.listen(increaseDepth);
  querySelector("#clear").onClick.listen(startOver);
}
void findAngles(Shape original) {
  oAngles = <num>[];
  num x = original.points.first.x - original.points.last.x;
  num y = original.points.first.y - original.points.last.y;
  num oAngle = 2*atan((sqrt(pow(x,2) + pow(y,2)) - x)/y);
  for(int i=0; i<original.size()-1; ++i) {
    x = original.points[i].x - original.points[i+1].x;
    y = original.points[i].y - original.points[i+1].y;
    num sideAngle = 2*atan((sqrt(pow(x,2) + pow(y,2)) - x)/y);
    oAngles.add((oAngle - sideAngle)*-1);
  }
}
void increaseDepth(event) {
  if (original.size() < 2) return;
  original.startFractal();
  //increases the level the the fractal renders to
  maxDepth ++;
  var canvas = querySelector('#koch');
  var context = canvas.context2D;
  original.drawBackground(context);
  findAngles(original);
  //actual recursive fractal program
  fractalize(original, 0);
//  print('done, $maxDepth levels');
}
void fractalize(Shape current, int depth) {
  if (depth == maxDepth) {
    current.render();
    return;
  }
  var levelAbove = current.getBaseDistance();
  for (int i=0; i<current.size() - 1; ++i) {
    Shape newDepth = new Shape.Copy(current);
    newDepth.translate(i);
    newDepth.rotate(i, oAngles[i]);
    newDepth.dialate(i, levelAbove);
    fractalize(newDepth, depth + 1);
  }
}
void startOver(event) {
  var canvas = querySelector("#koch");
  original = null;
  original = new Shape.Original(canvas);
  maxDepth = 0;
  original.start();
}