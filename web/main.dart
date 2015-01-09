// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'lib/koch.dart';

void main() {
  
  CanvasElement canvas = querySelector('#koch');
//  setColor(canvas, 'black');
  Shape original = new Shape.Original(canvas);
  original.start();
  canvas.onKeyDown.listen(increaseDepth);
}
void setColor(CanvasElement canvas, String color) {
  CanvasRenderingContext2D context = canvas.getContext('2d');
  context.fillStyle = color;
  context.fillRect(0, 0, canvas.width, canvas.height);
}
void increaseDepth(KeyboardEvent key) {
  
}
void fractalize(Shape current, int depth) {
  
}