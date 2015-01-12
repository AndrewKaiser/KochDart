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
  CanvasRenderingContext2D context = canvas.getContext('2d');
  original  = new Shape.Original(canvas);
  original.start();
  canvas.onContextMenu.listen((MouseEvent e) => e.preventDefault());
  canvas.onMouseDown.listen(increaseDepth);
  canvas.onKeyDown.listen(startOver);
}
void setColor(CanvasElement canvas, String color) {
  CanvasRenderingContext2D context = canvas.getContext('2d');
  context.fillStyle = color;
  context.fillRect(0, 0, canvas.width, canvas.height);
}
void findAngles(Shape original) {
  oAngles = <num>[];
  for(int i=0; i<original.size()-1; ++i) {
    num x = original.points[i].x - original.points[i+1].x;
    num y = original.points[i].y - original.points[i+1].y;
    num sideAngle = 2*atan((sqrt(pow(x,2) + pow(y,2)) - x)/y);
    
    x = original.points.first.x - original.points.last.x;
    y = original.points.first.y - original.points.last.y;
    num oAngle = 2*atan((sqrt(pow(x,2) + pow(y,2)) - x)/y);
   
    oAngles.add((oAngle - sideAngle)*-1);
  }
}
void startOver(KeyboardEvent key) {
  print('here');
  print(key);
}
void increaseDepth(MouseEvent event) {
  if (event.button != 2) return;
  if (original.size() < 2) return;
  original.startFractal();
//  print("oAngle: $oAngle");
  maxDepth ++;
//  print(original.getAngle());
//  original.size();
  CanvasElement canvas = querySelector('#koch');
  var context = canvas.context2D;
  original.drawBackground(context);
  findAngles(original);
  fractalize(original, 0);
  print('done');
}
void fractalize(Shape current, int depth) {
  CanvasElement canvas = querySelector("#koch");
  if (depth == maxDepth) {
    //    original.drawBackground(context);
    current.render();
    return;
  }
  var levelAbove = current.getBaseDistance();
  for (int i=0; i<current.size() - 1; ++i) {
//    Shape newDepth = new Shape.Copy(current, canvas);
    Shape newDepth = new Shape.Copy(current, canvas);
    newDepth.translate(i);
//    print(current.points);
    newDepth.rotate(i, oAngles[i]);
    newDepth.dialate(i, levelAbove);
    fractalize(newDepth, depth + 1);
//    print('going');
  }
}