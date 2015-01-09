import 'dart:html';
import 'koch.dart';

class Mouse {
  CanvasElement canvas;
  int x = 0;
  int y = 0;
  bool down = false;
  
  Mouse(CanvasElement c) {
    canvas = c;
    
    canvas.onMouseMove.listen(changePos);
    canvas.onMouseDown.listen(buttonPos);
    canvas.onMouseUp.listen(buttonPos);
  }
  bool isDown() {
    return down;
  }
  void buttonPos(MouseEvent event) {
    if (down) down = false;
    else down = true;
  }
  void changePos(MouseEvent event) {
    x = event.client.x;
    y = event.client.y;
//      pos = new Point(event.client.x, event.client.y);
  }
}