import 'dart:html';
import 'koch.dart';

class Mouse {
  CanvasElement canvas;
  var x = 0;
  var y = 0;
  bool on = false;
  
  Mouse(this.canvas) {
    window.onMouseMove.listen(changePos);
    canvas.onMouseOver.listen(isOn);
    canvas.onMouseLeave.listen(isOff);
  }
  void isOn(MouseEvent event) {
    on = true;
  }
  void isOff(MouseEvent event) {
    on = false;
  }
  void changePos(MouseEvent event) {
    x = event.client.x;
    y = event.client.y;
//      pos = new Point(event.client.x, event.client.y);
  }
}