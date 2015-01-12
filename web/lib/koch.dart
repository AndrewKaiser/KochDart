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
  String id = 'copy';
  var onMouseDown;
  var requestId;

  
  Shape.Original(this.canvas) {
    points.clear();
    id = 'original';
  }
  Shape.List(this.points, this.canvas);
  Shape.Copy(Shape old, this.canvas) {
    points.clear();
//    this.canvas  = old.canvas;
    width = old.width;
    height = old.height;
    points.addAll(old.points);
    useMouse = false;
    onMouseDown = null;
    mouse = null;
    
  }

  start() {
    width = canvas.width;
    height = canvas.height;
    mouse = new Mouse(canvas);
    useMouse = true;
    
    onMouseDown = canvas.onMouseDown.listen(addPoint);
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
//    print("$id: $points");
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
  num getAngle(num x, num y) {
    if (x > 0) return atan(y/x);
    if (x < 0 && y >= 0) return atan(y/x) + PI;
    if (x < 0 && y < 0) return atan(y/x) - PI;
    //    if x = 0 then
    if (y > 0) return PI/2;
    if (y < 0) return -PI/2;
    if (y == 0) return null;
  }
  double getBaseDistance() {
    return sqrt(pow(points.first.x-points.last.x,2) + pow(points.first.y-points.last.y,2));
  }
  Point getPoint(int i) {
    return points[i];
  }
  void addPoint(MouseEvent event) {
    if (event.button == 2) return;
    points.add(new Point(event.client.x, event.client.y));
  }
  void translate(int i) {
    num dx = points[i].x - points.first.x;
    num dy = points[i].y - points.first.y;
    for (int w = 0; w < this.size(); ++w) {
      points[w] = new Point(points[w].x+dx, points[w].y+dy);
    }
  }
  void rotate(int i, angle) {
//    num DX = points[i+1].x - points[i].x; 
//    num DY = points[i+1].y - points[i].y;
//    num DX = points[i].x - points[i+1].x; 
//    num DY = points[i].y - points[i+1].y;
//    var newAngle = getAngle(DX,DY);
//    print("($DX, $DY) angle: $newAngle");
//    DX = points.last.x - points.first.x;
//    DY = points.last.x - points.first.y;
//    DX = points.first.x - points.last.x;
//    DY = points.first.y - points.last.x;
//    var oAngle = getAngle(DX,DY);
//    var newAngle = acos(DX/sqrt(pow(DX,2) + pow(DY,2))) - PI;
    
    
//    num angle = (oAngle - newAngle);
//    print("final: $angle, oAngle: $oAngle, newAngle: $newAngle");
    // the point which the others in lines will use as an origin
    
    num cosTheta = cos(angle);
    num sinTheta = sin(angle);
//    print("cos: $cosTheta, sin: $sinTheta");
    // actually rotating all the points
    for (int w=1; w<size(); ++w) {
      num x = cosTheta*(points[w].x-points.first.x) - sinTheta*(points[w].y-points.first.y) + points.first.x;
      num y = sinTheta*(points[w].x-points.first.x) + cosTheta*(points[w].y-points.first.y) + points.first.y;
      points[w] = new Point(x, y);
    }

  }
  void dialate(int i, double levelAbove) {
    var currentDist = sqrt(pow(points[i].x-points[i+1].x,2)
                         + pow(points[i].y-points[i+1].y,2));

    double ratio = (levelAbove-currentDist)/levelAbove;
    num pivotX = points.first.x;
    num pivotY = points.first.y;
    for (int w=1; w<size(); ++w) {
      num shrinkX = points[w].x;
      num shrinkY = points[w].y;
      points[w] = new Point(shrinkX - (shrinkX - pivotX)*ratio, 
                            shrinkY - (shrinkY - pivotY)*ratio);
        // PVector translate(pivotX-);
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

    if (useMouse) {
      context..beginPath()
             ..moveTo(points.last.x, points.last.y)
             ..lineTo(mouse.x, mouse.y)
  //           ..closePath()
             ..stroke();
    }
  }
  void requestRedraw() {
    requestId = window.requestAnimationFrame(draw);
  }
}