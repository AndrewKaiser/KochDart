import 'dart:html';
import 'dart:math';
import 'mouse.dart';


class Shape {
  CanvasElement canvas;
  num width;
  num height;
  bool useMouse = true;
  Mouse mouse;
  List<Point> points = <Point>[];
  var onMouseDown;
  var requestId;

  Shape.Original(this.canvas) {
    points.clear();
  }
  Shape.Copy(Shape old) {
    points.clear();
    canvas = old.canvas; 
    width = old.width;
    height = old.height;
    points.addAll(old.points);
    useMouse = false;
    onMouseDown = null;
    mouse = null;
    
  }

  start() {
    points = <Point>[];
    width = canvas.width;
    height = canvas.height;
    mouse = new Mouse(canvas);
    useMouse = true;
    onMouseDown = window.onMouseDown.listen(addPoint);
    requestRedraw();
  }
  startFractal() {
    window.cancelAnimationFrame(requestId);
    useMouse = false;
    mouse = null;
    onMouseDown.cancel();
  }
  render([CanvasRenderingContext2D context]) {
    if (points.isEmpty) return;
    var context = canvas.context2D;
    context..lineWidth = 0.5
           ..strokeStyle = 'black';
    context..beginPath()
           ..moveTo(points.first.x, points.first.y);
    for (int i=1; i<this.size(); ++i) {
           context.lineTo(points[i].x, points[i].y);
    }
    context.stroke();
  }
  int size() {
    int length = 0;
    for(var p in points) {
      length ++;
    }
    return length;
  }
  double getBaseDistance() {
    return sqrt(pow(points.first.x-points.last.x,2) + pow(points.first.y-points.last.y,2));
  }
  void addPoint(MouseEvent event) {
    var rect = canvas.getBoundingClientRect();
    if (event.button == 2) return;
    if (!mouse.on) return;
    points.add(new Point(event.client.x - rect.left, event.client.y - rect.top ));
  }
  void translate(int i) {
    // shifts all the points with the previous level as the origin
    num dx = points[i].x - points.first.x;
    num dy = points[i].y - points.first.y;
    for (int w = 0; w < this.size(); ++w) {
      points[w] = new Point(points[w].x+dx, points[w].y+dy);
    }
  }
  void rotate(int i, angle) {
    // rotates the points around the "pivot" 
    // which is the first point in the new level
    num cosTheta = cos(angle);
    num sinTheta = sin(angle);
    // actually rotating all the points
    for (int w=1; w<size(); ++w) {
      num x = cosTheta*(points[w].x-points.first.x) - sinTheta*(points[w].y-points.first.y) + points.first.x;
      num y = sinTheta*(points[w].x-points.first.x) + cosTheta*(points[w].y-points.first.y) + points.first.y;
      points[w] = new Point(x, y);
    }
  }
  void dialate(int i, double levelAbove) {
    // shrinks the points with a ratio according to the side vs the whole
    // of the old depth fractal
    var currentDist = sqrt(pow(points[i].x-points[i+1].x,2)
                         + pow(points[i].y-points[i+1].y,2));
    double ratio = (levelAbove-currentDist)/levelAbove;
    
    // dialates the points with the first point in the shape as the origin
    // (also uses a small formula I came up with to make a new origin)
    num pivotX = points.first.x;
    num pivotY = points.first.y;
    for (int w=1; w<size(); ++w) {
      num shrinkX = points[w].x;
      num shrinkY = points[w].y;
      points[w] = new Point(shrinkX - (shrinkX - pivotX)*ratio, 
                            shrinkY - (shrinkY - pivotY)*ratio);
    }
  }
  void draw([_]) {
    var context = canvas.context2D;
    drawBackground(context);
    drawLine(context);
    
    if (useMouse) {
      requestRedraw();
    }
  }
  void drawBackground(CanvasRenderingContext2D context) {
    //resets the background at each level (clearRect may be faster if optimizing)
    context.fillStyle = 'white';
    context.fillRect(0, 0, width, height);
//    context.clearRect(0, 0, width, height);
  }
  void drawLine(CanvasRenderingContext2D context) {
    // initial shape creation according to mouse input
    var rect = canvas.getBoundingClientRect();
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
           ..lineTo(mouse.x - rect.left, mouse.y - rect.top)
           ..stroke();
  }
  void requestRedraw() {
    requestId = window.requestAnimationFrame(draw);
  }
}