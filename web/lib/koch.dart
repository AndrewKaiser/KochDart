import 'dart:html';
import 'dart:math';
import 'mouse.dart';

class Position {
  Point pos;
  Mouse mouse;
  
  Position(this.mouse, this.pos);
  
  int x() {return x;}
  int y() {return y;}
  void draw(CanvasRenderingContext2D context) {
    
  }
}

class Shape {
  CanvasElement canvas;
  num width;
  num height;
  Mouse mouse;
  List<Point> points = <Point>[];
  
  Shape.Original(this.canvas);
  Shape.List(this.points, this.canvas);
  Shape.Copy(Shape old, this.canvas) {
    points.addAll(old.points);
  }
  
  start() {
    width = canvas.width;
    height = canvas.height;
    mouse = new Mouse(canvas);
    
    requestRedraw();
  }
  int size() {
    int length = 0;
    for(var p in points) length ++;
    return length;
  }
  Point getPoint(int i) {
    return points[i];
  }
  void addPoint(MouseEvent event) {
    points.add(new Point(event.client.x, event.client.y));
  }
  void draw([_]) {
    var context = canvas.context2D;
    drawBackground(context);
    drawLine(context);
    
    canvas.onMouseDown.listen(addPoint);
    requestRedraw();
  }
  void drawBackground(CanvasRenderingContext2D context) {
    context.clearRect(0, 0, width, height);
  }
  void drawLine(CanvasRenderingContext2D context) {
    if (points.isEmpty) return;
    context..lineWidth = 0.5
           ..strokeStyle = 'black';

    if (this.size() >= 2) {
      context..beginPath()
             ..moveTo(points.first.x, points.first.y);
      for (int i=1; i<this.size(); ++i) {
             context.lineTo(points[i].x, points[i].y);
      }
             context.stroke();
    }

    
    context..beginPath()
           ..moveTo(points.last.x, points.last.y)
           ..lineTo(mouse.x, mouse.y)
//           ..closePath()
           ..stroke();
  }
  void requestRedraw() {
    window.requestAnimationFrame(draw);
  }
}